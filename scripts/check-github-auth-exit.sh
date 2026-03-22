#!/usr/bin/env bash
set -euo pipefail

# Exit 0 if at least one auth method is ready (SSH or token), else 1.

ssh_ok=1
token_ok=1

if ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1; then
  ssh_ok=0
fi

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  token_ok=0
fi

if [[ ${ssh_ok} -eq 0 || ${token_ok} -eq 0 ]]; then
  echo "auth-ready"
  exit 0
fi

echo "auth-not-ready"
exit 1
