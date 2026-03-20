import argparse
import json
import re
from pathlib import Path


def read(p: Path) -> str:
    return p.read_text(encoding="utf-8") if p.exists() else ""


def load_rules(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def add_finding(errors: list[str], warns: list[str], severity: str, message: str):
    if severity == "error":
        errors.append(message)
    else:
        warns.append(message)


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
    args = ap.parse_args()

    ws = Path(args.workspace)
    rules = load_rules(Path(args.rules))
    errors, warns = run_checks(ws, rules)

    result = {"workspace": str(ws), "errors": errors, "warnings": warns, "ok": (not errors and not warns)}

    if args.format == "json":
        print(json.dumps(result, ensure_ascii=False, indent=2))
    else:
        for e in errors:
            print(f"ERROR: {e}")
        for w in warns:
            print(f"WARN: {w}")
        if result["ok"]:
            print("OK: no issues found")

    raise SystemExit(1 if errors else 0)


if __name__ == "__main__":
    main()
