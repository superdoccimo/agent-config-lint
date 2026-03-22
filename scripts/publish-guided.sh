#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

echo "== Guided First Publish =="
echo

echo "Step 1: check current blockers"
status_json="$(./scripts/publish-status.sh "${REPO}" --json)"
echo "$status_json"
echo

if echo "$status_json" | grep -q '"git_clean": "ng"'; then
  echo "Step 1.5: working tree is dirty"
  echo "- Run: git status --short"
  echo "- Commit/stash changes, then re-run this script."
  exit 3
fi

echo "Step 2: ensure auth is ready"
if ! ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1 && [[ -z "${GITHUB_TOKEN:-}" ]]; then
  ./scripts/github-key-helper.sh || true
  echo
  echo "After registering the key on GitHub (or exporting GITHUB_TOKEN), re-run this script."
  exit 2
fi

echo "Step 3: final one-shot publish"
./scripts/publish-once.sh "${REPO}"
