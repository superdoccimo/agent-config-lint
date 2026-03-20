#!/usr/bin/env bash
set -euo pipefail

REPO="superdoccimo/agent-config-lint"
BRANCH="master"

if ! command -v git >/dev/null 2>&1; then
  echo "git not found" >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "run inside a git repository" >&2
  exit 1
fi

if [[ -z "$(git status --porcelain)" ]]; then
  echo "working tree clean"
else
  echo "working tree is dirty. commit/stash first." >&2
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin "https://github.com/${REPO}.git"
fi

echo "pushing ${BRANCH} to origin..."
git push -u origin "${BRANCH}"

echo "done: https://github.com/${REPO}"
