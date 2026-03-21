#!/usr/bin/env bash
set -euo pipefail

REPO="superdoccimo/agent-config-lint"
FORMAT="text" # text|json

for arg in "$@"; do
  case "$arg" in
    --json) FORMAT="json" ;;
    *) REPO="$arg" ;;
  esac
done

git_clean="ng"
repo_exists="ng"
ssh_auth="ng"
token="ng"

if [[ -z "$(git status --porcelain)" ]]; then
  git_clean="ok"
fi

if ./scripts/check-github-repo.sh "${REPO}" >/dev/null 2>&1; then
  repo_exists="ok"
fi

if ssh -T git@github.com -o BatchMode=yes -o StrictHostKeyChecking=accept-new >/dev/null 2>&1; then
  ssh_auth="ok"
fi

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  token="ok"
fi

if [[ "${FORMAT}" == "json" ]]; then
  printf '{\n'
  printf '  "repo": "%s",\n' "${REPO}"
  printf '  "git_clean": "%s",\n' "${git_clean}"
  printf '  "repo_exists": "%s",\n' "${repo_exists}"
  printf '  "ssh_auth": "%s",\n' "${ssh_auth}"
  printf '  "token": "%s"\n' "${token}"
  printf '}\n'
  exit 0
fi

echo "== publish status =="
echo "git_clean=${git_clean}"
echo "repo_exists=${repo_exists}"
echo "ssh_auth=${ssh_auth}"
echo "token=${token}"

echo "-- next steps --"
if [[ "${repo_exists}" != "ok" ]]; then
  echo "1) Create repo: ./scripts/create-github-repo.sh ${REPO} public"
fi
if [[ "${ssh_auth}" != "ok" ]]; then
  echo "2) Add SSH key to GitHub or use GITHUB_TOKEN"
fi
echo "3) Publish: ./scripts/publish-github.sh --ssh (or --https-token)"
