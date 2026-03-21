#!/usr/bin/env bash
set -euo pipefail

echo "[1/3] ssh key file"
if [[ -f "${HOME}/.ssh/id_ed25519_github_superdoccimo.pub" ]]; then
  echo "OK: ~/.ssh/id_ed25519_github_superdoccimo.pub exists"
else
  echo "NG: ssh key missing. run ./scripts/setup-github-auth.sh" >&2
fi

echo "[2/3] ssh auth"
if ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1; then
  echo "OK: ssh auth ready"
else
  echo "NG: ssh auth not ready (add public key to GitHub settings)" >&2
fi

echo "[3/3] token auth"
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  echo "OK: GITHUB_TOKEN is set"
else
  echo "INFO: GITHUB_TOKEN is not set (only needed for --https-token mode)"
fi
