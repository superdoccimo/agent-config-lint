#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
MODE="${2:---ssh}" # --ssh | --https-token

if [[ "${MODE}" != "--ssh" && "${MODE}" != "--https-token" ]]; then
  echo "usage: ./scripts/publish-once.sh [repo] [--ssh|--https-token]" >&2
  exit 1
fi

echo "[1/2] preflight"
./scripts/first-publish-check.sh "${REPO}"

echo "[2/2] publish"
./scripts/publish-github.sh "${MODE}"

echo "DONE: first publish completed"
