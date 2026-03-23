#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

if ./scripts/check-github-auth-exit.sh >/dev/null 2>&1; then
  cat <<EOF
agent-config-lint 公開準備:
- 認証: OK
- 次: ./scripts/publish-once.sh ${REPO}
EOF
  exit 0
fi

cat <<EOF
agent-config-lint 公開準備:
- 認証: NG
- 次: ./scripts/setup-github-auth-quickstart.sh ${REPO}
EOF
exit 1
