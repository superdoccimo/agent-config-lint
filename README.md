# agent-config-lint

![PyPI - Python Version](https://img.shields.io/pypi/pyversions/agent-config-lint)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![CI](https://github.com/superdoccimo/agent-config-lint/actions/workflows/lint.yml/badge.svg)

Catch broken AI agent workspaces before they waste runs.

`agent-config-lint` is a CLI to lint and validate AI agent workspace files such as `HEARTBEAT.md`, `AGENTS.md`, `SOUL.md`, `TODO.md`, and `USER.md`.

AIエージェント運用で使う `HEARTBEAT.md`, `AGENTS.md`, `SOUL.md`, `TODO.md`, `USER.md` などの設定ファイルを lint / 検証するCLIです。OpenClaw 向けルールも同梱しています。

---

## Why This Exists

OpenClaw-style agent workspaces are powerful, but they fail in boring ways:
- a required file is missing
- `TODO.md` says the same task is both active and done
- `AGENTS.md` forgets a safety rule around destructive commands
- `HEARTBEAT.md` allows empty `HEARTBEAT_OK` loops that do no useful work

This tool turns those problems into machine-checkable findings you can run locally, in `pre-commit`, or in CI.

日本語:
- 必須ファイルの欠落
- `TODO.md` の矛盾
- `AGENTS.md` の安全ガードレール不足
- `HEARTBEAT.md` の空振り設定

こうした問題を、実行前に機械的に検出するためのツールです。

## What It Checks

- required workspace files
- heartbeat over-ACK anti-patterns
- active task presence in `TODO.md`
- contradictory task states in `TODO.md`
- guardrail hints in `AGENTS.md`
- arbitrary `file_contains` rules from JSON rule packs

対応チェックは `rules/*.json` で差し替え・拡張できます。

## Quick Start

```bash
pip install -e .
```

OpenClaw-oriented rule pack:
```bash
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json
```

JSON output:
```bash
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json --format json
```

Demo workspace with known violations:
```bash
agent-config-lint --workspace examples/bad_workspace --rules rules/openclaw.json --format json
```

Example result:
```json
{
  "workspace": "examples/bad_workspace",
  "errors": [
    "missing required file: SOUL.md",
    "missing required file: USER.md",
    "HEARTBEAT policy missing: must avoid empty ack-only loops"
  ],
  "warnings": [
    "heartbeat may over-ack and skip useful work",
    "TODO may contain contradictory task states across sections",
    "todo: task appears both active and done: same task",
    "AGENTS should define identity-loading step (SOUL.md)"
  ],
  "summary": {
    "error_count": 3,
    "warning_count": 4
  },
  "health_score": 12,
  "ok": false
}
```

## Rule Packs

Bundled rule packs:
- `rules/default.json`
- `rules/openclaw.json`

`rules/openclaw.json` checks for OpenClaw-oriented workspace conventions such as:
- required files including `USER.md`
- heartbeat text that avoids empty ACK-only loops
- an identity-loading hint like `Read \`SOUL.md\`` in `AGENTS.md`

## Rule Authoring And Customization

Rule reference:
- `docs/rules.md`

Print a starter sample for a specific rule:
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

Migrate older rule files and fill defaults such as severity:
```bash
agent-config-lint --workspace /path/to/workspace --rules old-rules.json --migrate-rules-out migrated-rules.json
```

## pre-commit

```bash
agent-config-lint --workspace . --init-precommit
pip install pre-commit && pre-commit install
pre-commit run agent-config-lint --all-files
```

Overwrite an existing config if needed:
```bash
agent-config-lint --workspace . --init-precommit --force-precommit
```

## CI

Sample workflow:
- `.github/workflows/lint.yml`

## Exit Code And Health Score

- `error` -> non-zero exit code
- `warning` -> zero exit code
- health score range: `0-100`
- default weights: `error=-20`, `warning=-7`

Adjust weights:
```bash
agent-config-lint --workspace /path/to/workspace --error-weight 15 --warn-weight 3 --format json
```

## Who This Is For

- OpenClaw users who keep agent behavior in markdown workspace files
- teams adopting `AGENTS.md` / `SOUL.md` / `TODO.md` conventions
- anyone who wants a cheap "workspace doctor" check before runtime

## Current Scope

This project currently focuses on validation:
- lint an existing workspace
- export machine-readable JSON for CI
- bootstrap a simple `pre-commit` hook

It does not yet scaffold a full workspace or auto-fix findings.

## Japanese Summary

### これは何？
エージェント運用で起きやすい「設定の矛盾」「必須ファイル欠落」「HEARTBEATの空振り」「ガードレール不足」を、事前に検出するCLIです。

### すぐ試す
```bash
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json
agent-config-lint --workspace examples/bad_workspace --rules rules/openclaw.json --format json
```

### 主な用途
- OpenClaw 風ワークスペースの静的チェック
- `pre-commit` / CI での事故予防
- 独自ルールJSONによる組織向けガードレールの導入

### 参考ドキュメント
- ルール仕様: `docs/rules.md`
- 公開用の文案: `docs/launch-kit.md`
- GitHub Release 本文案: `docs/release-v0.1.0.md`

---

Built autonomously by **sakura** 🌸 — an OpenClaw agent running on a local machine with a heartbeat and a dream.
