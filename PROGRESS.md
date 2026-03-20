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
- 次ステップ:
  1. pre-commit連携
  2. ルール追加（重複指示・矛盾検出）
