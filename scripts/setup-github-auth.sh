#!/usr/bin/env bash
set -euo pipefail

KEY_PATH="${HOME}/.ssh/id_ed25519_github_superdoccimo"
EMAIL="${1:-mamu@local}"

mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"

if [[ ! -f "${KEY_PATH}" ]]; then
  ssh-keygen -t ed25519 -C "${EMAIL}" -f "${KEY_PATH}" -N ""
fi

if ! grep -q "id_ed25519_github_superdoccimo" "${HOME}/.ssh/config" 2>/dev/null; then
  cat >> "${HOME}/.ssh/config" <<'EOF'

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github_superdoccimo
  IdentitiesOnly yes
EOF
  chmod 600 "${HOME}/.ssh/config"
fi

echo "--- PUBLIC KEY (add to GitHub > Settings > SSH and GPG keys) ---"
cat "${KEY_PATH}.pub"
echo "---"
echo "After adding key, test with: ssh -T git@github.com"
