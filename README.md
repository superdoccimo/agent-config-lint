# agent-config-lint

Lint and validate AI agent workspace configs (`HEARTBEAT.md`, `AGENTS.md`, `SOUL.md`, `TODO.md`).

## Why
Agent setups often fail silently due to contradictory instructions or missing files.
This tool catches common misconfigurations before runtime.

## Quick Start
```bash
python3 src/main.py --workspace /home/mamu/.openclaw/workspace
```

## CLI Package
```bash
pip install -e .
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json
```

## JSON Output
```bash
python3 src/main.py --workspace /home/mamu/.openclaw/workspace --format json
```

## Rules Externalization
Default rules are stored in:
- `rules/default.json`
- `rules/openclaw.json` (OpenClaw workspace tuned)

Detailed reference:
- `docs/rules.md`

Rule migration helper (fills new fields like severity defaults):

```bash
agent-config-lint --workspace /path/to/workspace --rules old-rules.json --migrate-rules-out migrated-rules.json
```

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
- each error: -20 (default)
- each warning: -7 (default)

Use it as a quick signal for drift/regression in agent config quality.
You can tune weights:

```bash
agent-config-lint --workspace /path/to/workspace --error-weight 15 --warn-weight 3 --format json
```

## CI (GitHub Actions)
A sample workflow is included:
- `.github/workflows/lint.yml`

## Sample Violation Workspace
Use `examples/bad_workspace/` to test warning/error output quickly.

```bash
python3 src/main.py --workspace examples/bad_workspace --rules rules/openclaw.json --format json
```

## Checks (initial)
- required files existence
- HEARTBEAT anti-patterns (contains only HEARTBEAT_OK flow)
- TODO has at least one active task
- AGENTS safety hints present
- TODO contradiction detection (same task marked active and done)

## Rule Samples (per rule)
Need a starter JSON for a specific rule?

```bash
agent-config-lint --workspace . --print-rule-sample heartbeat_over_ack
agent-config-lint --workspace . --print-rule-sample file_contains
```

Available samples:
- `required_files`
- `heartbeat_over_ack`
- `todo_active_task`
- `agents_guardrail`
- `todo_contradiction`
- `file_contains`

## pre-commit Integration (simplified)
Create a ready-to-use `.pre-commit-config.yaml` automatically:

```bash
agent-config-lint --workspace . --init-precommit
pip install pre-commit && pre-commit install
pre-commit run agent-config-lint --all-files
```

Use `--force-precommit` to overwrite existing config.
