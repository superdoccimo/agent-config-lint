#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

cat <<EOF
Human steps to unblock first publish:

1) Register SSH key on GitHub
   - Open: https://github.com/settings/keys
   - Add this key:
$(cat "${HOME}/.ssh/id_ed25519_github_superdoccimo.pub" 2>/dev/null || echo "(key not found: run ./scripts/setup-github-auth.sh)")

2) Verify auth
   ./scripts/check-github-auth.sh

3) Publish
   ./scripts/publish-once.sh ${REPO}
EOF
