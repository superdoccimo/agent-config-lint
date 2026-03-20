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
- 次ステップ:
  1. ルールの severity 分離（warn/error）
  2. OpenClaw専用ルールセットの追加
