#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
json="$(./scripts/publish-status.sh "${REPO}" --json)"
count="$(printf '%s
' "$json" | python3 -c 'import json,sys; data=json.load(sys.stdin); print(len(data.get("blockers", [])))')"

echo "$count"
