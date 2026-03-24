# Publish Helpers Map

`agent-config-lint` first-publish helper scripts (quick reference).

For a quick list from terminal:
- `./scripts/publish-help.sh`

## Status / diagnostics
- `./scripts/publish-dashboard.sh [repo]`
- `./scripts/publish-check-all.sh [repo]` (full snapshot)
- `./scripts/publish-status.sh [repo] [--json]`
- `./scripts/publish-status-ja.sh [repo]`
- `./scripts/publish-status-emoji.sh [repo]`
- `./scripts/publish-status-symbol.sh [repo]`
- `./scripts/publish-status-icon.sh [repo]`
- `./scripts/publish-blockers-count.sh [repo]`
- `./scripts/publish-ready-mark.sh [repo]`
- `./scripts/publish-brief.sh [repo]`
- `./scripts/publish-ready-message.sh [repo]`
- `./scripts/publish-ready-exit.sh [repo]`

## Auth
- `./scripts/check-github-auth.sh`
- `./scripts/check-github-auth-exit.sh`
- `./scripts/publish-auth-status.sh`
- `./scripts/publish-telegram-note.sh [repo]`
- `./scripts/open-github-keys.sh`
- `./scripts/github-key-helper.sh`
- `./scripts/setup-github-auth-quickstart.sh [repo]`

## Repo checks / creation
- `./scripts/check-github-repo.sh [owner/repo]`
- `./scripts/create-github-repo.sh [owner/repo] [public|private]`

## Publish flows
- `./scripts/publish-next-action.sh [repo]`
- `./scripts/publish-next-human-step.sh [repo]` (Japanese one-line next step)
- `./scripts/publish-short-ja.sh [repo]` (ultra-short Japanese next step)
- `./scripts/publish-ready-ja.sh [repo]` (ready/not-ready in Japanese)
- `./scripts/publish-clipboard-note.sh [repo]` (single-line note without trailing newline)
- `./scripts/publish-do-now.sh [repo]` (just print the single command to run now)
- `./scripts/publish-verify-and-run.sh [repo]` (run publish only when ready)
- `./scripts/publish-cleanup.sh`
- `./scripts/publish-human-steps.sh [repo]`
- `./scripts/publish-guided.sh [repo]`
- `./scripts/publish-once.sh [repo] [auto|--ssh|--https-token]`
- `./scripts/publish-github.sh [--ssh|--https-token|--dry-run]`
