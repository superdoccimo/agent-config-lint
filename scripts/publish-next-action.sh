#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
json="$(./scripts/publish-status.sh "${REPO}" --json)"

value() {
  local key="$1"
  echo "$json" | sed -n "s/.*\"${key}\": \"\([^\"]*\)\".*/\1/p" | head -1
}

repo_exists="$(value repo_exists)"
ssh_auth="$(value ssh_auth)"
token="$(value token)"
git_clean="$(value git_clean)"
ready="$(value ready)"

if [[ "${ready}" == "ok" ]]; then
  echo "READY: ./scripts/publish-once.sh ${REPO}"
  exit 0
fi

if [[ "${repo_exists}" != "ok" ]]; then
  echo "NEXT: create repo -> ./scripts/create-github-repo.sh ${REPO} public"
  exit 0
fi

if [[ "${ssh_auth}" != "ok" && "${token}" != "ok" ]]; then
  echo "NEXT: configure auth -> ./scripts/github-key-helper.sh (or export GITHUB_TOKEN=...)"
  exit 0
fi

if [[ "${git_clean}" != "ok" ]]; then
  echo "NEXT: commit/stash changes -> git status --short"
  exit 0
fi

echo "NEXT: run publish -> ./scripts/publish-once.sh ${REPO}"
