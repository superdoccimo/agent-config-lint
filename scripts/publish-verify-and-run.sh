#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

if ./scripts/publish-ready-exit.sh "${REPO}" >/dev/null 2>&1; then
  exec ./scripts/publish-once.sh "${REPO}"
fi

echo "publish not ready"
./scripts/publish-do-now.sh "${REPO}" || true
exit 1
