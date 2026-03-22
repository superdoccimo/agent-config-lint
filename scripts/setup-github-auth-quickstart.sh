#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

echo "== GitHub Auth Quickstart =="
echo

echo "[1/4] Open GitHub SSH keys page"
./scripts/open-github-keys.sh || true

echo

echo "[2/4] Show SSH public key"
./scripts/github-key-helper.sh || true

echo

echo "[3/4] Current auth status"
./scripts/check-github-auth.sh || true

echo

echo "[4/4] Next action"
./scripts/publish-next-action.sh "${REPO}" || true
