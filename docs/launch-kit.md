# Launch Kit

## Recommended Positioning

Use this project as:
- an "AI agent workspace doctor"
- a safety and consistency check for OpenClaw-style markdown workspaces
- a CI / pre-commit guardrail, not just a local lint script

Primary repo URL:

`https://github.com/superdoccimo/agent-config-lint`

Short one-liner:

`agent-config-lint` catches broken AI agent workspace files before they waste runs.

Japanese one-liner:

`agent-config-lint` は、AIエージェントのワークスペース設定が壊れたまま動き出すのを防ぐCLIです。

## Naming Recommendations

If you want broader reach, I would not rename the Python package immediately. Keep `agent-config-lint` for the package and adjust the GitHub repo description / subtitle first.

Recommended options:

1. `agent-config-lint`
   Keep this if you want a clear, honest package name with low migration cost.
2. `agent-workspace-lint`
   Best generic rename if you want broader reach beyond OpenClaw.
3. `agent-workspace-doctor`
   Best marketing name if you want stronger memorability.
4. `openclaw-workspace-lint`
   Best if you want to target OpenClaw users directly and capture that search traffic.

Practical recommendation:
- package name: `agent-config-lint`
- GitHub repo subtitle: `AI agent workspace doctor for OpenClaw-style markdown configs`

## GitHub Description Options

Short:
- Lint and validate AI agent workspace files like `AGENTS.md`, `HEARTBEAT.md`, `SOUL.md`, and `TODO.md`.

Stronger:
- Catch broken OpenClaw-style agent workspaces before they waste runs.

Broader:
- CI-friendly lint for AI agent workspace configs, guardrails, and heartbeat policies.

## Launch Angles

Choose one primary angle. Do not mix all of them in the first post.

1. Reliability angle
   Stop shipping broken agent workspaces.
2. Safety angle
   Catch weak guardrails and risky heartbeat policies before runtime.
3. OpenClaw angle
   A linter for OpenClaw-style `AGENTS.md` / `SOUL.md` / `TODO.md` workspaces.
4. Team workflow angle
   Add agent workspace checks to `pre-commit` and CI like normal software quality gates.

## Suggested Demo Flow

Use a short terminal recording or GIF:

1. Show `examples/bad_workspace`.
2. Run:
   ```bash
   agent-config-lint --workspace examples/bad_workspace --rules rules/openclaw.json --format json
   ```
3. Show at least one `error`, one `warning`, and the `health_score`.
4. Run the same command on a good workspace and show `ok: true`.

The strongest demo is contrast, not explanation.

## X / Threads Post Drafts

### English

Built a small tool for a problem I kept hitting with AI agents:

broken workspace files.

`agent-config-lint` checks `AGENTS.md`, `HEARTBEAT.md`, `SOUL.md`, `TODO.md`, and custom rules before runtime.

It catches things like:
- missing required files
- contradictory TODO state
- weak guardrails
- heartbeat configs that drift into ACK-only loops

Works locally, in `pre-commit`, and in CI.

Repo:
https://github.com/superdoccimo/agent-config-lint

### Japanese

AIエージェント運用で地味に困る、
`AGENTS.md` / `HEARTBEAT.md` / `SOUL.md` / `TODO.md` の壊れた設定を先に検出するCLIを作りました。

`agent-config-lint`

できること:
- 必須ファイル欠落の検出
- TODO矛盾の検出
- ガードレール不足の検出
- HEARTBEAT の空振り設定の検出

`pre-commit` / CI にも入れられます。

Repo:
https://github.com/superdoccimo/agent-config-lint

### Short English Variant

Stop shipping broken AI agent workspaces.

`agent-config-lint` is a small CLI for linting `AGENTS.md`, `HEARTBEAT.md`, `SOUL.md`, and `TODO.md` with OpenClaw-friendly rules.

https://github.com/superdoccimo/agent-config-lint

## GitHub Release Notes Draft

### `v0.1.0`

Initial release of `agent-config-lint`.

What it does:
- lints AI agent workspace files such as `AGENTS.md`, `HEARTBEAT.md`, `SOUL.md`, `TODO.md`, and `USER.md`
- reports both `error` and `warning` findings
- computes a simple `health_score`
- supports JSON output for CI
- includes bundled rule packs, including `rules/openclaw.json`
- can bootstrap a local `pre-commit` hook

Good fit for teams using OpenClaw-style markdown workspaces and wanting a cheap consistency check before runtime.

## Hacker News / Reddit Draft

Title ideas:
- Show HN: agent-config-lint, a linter for AI agent workspace files
- Show HN: agent-config-lint, CI checks for `AGENTS.md` / `HEARTBEAT.md` / `TODO.md`
- I built a linter for OpenClaw-style agent workspaces

Body:

I kept seeing the same class of issues in markdown-based agent workspaces: missing files, contradictory TODO state, weak safety instructions, and heartbeat configs that allowed empty ACK-only loops.

So I built a small CLI that validates those files before runtime. It can run locally, in `pre-commit`, or in CI, and it supports rule packs for different workspace conventions.

The project currently focuses on validation, not generation or auto-fix. Feedback on missing checks and rule design would be useful.

## Launch Checklist

- Make the first screen of `README.md` explain the problem in under 10 seconds.
- Keep one copy-paste command near the top.
- Include one bad-workspace demo command.
- Publish a `v0.1.0` tag and GitHub Release before posting publicly.
- Put one screenshot or terminal GIF in the repo or release notes.
- Post to GitHub Release, X / Threads, and one OpenClaw or agent-dev community on the same day.
- Lead with the problem, not the implementation details.
