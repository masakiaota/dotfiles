#!/usr/bin/env python3
from __future__ import annotations

import json
import subprocess
from dataclasses import dataclass
from typing import Any


class GitHubCliError(RuntimeError):
    """Raised when a gh command fails or returns invalid data."""


@dataclass(frozen=True)
class PullRequestRef:
    owner: str
    repo: str
    number: int
    url: str
    title: str


def _format_arg(value: Any) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value)


def run_command(cmd: list[str], stdin: str | None = None) -> str:
    process = subprocess.run(
        cmd,
        input=stdin,
        capture_output=True,
        text=True,
    )
    if process.returncode != 0:
        stderr = process.stderr.strip() or process.stdout.strip()
        raise GitHubCliError(f"Command failed: {' '.join(cmd)}\n{stderr}")
    return process.stdout


def run_json(cmd: list[str], stdin: str | None = None) -> dict[str, Any]:
    output = run_command(cmd, stdin=stdin)
    try:
        return json.loads(output)
    except json.JSONDecodeError as exc:
        raise GitHubCliError(f"Failed to parse JSON output.\n{output}") from exc


def ensure_gh_authenticated() -> None:
    try:
        run_command(["gh", "auth", "status"])
    except GitHubCliError as exc:
        raise GitHubCliError(
            "gh auth status failed. Run `gh auth login` and retry."
        ) from exc


def get_current_pr_ref() -> PullRequestRef:
    try:
        payload = run_json(
            [
                "gh",
                "pr",
                "view",
                "--json",
                "number,url,title,headRepositoryOwner,headRepository",
            ]
        )
    except GitHubCliError as exc:
        if "no pull requests found for branch" in str(exc).lower():
            raise GitHubCliError(
                "No open pull request is associated with the current branch."
            ) from exc
        raise
    try:
        return PullRequestRef(
            owner=payload["headRepositoryOwner"]["login"],
            repo=payload["headRepository"]["name"],
            number=int(payload["number"]),
            url=payload["url"],
            title=payload["title"],
        )
    except (KeyError, TypeError, ValueError) as exc:
        raise GitHubCliError(
            "Failed to resolve the open PR for the current branch."
        ) from exc


def graphql(query: str, variables: dict[str, Any] | None = None) -> dict[str, Any]:
    cmd = ["gh", "api", "graphql", "-F", "query=@-"]
    for key, value in (variables or {}).items():
        if value is None:
            continue
        cmd.extend(["-F", f"{key}={_format_arg(value)}"])

    payload = run_json(cmd, stdin=query)
    if payload.get("errors"):
        raise GitHubCliError(
            "GitHub GraphQL error:\n" + json.dumps(payload["errors"], indent=2)
        )
    return payload
