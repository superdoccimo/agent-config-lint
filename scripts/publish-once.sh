#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
MODE="${2:-auto}" # auto | --ssh | --https-token

if [[ "${MODE}" != "auto" && "${MODE}" != "--ssh" && "${MODE}" != "--https-token" ]]; then
  echo "usage: ./scripts/publish-once.sh [repo] [auto|--ssh|--https-token]" >&2
  exit 1
fi

if [[ "${MODE}" == "auto" ]]; then
  status_json="$(./scripts/publish-status.sh "${REPO}" --json)"
  ssh_auth="$(echo "$status_json" | sed -n 's/.*"ssh_auth": "\([^"]*\)".*/\1/p' | head -1)"
  token="$(echo "$status_json" | sed -n 's/.*"token": "\([^"]*\)".*/\1/p' | head -1)"

  if [[ "${ssh_auth}" == "ok" ]]; then
    MODE="--ssh"
  elif [[ "${token}" == "ok" ]]; then
    MODE="--https-token"
  else
    echo "No auth method ready (ssh/token)." >&2
    echo "Run: ./scripts/check-github-auth.sh" >&2
    exit 2
  fi
fi

echo "[1/2] preflight"
./scripts/first-publish-check.sh "${REPO}"

echo "[2/2] publish (${MODE})"
./scripts/publish-github.sh "${MODE}"

echo "DONE: first publish completed"
