import argparse
import json
import re
from pathlib import Path


RULE_SAMPLES = {
    "required_files": {
        "required_files": ["AGENTS.md", "HEARTBEAT.md", "TODO.md"],
        "required_files_severity": "error",
    },
    "heartbeat_over_ack": {
        "checks": {
            "heartbeat_over_ack": {
                "enabled": True,
                "severity": "warning",
                "must_contain_if_has": {
                    "has": "HEARTBEAT_OK",
                    "must_contain": "必ず何かを進める",
                },
                "warning": "HEARTBEATがACKのみで終わる恐れがあります",
            }
        }
    },
    "todo_active_task": {
        "checks": {
            "todo_active_task": {
                "enabled": True,
                "severity": "warning",
                "must_contain": "- [ ]",
                "warning": "TODOに未完了タスクがありません",
            }
        }
    },
    "agents_guardrail": {
        "checks": {
            "agents_guardrail": {
                "enabled": True,
                "severity": "warning",
                "any_contains": ["ask", "確認", "rm"],
                "warning": "AGENTSに破壊操作ガードレールがありません",
            }
        }
    },
    "todo_contradiction": {
        "checks": {
            "todo_contradiction": {
                "enabled": True,
                "severity": "warning",
                "warning": "同一タスクが未完了/完了で重複しています",
            }
        }
    },
    "file_contains": {
        "checks": {
            "file_contains": [
                {
                    "enabled": True,
                    "file": "SOUL.md",
                    "must_contain": "役に立つ",
                    "severity": "warning",
                    "message": "SOUL.mdにコア方針が見つかりません",
                }
            ]
        }
    },
}

PRECOMMIT_TEMPLATE = """repos:
  - repo: local
    hooks:
      - id: agent-config-lint
        name: agent-config-lint
        entry: agent-config-lint --workspace . --rules rules/openclaw.json
        language: system
        pass_filenames: false
"""


def read(p: Path) -> str:
    return p.read_text(encoding="utf-8") if p.exists() else ""


