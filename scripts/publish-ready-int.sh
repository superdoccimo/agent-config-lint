#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
json="$(./scripts/publish-status.sh "${REPO}" --json)"

if echo "$json" | grep -q '"ready": "ok"'; then
  echo "1"
  exit 0
fi

echo "0"
exit 1
