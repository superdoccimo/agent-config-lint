#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
json="$(./scripts/publish-status.sh "${REPO}" --json)"

if echo "$json" | grep -q '"ready": "ok"'; then
  echo "yes"
  exit 0
fi

echo "no"
exit 1
