#!/usr/bin/env bash
set -euo pipefail

if ./scripts/check-github-auth-exit.sh >/dev/null 2>&1; then
  if ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1; then
    echo "auth: READY (ssh)"
  else
    echo "auth: READY (token)"
  fi
  exit 0
fi

echo "auth: NOT_READY"
echo "next: ./scripts/setup-github-auth-quickstart.sh"
exit 1
