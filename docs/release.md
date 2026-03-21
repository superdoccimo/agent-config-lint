# Release Checklist

## 1) Pre-release
- Run combined preflight: `./scripts/first-publish-check.sh` (includes consolidated readiness check)
- Check publish blockers quickly: `./scripts/publish-status.sh` (or `--json`)
- Generate shareable markdown: `./scripts/publish-report.sh`
- Show single immediate action: `./scripts/publish-next-action.sh`
- Or run individually:
  - tests: `python -m pytest -q`
  - lint command on sample workspace
  - confirm README links and commands
- Prepare launch copy and repo subtitle from `docs/launch-kit.md`

## 2) First publish
Safe one-shot flow (auto picks ssh/token):
```bash
./scripts/publish-once.sh superdoccimo/agent-config-lint
```

Explicit mode:
```bash
./scripts/publish-once.sh superdoccimo/agent-config-lint --ssh
```

Or publish directly:
```bash
./scripts/publish-github.sh --ssh
# or
./scripts/publish-github.sh --https-token
```

If authentication fails:
- set up GitHub auth (`gh auth login` or credential helper)
- then re-run publish

## 3) Tag
```bash
git tag -a v0.1.0 -m "v0.1.0"
git push origin v0.1.0
```

## 4) GitHub Release
- Create release from tag
- Include changelog summary
- Mention key features:
  - severity separation (warning/error)
  - health score
  - rule migration helper
  - rule sample output
  - pre-commit bootstrap
- Reuse the release note draft in `docs/launch-kit.md`

## 5) Post-release
- Bump version in `pyproject.toml`
- Start next milestone notes in `PROGRESS.md`
- Post launch copy to GitHub Release, X / Threads, and relevant OpenClaw or agent-dev communities
