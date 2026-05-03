#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from _github import GitHubCliError, ensure_gh_authenticated, graphql

MUTATION = """\
mutation(
  $threadId: ID!,
  $body: String!
) {
  addPullRequestReviewThreadReply(
    input: {
      pullRequestReviewThreadId: $threadId,
      body: $body
    }
  ) {
    comment {
      id
      url
      body
      createdAt
      author {
        login
      }
    }
  }
}
"""


def build_payload(thread_id: str, body: str) -> dict[str, object]:
    return {
        "query": MUTATION,
        "variables": {
            "threadId": thread_id,
            "body": body,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Reply to a GitHub PR review thread.")
    parser.add_argument("--thread-id", required=True, help="Node ID of the review thread.")
    parser.add_argument("--body", required=True, help="Reply body.")
    parser.add_argument("--dry-run", action="store_true", help="Print the payload without mutating GitHub.")
    args = parser.parse_args()

    payload = build_payload(args.thread_id, args.body)
    if args.dry_run:
        json.dump(payload, sys.stdout, indent=2)
        sys.stdout.write("\n")
        return

    try:
        ensure_gh_authenticated()
        result = graphql(
            payload["query"],
            payload["variables"],  # type: ignore[arg-type]
        )
    except GitHubCliError as exc:
        print(str(exc), file=sys.stderr)
        sys.exit(1)

    comment = result["data"]["addPullRequestReviewThreadReply"]["comment"]
    json.dump(comment, sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
