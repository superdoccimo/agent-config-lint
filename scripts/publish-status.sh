#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

echo "== publish status =="

if [[ -z "$(git status --porcelain)" ]]; then
  echo "git_clean=ok"
else
  echo "git_clean=ng"
fi

if ./scripts/check-github-repo.sh "${REPO}" >/dev/null 2>&1; then
  echo "repo_exists=ok"
else
  echo "repo_exists=ng"
fi

if ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1; then
  echo "ssh_auth=ok"
else
  echo "ssh_auth=ng"
fi

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  echo "token=ok"
else
  echo "token=ng"
fi

echo "-- next steps --"
if ! ./scripts/check-github-repo.sh "${REPO}" >/dev/null 2>&1; then
  echo "1) Create repo: ./scripts/create-github-repo.sh ${REPO} public"
fi
if ! ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1; then
  echo "2) Add SSH key to GitHub or use GITHUB_TOKEN"
fi
echo "3) Publish: ./scripts/publish-github.sh --ssh (or --https-token)"
