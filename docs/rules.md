# Rule Reference

## Shared fields
Each rule can define:
- `enabled` (bool)
- `severity` (`warning` or `error`)
- message field (`warning` or `message` depending on rule type)

## Top-level keys

### `required_files`
List of mandatory files in target workspace.

### `required_files_severity`
Severity when required files are missing.

### `checks.heartbeat_over_ack`
Warn/error when heartbeat file contains `HEARTBEAT_OK` but misses anti-skip guidance.

### `checks.todo_active_task`
Warn/error when TODO has no active checkbox (`- [ ]`).

### `checks.agents_guardrail`
Warn/error when AGENTS file misses destructive-op guardrail hints.

### `checks.todo_contradiction`
Detects same TODO task text marked as both active and done.

### `checks.file_contains[]`
Generic rule entries:
- `file`: target filename
- `must_contain`: required text
- `severity`: warning/error
- `message`: output message

## Included rule packs
- `rules/default.json` : generic agent workspace checks
- `rules/openclaw.json` : OpenClaw-tuned checks
