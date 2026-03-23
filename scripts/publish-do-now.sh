#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

if ./scripts/publish-ready-exit.sh "${REPO}" >/dev/null 2>&1; then
  echo "./scripts/publish-once.sh ${REPO}"
  exit 0
fi

if ./scripts/check-github-auth-exit.sh >/dev/null 2>&1; then
  echo "./scripts/publish-once.sh ${REPO}"
  exit 0
fi

echo "./scripts/setup-github-auth-quickstart.sh ${REPO}"
exit 1
