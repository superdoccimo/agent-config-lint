# agent-config-lint

AIエージェントのワークスペース設定（`HEARTBEAT.md`, `AGENTS.md`, `SOUL.md`, `TODO.md`）をlint/検証するCLI。

CLI to lint and validate AI agent workspace configs (`HEARTBEAT.md`, `AGENTS.md`, `SOUL.md`, `TODO.md`).

---

## 日本語

### これは何？
エージェント運用で起きやすい「設定の矛盾」「必須ファイル欠落」「HEARTBEATの空振り」を事前に検出するツールです。

### インストール
```bash
pip install -e .
```

### 使い方（最短）
```bash
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json
```

JSON出力:
```bash
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json --format json
```

### ルール作成・拡張
ルール定義の参照:
- `docs/rules.md`

同梱ルール:
- `rules/default.json`
- `rules/openclaw.json`（OpenClaw向け）

特定ルールのサンプルJSONを出力:
```bash
agent-config-lint --workspace . --print-rule-sample heartbeat_over_ack
agent-config-lint --workspace . --print-rule-sample file_contains
```

利用可能サンプル:
- `required_files`
- `heartbeat_over_ack`
- `todo_active_task`
- `agents_guardrail`
- `todo_contradiction`
- `file_contains`

旧ルールのマイグレーション（severity既定値などを補完）:
```bash
agent-config-lint --workspace /path/to/workspace --rules old-rules.json --migrate-rules-out migrated-rules.json
```

### pre-commit導入（簡易）
```bash
agent-config-lint --workspace . --init-precommit
pip install pre-commit && pre-commit install
pre-commit run agent-config-lint --all-files
```

既存設定を上書きする場合:
```bash
agent-config-lint --workspace . --init-precommit --force-precommit
```

### CI
サンプルworkflow:
- `.github/workflows/lint.yml`

### スコアと終了コード
- `error`: 終了コード非0
- `warning`: 終了コード0
- health score: `0-100`（デフォルト: error=-20, warning=-7）

重み調整:
```bash
agent-config-lint --workspace /path/to/workspace --error-weight 15 --warn-weight 3 --format json
```

---

## English

### What is this?
A CLI that catches common agent config issues before runtime:
- missing required files
- contradictory TODO states
- weak/unsafe guardrails
- heartbeat setups that can get stuck in ACK-only behavior

### Installation
```bash
pip install -e .
```

### Quick start
```bash
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json
```

JSON output:
```bash
agent-config-lint --workspace /home/mamu/.openclaw/workspace --rules rules/openclaw.json --format json
```

### Rule authoring and customization
Rule reference:
- `docs/rules.md`

Bundled rule packs:
- `rules/default.json`
- `rules/openclaw.json`

Print a starter sample for a specific rule:
```bash
agent-config-lint --workspace . --print-rule-sample heartbeat_over_ack
```

Migrate older rules (fills defaults such as severity):
```bash
agent-config-lint --workspace /path/to/workspace --rules old-rules.json --migrate-rules-out migrated-rules.json
```

### Simplified pre-commit setup
```bash
agent-config-lint --workspace . --init-precommit
pip install pre-commit && pre-commit install
pre-commit run agent-config-lint --all-files
```

### CI
Sample workflow:
- `.github/workflows/lint.yml`

### Severity, exit code, and health score
- `error` -> non-zero exit code
- `warning` -> zero exit code
- health score range: `0-100`

### Demo workspace with violations
```bash
agent-config-lint --workspace examples/bad_workspace --rules rules/openclaw.json --format json
```
