# agent-config-lint

Lint and validate AI agent workspace configs (`HEARTBEAT.md`, `AGENTS.md`, `SOUL.md`, `TODO.md`).

## Why
Agent setups often fail silently due to contradictory instructions or missing files.
This tool catches common misconfigurations before runtime.

## Quick Start
```bash
python3 src/main.py --workspace /home/mamu/.openclaw/workspace
```

## Checks (initial)
- required files existence
- HEARTBEAT anti-patterns (contains only HEARTBEAT_OK flow)
- TODO has at least one active task
- AGENTS safety hints present
