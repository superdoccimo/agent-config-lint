#!/usr/bin/env bash
set -euo pipefail

REPO="superdoccimo/agent-config-lint"
BRANCH="master"
USE_SSH="${1:-}" # pass --ssh to force ssh remote

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

if [[ "${USE_SSH}" == "--ssh" ]]; then
  git remote set-url origin "git@github.com:${REPO}.git"
fi

REMOTE_URL="$(git remote get-url origin)"
echo "origin: ${REMOTE_URL}"

if [[ "${REMOTE_URL}" == git@github.com:* ]]; then
  if ! ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1; then
    echo "SSH auth not ready. Run ./scripts/setup-github-auth.sh and add key to GitHub." >&2
    exit 2
  fi
fi

echo "pushing ${BRANCH} to origin..."
git push -u origin "${BRANCH}"

echo "done: https://github.com/${REPO}"
