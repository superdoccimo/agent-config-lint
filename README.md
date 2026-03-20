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

You can pass a custom rules file:
```bash
python3 src/main.py --workspace /path/to/workspace --rules /path/to/rules.json
```

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
