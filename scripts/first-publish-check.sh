#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-superdoccimo/agent-config-lint}"

ok=true

echo "== first publish preflight =="

echo "[1] tests"
if python -m pytest -q >/dev/null 2>&1; then
  echo "  OK"
else
  echo "  NG: tests failed"
  ok=false
fi

echo "[2] git clean"
if [[ -z "$(git status --porcelain)" ]]; then
  echo "  OK"
else
  echo "  NG: working tree dirty"
  ok=false
fi

echo "[3] repo existence"
if ./scripts/check-github-repo.sh "${REPO}" >/dev/null 2>&1; then
  echo "  OK"
else
  echo "  NG: target repo unreachable"
  ok=false
fi

echo "[4] auth diagnostics"
./scripts/check-github-auth.sh || true

if [[ "${ok}" == true ]]; then
  echo "READY: run ./scripts/publish-github.sh --ssh (or --https-token)"
  exit 0
fi

echo "NOT READY: fix NG items above"
exit 1
