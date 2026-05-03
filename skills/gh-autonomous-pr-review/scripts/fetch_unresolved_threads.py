#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
import textwrap
from pathlib import Path
from typing import Any

sys.path.insert(0, str(Path(__file__).resolve().parent))

from _github import GitHubCliError, ensure_gh_authenticated, get_current_pr_ref, graphql

QUERY = """\
query(
  $owner: String!,
  $repo: String!,
  $number: Int!,
  $threadsCursor: String
) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      id
      number
      url
      title
      reviewThreads(first: 100, after: $threadsCursor) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          originalLine
          startLine
          originalStartLine
          diffSide
          startDiffSide
          comments(first: 100) {
            nodes {
              id
              url
              body
              bodyText
              createdAt
              updatedAt
              publishedAt
              author {
                login
              }
            }
          }
        }
      }
    }
  }
}
"""


def normalize_comment(comment: dict[str, Any]) -> dict[str, Any]:
    author = comment.get("author") or {}
    return {
        "id": comment.get("id"),
        "url": comment.get("url"),
        "body": comment.get("body"),
        "body_text": comment.get("bodyText"),
        "created_at": comment.get("createdAt"),
        "updated_at": comment.get("updatedAt"),
        "published_at": comment.get("publishedAt"),
        "author": author.get("login"),
    }


def normalize_thread(thread: dict[str, Any]) -> dict[str, Any]:
    comments = [normalize_comment(comment) for comment in thread["comments"]["nodes"]]
    participants = sorted({comment["author"] for comment in comments if comment["author"]})
    latest_comment = comments[-1] if comments else None
    return {
        "id": thread.get("id"),
        "path": thread.get("path"),
        "line": thread.get("line"),
        "original_line": thread.get("originalLine"),
        "start_line": thread.get("startLine"),
        "original_start_line": thread.get("originalStartLine"),
        "diff_side": thread.get("diffSide"),
        "start_diff_side": thread.get("startDiffSide"),
        "is_outdated": thread.get("isOutdated", False),
        "comments": comments,
        "latest_comment": latest_comment,
        "participants": participants,
    }


def fetch_unresolved_threads() -> dict[str, Any]:
    ensure_gh_authenticated()
    pr = get_current_pr_ref()

    unresolved_threads: list[dict[str, Any]] = []
    cursor: str | None = None

    while True:
        payload = graphql(
            QUERY,
            {
                "owner": pr.owner,
                "repo": pr.repo,
                "number": pr.number,
                "threadsCursor": cursor,
            },
        )
        pull_request = payload["data"]["repository"]["pullRequest"]
        threads = pull_request["reviewThreads"]

        for thread in threads["nodes"]:
            if thread.get("isResolved"):
                continue
            unresolved_threads.append(normalize_thread(thread))

        if not threads["pageInfo"]["hasNextPage"]:
            break
        cursor = threads["pageInfo"]["endCursor"]

    return {
        "pull_request": {
            "owner": pr.owner,
            "repo": pr.repo,
            "number": pr.number,
            "url": pr.url,
            "title": pr.title,
        },
        "threads": unresolved_threads,
    }


def pretty_print(payload: dict[str, Any]) -> str:
    pull_request = payload["pull_request"]
    lines = [
        f"PR #{pull_request['number']}: {pull_request['title']}",
        pull_request["url"],
        "",
    ]

    threads = payload["threads"]
    if not threads:
        lines.append("No unresolved review threads.")
        return "\n".join(lines)

    for index, thread in enumerate(threads, start=1):
        location = thread["path"] or "<no-path>"
        if thread["line"] is not None:
            location = f"{location}:{thread['line']}"
        marker = "outdated" if thread["is_outdated"] else "active"
        lines.append(f"[{index}] {thread['id']} ({marker})")
        lines.append(f"  location: {location}")
        if thread["participants"]:
            lines.append(f"  participants: {', '.join(thread['participants'])}")
        latest = thread["latest_comment"]
        if latest:
            author = latest["author"] or "unknown"
            excerpt = textwrap.shorten(
                (latest["body_text"] or latest["body"] or "").replace("\n", " "),
                width=120,
                placeholder="...",
            )
            lines.append(f"  latest: {author}: {excerpt}")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Fetch unresolved review threads for the open PR on the current branch."
    )
    output_group = parser.add_mutually_exclusive_group()
    output_group.add_argument("--json", action="store_true", help="Print JSON output.")
    output_group.add_argument("--pretty", action="store_true", help="Print a human-readable summary.")
    args = parser.parse_args()

    try:
        payload = fetch_unresolved_threads()
    except GitHubCliError as exc:
        print(str(exc), file=sys.stderr)
        sys.exit(1)

    if args.pretty:
        sys.stdout.write(pretty_print(payload))
        return

    json.dump(payload, sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
