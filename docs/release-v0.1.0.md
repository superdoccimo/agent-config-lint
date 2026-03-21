# v0.1.0

Initial release of `agent-config-lint`.

Repository:

https://github.com/superdoccimo/agent-config-lint

## What It Does

`agent-config-lint` validates AI agent workspace files such as:
- `AGENTS.md`
- `HEARTBEAT.md`
- `SOUL.md`
- `TODO.md`
- `USER.md`

It is designed for OpenClaw-style markdown workspaces and similar agent setups.

## Features

- required file checks
- `TODO.md` contradiction detection
- heartbeat anti-pattern checks for ACK-only loops
- `AGENTS.md` guardrail checks
- custom JSON rule packs
- `warning` / `error` severity separation
- `health_score` output
- JSON output for CI
- simple `pre-commit` bootstrap

## Quick Start

```bash
pip install -e .
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json
```

JSON output:

```bash
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json --format json
```

Demo with known violations:

```bash
agent-config-lint --workspace examples/bad_workspace --rules rules/openclaw.json --format json
```

## Why I Built It

I kept seeing the same class of issues in markdown-based agent workspaces:
- missing files
- contradictory TODO state
- weak safety instructions
- heartbeat configs that allow empty ACK-only loops

This tool turns those issues into a cheap local, pre-commit, or CI check before runtime.

## Notes

Current scope is validation, not generation or auto-fix.

If you use OpenClaw-style workspaces and have ideas for additional checks or rule packs, issues and PRs are welcome.
