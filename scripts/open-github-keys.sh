#!/usr/bin/env bash
set -euo pipefail

URL="https://github.com/settings/keys"

if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$URL" >/dev/null 2>&1 &
  echo "opened: $URL"
  exit 0
fi

if command -v open >/dev/null 2>&1; then
  open "$URL" >/dev/null 2>&1 &
  echo "opened: $URL"
  exit 0
fi

echo "open this URL manually: $URL"
