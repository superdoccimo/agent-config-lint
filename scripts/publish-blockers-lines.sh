#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"
./scripts/publish-status.sh "${REPO}" --json \
  | python3 -c 'import json,sys; data=json.load(sys.stdin); print("\n".join(data.get("blockers", [])))'
