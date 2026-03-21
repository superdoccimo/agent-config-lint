#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
VISIBILITY="${2:-public}" # public|private
OWNER="${REPO%%/*}"
NAME="${REPO##*/}"

if [[ "${VISIBILITY}" != "public" && "${VISIBILITY}" != "private" ]]; then
  echo "visibility must be public or private" >&2
  exit 10
fi

# Path A: GitHub CLI
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    if gh repo view "${REPO}" >/dev/null 2>&1; then
      echo "repo already exists: ${REPO}"
      exit 0
    fi
    gh repo create "${REPO}" --"${VISIBILITY}" --confirm
    echo "created: https://github.com/${REPO}"
    exit 0
  fi
fi

# Path B: GitHub API + token fallback
if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Neither authenticated gh nor GITHUB_TOKEN is available." >&2
  echo "Use one of:" >&2
  echo "  1) gh auth login" >&2
  echo "  2) export GITHUB_TOKEN=..." >&2
  exit 2
fi

api="https://api.github.com/user/repos"
private_flag="false"
if [[ "${VISIBILITY}" == "private" ]]; then
  private_flag="true"
fi

payload=$(cat <<JSON
{"name":"${NAME}","private":${private_flag}}
JSON
)

resp_code=$(curl -sS -o /tmp/create_repo_resp.json -w '%{http_code}' \
  -X POST "${api}" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d "${payload}")

if [[ "${resp_code}" == "201" ]]; then
  echo "created: https://github.com/${OWNER}/${NAME}"
  exit 0
fi

if [[ "${resp_code}" == "422" ]]; then
  echo "repo may already exist or name is invalid: ${REPO}" >&2
  cat /tmp/create_repo_resp.json >&2 || true
  exit 3
fi

echo "failed to create repo (HTTP ${resp_code})" >&2
cat /tmp/create_repo_resp.json >&2 || true
exit 4
