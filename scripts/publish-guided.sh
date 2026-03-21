#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

echo "== Guided First Publish =="
echo

echo "Step 1: check current blockers"
./scripts/publish-status.sh "${REPO}" || true
echo

echo "Step 2: if auth not ready, run helper"
if ! ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1 && [[ -z "${GITHUB_TOKEN:-}" ]]; then
  ./scripts/github-key-helper.sh || true
  echo
  echo "After registering the key on GitHub, re-run this script."
  exit 2
fi

echo "Step 3: final one-shot publish"
./scripts/publish-once.sh "${REPO}"
