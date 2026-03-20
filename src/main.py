import argparse
from pathlib import Path

REQUIRED = ["HEARTBEAT.md", "AGENTS.md", "SOUL.md", "TODO.md"]


def read(p: Path) -> str:
    return p.read_text(encoding="utf-8") if p.exists() else ""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--workspace", required=True)
    args = ap.parse_args()

    ws = Path(args.workspace)
    errors = []
    warns = []

    for name in REQUIRED:
        if not (ws / name).exists():
            errors.append(f"missing required file: {name}")

    hb = read(ws / "HEARTBEAT.md")
    if "HEARTBEAT_OK" in hb and "毎回必ず何かを進める" not in hb:
        warns.append("heartbeat may over-ack and skip useful work")

    todo = read(ws / "TODO.md")
    if "- [ ]" not in todo:
        warns.append("TODO has no active tasks")

    agents = read(ws / "AGENTS.md")
    if "Don't run destructive commands without asking" not in agents and "破壊的" not in agents:
        warns.append("AGENTS may miss destructive-operation guardrails")

    for e in errors:
        print(f"ERROR: {e}")
    for w in warns:
        print(f"WARN: {w}")

    if not errors and not warns:
        print("OK: no issues found")

    raise SystemExit(1 if errors else 0)


if __name__ == "__main__":
    main()
