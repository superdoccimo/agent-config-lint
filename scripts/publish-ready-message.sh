#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
json="$(./scripts/publish-status.sh "${REPO}" --json)"

if echo "$json" | grep -q '"ready": "ok"'; then
  cat <<EOF
✅ agent-config-lint publish準備OK
repo: ${REPO}
次: ./scripts/publish-once.sh ${REPO}
EOF
  exit 0
fi

cat <<EOF
⏳ agent-config-lint publish未準備
repo: ${REPO}
次: ./scripts/publish-next-action.sh ${REPO}
EOF
exit 1
