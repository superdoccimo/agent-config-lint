#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
json="$(./scripts/publish-status.sh "${REPO}" --json)"

if echo "$json" | grep -q '"ready": "ok"'; then
  echo "🟢 publish ready"
  exit 0
fi

echo "🟡 publish not ready"
exit 1
