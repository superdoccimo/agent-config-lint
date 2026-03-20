# agent-config-lint

Lint and validate AI agent workspace configs (`HEARTBEAT.md`, `AGENTS.md`, `SOUL.md`, `TODO.md`).

## Why
Agent setups often fail silently due to contradictory instructions or missing files.
This tool catches common misconfigurations before runtime.

## Quick Start
```bash
python3 src/main.py --workspace /home/mamu/.openclaw/workspace
```

## JSON Output
```bash
python3 src/main.py --workspace /home/mamu/.openclaw/workspace --format json
```

## Rules Externalization
Default rules are stored in:
- `rules/default.json`
- `rules/openclaw.json` (OpenClaw workspace tuned)

You can pass a custom rules file:
```bash
python3 src/main.py --workspace /path/to/workspace --rules /path/to/rules.json
```

## Severity
Each rule can emit:
- `warning`
- `error`

`error` affects exit code (non-zero). `warning` keeps exit code zero.

## Health Score
The linter reports a simple health score in range `0-100`.

- start: 100
- each error: -20
- each warning: -7

Use it as a quick signal for drift/regression in agent config quality.

## CI (GitHub Actions)
A sample workflow is included:
- `.github/workflows/lint.yml`

## Checks (initial)
- required files existence
- HEARTBEAT anti-patterns (contains only HEARTBEAT_OK flow)
- TODO has at least one active task
- AGENTS safety hints present
- TODO contradiction detection (same task marked active and done)

## pre-commit Integration
```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```
