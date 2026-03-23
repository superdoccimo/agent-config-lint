#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

if ./scripts/check-github-auth-exit.sh >/dev/null 2>&1; then
  echo "GitHub認証は通ってる。次はこれ: ./scripts/publish-once.sh ${REPO}"
  exit 0
fi

echo "GitHub認証がまだ。次はこれ: ./scripts/setup-github-auth-quickstart.sh ${REPO}"
exit 1
