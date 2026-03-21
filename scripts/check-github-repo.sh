#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
URL="https://github.com/${REPO}.git"

if git ls-remote "${URL}" HEAD >/dev/null 2>&1; then
  echo "OK: repository exists and is reachable -> ${URL}"
  exit 0
fi

echo "NG: repository not reachable -> ${URL}"
echo "Possible reasons:"
echo "- repository not created yet"
echo "- network issue"
echo "- private repo without auth"
exit 1
