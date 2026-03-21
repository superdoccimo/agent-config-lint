#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

json="$(./scripts/publish-status.sh "${REPO}" --json)"

extract() {
  local key="$1"
  echo "$json" | sed -n "s/.*\"${key}\": \"\([^\"]*\)\".*/\1/p" | head -1
}

repo="$(extract repo)"
git_clean="$(extract git_clean)"
repo_exists="$(extract repo_exists)"
ssh_auth="$(extract ssh_auth)"
token="$(extract token)"
ready="$(extract ready)"

cat <<EOF
# Publish Status Report

- repo: ${repo}
- git_clean: ${git_clean}
- repo_exists: ${repo_exists}
- ssh_auth: ${ssh_auth}
- token: ${token}
- ready: ${ready}

## Next Actions
EOF

if [[ "${repo_exists}" != "ok" ]]; then
  echo "1. Create repository: \`./scripts/create-github-repo.sh ${repo} public\`"
fi
if [[ "${ssh_auth}" != "ok" && "${token}" != "ok" ]]; then
  echo "2. Configure auth: add SSH key to GitHub or set \`GITHUB_TOKEN\`"
fi
echo "3. Publish: \`./scripts/publish-github.sh --ssh\` (or \`--https-token\`)"
