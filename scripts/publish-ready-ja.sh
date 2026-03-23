#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

if ./scripts/publish-ready-exit.sh "${REPO}" >/dev/null 2>&1; then
  echo "公開OK → ./scripts/publish-once.sh ${REPO}"
  exit 0
fi

echo "公開まだ → ./scripts/publish-short-ja.sh ${REPO}"
exit 1
