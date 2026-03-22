#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
json="$(./scripts/publish-status.sh "${REPO}" --json)"

pick() {
  local key="$1"
  echo "$json" | sed -n "s/.*\"${key}\": \"\([^\"]*\)\".*/\1/p" | head -1
}

ready="$(pick ready)"
repo_exists="$(pick repo_exists)"
ssh_auth="$(pick ssh_auth)"
token="$(pick token)"

if [[ "$ready" == "ok" ]]; then
  echo "publish: READY ✅  -> ./scripts/publish-once.sh ${REPO}"
  exit 0
fi

msg="publish: NOT_READY ⏳"
if [[ "$repo_exists" != "ok" ]]; then msg+=" [repo]"; fi
if [[ "$ssh_auth" != "ok" && "$token" != "ok" ]]; then msg+=" [auth]"; fi

echo "$msg -> ./scripts/publish-next-action.sh ${REPO}"
exit 1
