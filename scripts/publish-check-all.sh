#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

echo "== publish check all =="
./scripts/publish-status.sh "${REPO}" || true
./scripts/publish-brief.sh "${REPO}" || true
./scripts/publish-ready-message.sh "${REPO}" || true
./scripts/publish-next-action.sh "${REPO}" || true
./scripts/publish-ready-exit.sh "${REPO}" || true
./scripts/check-github-auth.sh || true
./scripts/check-github-auth-exit.sh || true
./scripts/publish-human-steps.sh "${REPO}" || true
