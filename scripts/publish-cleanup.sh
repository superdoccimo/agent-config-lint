#!/usr/bin/env bash
set -euo pipefail

echo "== publish cleanup helper =="

if [[ -z "$(git status --porcelain)" ]]; then
  echo "working tree clean"
  exit 0
fi

echo "working tree dirty:"
git status --short

echo
echo "suggested actions:"
echo "1) commit changes: git add -A && git commit -m 'chore: prepare publish'"
echo "2) or stash changes: git stash push -u -m 'publish-temp'"
echo "3) re-check: ./scripts/publish-status.sh"
