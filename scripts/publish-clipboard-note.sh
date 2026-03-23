#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

if ./scripts/check-github-auth-exit.sh >/dev/null 2>&1; then
  printf '%s' "認証OK → ./scripts/publish-once.sh ${REPO}"
  exit 0
fi

printf '%s' "認証NG → ./scripts/setup-github-auth-quickstart.sh ${REPO}"
exit 1
