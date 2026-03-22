#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
agent-config-lint publish helpers

Core:
  ./scripts/publish-dashboard.sh [repo]
  ./scripts/publish-guided.sh [repo]
  ./scripts/publish-once.sh [repo] [auto|--ssh|--https-token]

Diagnostics:
  ./scripts/publish-status.sh [repo] [--json]
  ./scripts/publish-brief.sh [repo]
  ./scripts/publish-ready-message.sh [repo]
  ./scripts/publish-ready-exit.sh [repo]
  ./scripts/publish-next-action.sh [repo]
  ./scripts/publish-check-all.sh [repo]

Auth:
  ./scripts/check-github-auth.sh
  ./scripts/check-github-auth-exit.sh
  ./scripts/setup-github-auth-quickstart.sh [repo]
  ./scripts/open-github-keys.sh
  ./scripts/github-key-helper.sh

Repo:
  ./scripts/check-github-repo.sh [owner/repo]
  ./scripts/create-github-repo.sh [owner/repo] [public|private]

Other:
  ./scripts/publish-cleanup.sh
  ./scripts/publish-human-steps.sh [repo]
EOF
