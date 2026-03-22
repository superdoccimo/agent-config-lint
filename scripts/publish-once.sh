#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
MODE="${2:-auto}" # auto | --ssh | --https-token

if [[ "${MODE}" != "auto" && "${MODE}" != "--ssh" && "${MODE}" != "--https-token" ]]; then
  echo "usage: ./scripts/publish-once.sh [repo] [auto|--ssh|--https-token]" >&2
  exit 1
fi

if [[ "${MODE}" == "auto" ]]; then
  if ./scripts/check-github-auth-exit.sh >/dev/null 2>&1; then
    if ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1; then
      MODE="--ssh"
    else
      MODE="--https-token"
    fi
  else
    echo "No auth method ready (ssh/token)." >&2
    echo "Run: ./scripts/setup-github-auth-quickstart.sh ${REPO}" >&2
    exit 2
  fi
fi

echo "[1/2] preflight"
./scripts/first-publish-check.sh "${REPO}"

echo "[2/2] publish (${MODE})"
./scripts/publish-github.sh "${MODE}"

echo "DONE: first publish completed"
