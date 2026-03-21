#!/usr/bin/env bash
set -euo pipefail

KEY_PATH="${HOME}/.ssh/id_ed25519_github_superdoccimo.pub"

if [[ ! -f "${KEY_PATH}" ]]; then
  echo "SSH public key not found: ${KEY_PATH}" >&2
  echo "Run: ./scripts/setup-github-auth.sh" >&2
  exit 1
fi

echo "GitHub SSH key setup helper"
echo "1) Open: https://github.com/settings/keys"
echo "2) Click: New SSH key"
echo "3) Paste the key below"
echo
cat "${KEY_PATH}"
echo

if command -v xclip >/dev/null 2>&1; then
  cat "${KEY_PATH}" | xclip -selection clipboard
  echo "(copied to clipboard via xclip)"
elif command -v wl-copy >/dev/null 2>&1; then
  cat "${KEY_PATH}" | wl-copy
  echo "(copied to clipboard via wl-copy)"
elif command -v pbcopy >/dev/null 2>&1; then
  cat "${KEY_PATH}" | pbcopy
  echo "(copied to clipboard via pbcopy)"
else
  echo "(clipboard tool not found; copied output manually)"
fi
