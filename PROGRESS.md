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
- CLIパッケージ化を実装（`pyproject.toml`, `agent-config-lint` コマンド）
- サンプル違反ケースを追加（`examples/bad_workspace`）
- ルール説明ドキュメントを追加（`docs/rules.md`）
- pipx導線をREADMEへ追加
- `--error-weight` / `--warn-weight` を追加（スコア重み調整）
- 最小ユニットテスト追加（`tests/test_smoke.py`）
- `summary` 出力を追加（severity別件数）
- ルール自動マイグレーション補助を追加（`--migrate-rules-out`）
- 次ステップ:
  1. ルール別ドキュメントに入出力サンプルJSONを追記
  2. `pre-commit` 自動セットアップ手順の簡略化スクリプト追加

## 2026-03-21
- README 前半を公開向けに再構成
  - 問題提起を先頭に移動
  - OpenClaw 向け訴求を明確化
  - bad workspace のデモ導線を追加
  - `workspace doctor` 的な位置づけを追記
- `docs/launch-kit.md` を追加
  - 命名案
  - GitHub description 候補
  - X / Threads / HN / Reddit 向け初投稿文
  - 公開チェックリスト
- `docs/release.md` にローンチ導線を追記
