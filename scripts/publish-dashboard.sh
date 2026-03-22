#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

echo "=== publish dashboard: ${REPO} ==="
./scripts/publish-brief.sh "${REPO}" || true
echo
./scripts/publish-ready-message.sh "${REPO}" || true
echo
./scripts/publish-next-action.sh "${REPO}" || true