def load_rules(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def add_finding(errors: list[str], warns: list[str], severity: str, message: str):
    if severity == "error":
        errors.append(message)
    else:
        warns.append(message)


def normalize_rules(rules: dict) -> dict:
    r = json.loads(json.dumps(rules))
    if "required_files_severity" not in r:
        r["required_files_severity"] = "error"

    checks = r.setdefault("checks", {})
    for key in ["heartbeat_over_ack", "todo_active_task", "agents_guardrail", "todo_contradiction"]:
        if key in checks and isinstance(checks[key], dict):
            checks[key].setdefault("severity", "warning")

    for rule in checks.get("file_contains", []):
        if isinstance(rule, dict):
            rule.setdefault("severity", "warning")

    return r


def find_todo_contradictions(todo_text: str) -> list[str]:
    issues: list[str] = []
    by_task: dict[str, set[str]] = {}
    for m in re.finditer(r"^- \[( |x)\] (.+)$", todo_text, flags=re.MULTILINE):
        state = "done" if m.group(1) == "x" else "active"
        task = re.sub(r"\s+", " ", m.group(2).strip())
        by_task.setdefault(task, set()).add(state)
    for task, states in by_task.items():
        if len(states) > 1:
            issues.append(f"task appears both active and done: {task}")
    return issues


def compute_health_score(errors: list[str], warns: list[str], error_weight: int = 20, warn_weight: int = 7) -> int:
    score = 100 - (error_weight * len(errors)) - (warn_weight * len(warns))
    return max(0, score)


def init_precommit(workspace: Path, force: bool = False) -> Path:
    dst = workspace / ".pre-commit-config.yaml"
    if dst.exists() and not force:
        raise FileExistsError(f"{dst} already exists. use --force-precommit to overwrite")
    dst.write_text(PRECOMMIT_TEMPLATE, encoding="utf-8")
    return dst


def run_checks(ws: Path, rules: dict) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warns: list[str] = []

    required_severity = rules.get("required_files_severity", "error")
    for name in rules.get("required_files", []):
        if not (ws / name).exists():
            add_finding(errors, warns, required_severity, f"missing required file: {name}")

    checks = rules.get("checks", {})

    hb_rule = checks.get("heartbeat_over_ack", {})
    if hb_rule.get("enabled"):
        hb = read(ws / "HEARTBEAT.md")
        cond = hb_rule.get("must_contain_if_has", {})
        if cond.get("has") in hb and cond.get("must_contain") not in hb:
            add_finding(errors, warns, hb_rule.get("severity", "warning"), hb_rule.get("warning", "heartbeat over-ack risk"))

    todo_rule = checks.get("todo_active_task", {})
    if todo_rule.get("enabled"):
        todo = read(ws / "TODO.md")
        if todo_rule.get("must_contain") not in todo:
            add_finding(errors, warns, todo_rule.get("severity", "warning"), todo_rule.get("warning", "TODO has no active tasks"))

    agents_rule = checks.get("agents_guardrail", {})
    if agents_rule.get("enabled"):
        agents = read(ws / "AGENTS.md")
        needles = agents_rule.get("any_contains", [])
        if not any(n in agents for n in needles):
            add_finding(errors, warns, agents_rule.get("severity", "warning"), agents_rule.get("warning", "AGENTS guardrail missing"))

    contradiction_rule = checks.get("todo_contradiction", {})
    if contradiction_rule.get("enabled"):
        todo = read(ws / "TODO.md")
        contradictions = find_todo_contradictions(todo)
        if contradictions:
            sev = contradiction_rule.get("severity", "warning")
            add_finding(errors, warns, sev, contradiction_rule.get("warning", "TODO contradiction risk"))
            for c in contradictions:
                add_finding(errors, warns, sev, f"todo: {c}")

    for rule in checks.get("file_contains", []):
        if not rule.get("enabled", True):
            continue
        file_text = read(ws / rule.get("file", ""))
        needle = rule.get("must_contain", "")
        if needle and needle not in file_text:
            add_finding(errors, warns, rule.get("severity", "warning"), rule.get("message", f"{rule.get('file')} missing expected text"))

    return errors, warns


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--workspace", required=True)
    ap.add_argument("--rules", default="rules/default.json")
    ap.add_argument("--format", choices=["text", "json"], default="text")
    ap.add_argument("--error-weight", type=int, default=20)
    ap.add_argument("--warn-weight", type=int, default=7)
    ap.add_argument("--migrate-rules-out", default="")
    ap.add_argument("--print-rule-sample", choices=sorted(RULE_SAMPLES.keys()), default="")
    ap.add_argument("--init-precommit", action="store_true")
    ap.add_argument("--force-precommit", action="store_true")
    args = ap.parse_args()

    ws = Path(args.workspace)

    if args.print_rule_sample:
        print(json.dumps(RULE_SAMPLES[args.print_rule_sample], ensure_ascii=False, indent=2))
        raise SystemExit(0)

    if args.init_precommit:
        p = init_precommit(ws, force=args.force_precommit)
        print(f"wrote {p}")
        print("next: pip install pre-commit && pre-commit install")
        raise SystemExit(0)

    rules = normalize_rules(load_rules(Path(args.rules)))

    if args.migrate_rules_out:
        Path(args.migrate_rules_out).write_text(json.dumps(rules, ensure_ascii=False, indent=2), encoding="utf-8")

    errors, warns = run_checks(ws, rules)
    score = compute_health_score(errors, warns, error_weight=args.error_weight, warn_weight=args.warn_weight)

    result = {
        "workspace": str(ws),
        "errors": errors,
        "warnings": warns,
        "summary": {"error_count": len(errors), "warning_count": len(warns)},
        "health_score": score,
        "ok": (not errors and not warns),
    }

    if args.format == "json":
        print(json.dumps(result, ensure_ascii=False, indent=2))
    else:
        for e in errors:
            print(f"ERROR: {e}")
        for w in warns:
            print(f"WARN: {w}")
        print(f"SUMMARY: errors={len(errors)} warnings={len(warns)}")
        print(f"HEALTH_SCORE: {score}")
        if result["ok"]:
            print("OK: no issues found")

    raise SystemExit(1 if errors else 0)


if __name__ == "__main__":
    main()
