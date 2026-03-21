#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
VISIBILITY="${2:-public}" # public|private

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install GitHub CLI first." >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "gh is not authenticated. Run: gh auth login" >&2
  exit 2
fi

OWNER="${REPO%%/*}"
NAME="${REPO##*/}"

if gh repo view "${REPO}" >/dev/null 2>&1; then
  echo "repo already exists: ${REPO}"
  exit 0
fi

gh repo create "${REPO}" --"${VISIBILITY}" --confirm

echo "created: https://github.com/${REPO}"
