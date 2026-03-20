import argparse
import json
from pathlib import Path


def read(p: Path) -> str:
    return p.read_text(encoding="utf-8") if p.exists() else ""


def load_rules(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def run_checks(ws: Path, rules: dict) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warns: list[str] = []

    for name in rules.get("required_files", []):
        if not (ws / name).exists():
            errors.append(f"missing required file: {name}")

    checks = rules.get("checks", {})

    hb_rule = checks.get("heartbeat_over_ack", {})
    if hb_rule.get("enabled"):
        hb = read(ws / "HEARTBEAT.md")
        cond = hb_rule.get("must_contain_if_has", {})
        if cond.get("has") in hb and cond.get("must_contain") not in hb:
            warns.append(hb_rule.get("warning", "heartbeat over-ack risk"))

    todo_rule = checks.get("todo_active_task", {})
    if todo_rule.get("enabled"):
        todo = read(ws / "TODO.md")
        if todo_rule.get("must_contain") not in todo:
            warns.append(todo_rule.get("warning", "TODO has no active tasks"))

    agents_rule = checks.get("agents_guardrail", {})
    if agents_rule.get("enabled"):
        agents = read(ws / "AGENTS.md")
        needles = agents_rule.get("any_contains", [])
        if not any(n in agents for n in needles):
            warns.append(agents_rule.get("warning", "AGENTS guardrail missing"))

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

    result = {
        "workspace": str(ws),
        "errors": errors,
        "warnings": warns,
        "ok": (not errors and not warns),
    }

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
