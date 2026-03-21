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
ready="ng"

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

if [[ "${git_clean}" == "ok" && "${repo_exists}" == "ok" && ( "${ssh_auth}" == "ok" || "${token}" == "ok" ) ]]; then
  ready="ok"
fi

blockers=()
if [[ "${git_clean}" != "ok" ]]; then blockers+=("working_tree_dirty"); fi
if [[ "${repo_exists}" != "ok" ]]; then blockers+=("repo_missing_or_unreachable"); fi
if [[ "${ssh_auth}" != "ok" && "${token}" != "ok" ]]; then blockers+=("no_auth_method"); fi

if [[ "${FORMAT}" == "json" ]]; then
  printf '{\n'
  printf '  "repo": "%s",\n' "${REPO}"
  printf '  "git_clean": "%s",\n' "${git_clean}"
  printf '  "repo_exists": "%s",\n' "${repo_exists}"
  printf '  "ssh_auth": "%s",\n' "${ssh_auth}"
  printf '  "token": "%s",\n' "${token}"
  printf '  "ready": "%s",\n' "${ready}"
  printf '  "blockers": ['
  for i in "${!blockers[@]}"; do
    if [[ $i -gt 0 ]]; then printf ', '; fi
    printf '"%s"' "${blockers[$i]}"
  done
  printf ']\n'
  printf '}\n'
  exit 0
fi

echo "== publish status =="
echo "git_clean=${git_clean}"
echo "repo_exists=${repo_exists}"
echo "ssh_auth=${ssh_auth}"
echo "token=${token}"
echo "ready=${ready}"

if [[ ${#blockers[@]} -gt 0 ]]; then
  echo "blockers=${blockers[*]}"
fi

echo "-- next steps --"
if [[ "${repo_exists}" != "ok" ]]; then
  echo "1) Create repo: ./scripts/create-github-repo.sh ${REPO} public"
fi
if [[ "${ssh_auth}" != "ok" && "${token}" != "ok" ]]; then
  echo "2) Add SSH key to GitHub or set GITHUB_TOKEN"
fi
echo "3) Publish: ./scripts/publish-github.sh --ssh (or --https-token)"
