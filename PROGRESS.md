# PROGRESS

## 2026-03-20
- MVP作成: `src/main.py`
- 基本チェック実装:
  - required files existence
  - HEARTBEAT anti-pattern warning
  - TODO active task check
  - AGENTS guardrail hint check
- JSON出力対応を実装 (`--format json`)
- ルールセットを外部ファイル化 (`rules/default.json`)
- pre-commit連携設定を追加（`.pre-commit-config.yaml`）
- TODO矛盾ルールを追加（active/done の同時存在検出）
- ルール severity 分離を実装（warning/error）
- OpenClaw専用ルールセットを追加（`rules/openclaw.json`）
- ルール重み付けスコア（health score）を実装
- GitHub Actions CIを追加（`.github/workflows/lint.yml`）
- 次ステップ:
  1. CLIパッケージ化（`agent-config-lint` コマンド）
  2. サンプル違反ケースのテストデータ追加
