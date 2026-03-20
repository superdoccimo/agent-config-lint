import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def run_cmd(args):
    return subprocess.run(args, cwd=ROOT, capture_output=True, text=True)


def test_good_workspace_ok_json():
    p = run_cmd([
        "python3", "src/main.py",
        "--workspace", "/home/mamu/.openclaw/workspace",
        "--rules", "rules/openclaw.json",
        "--format", "json",
    ])
    assert p.returncode == 0
    data = json.loads(p.stdout)
    assert data["ok"] is True
    assert data["health_score"] == 100


def test_bad_workspace_reports_issues():
    p = run_cmd([
        "python3", "src/main.py",
        "--workspace", "examples/bad_workspace",
        "--rules", "rules/openclaw.json",
        "--format", "json",
    ])
    assert p.returncode != 0
    data = json.loads(p.stdout)
    assert data["ok"] is False
    assert len(data["errors"]) >= 1


def test_score_weights_option_changes_score():
    p = run_cmd([
        "python3", "src/main.py",
        "--workspace", "examples/bad_workspace",
        "--rules", "rules/openclaw.json",
        "--format", "json",
        "--error-weight", "10",
        "--warn-weight", "1",
    ])
    data = json.loads(p.stdout)
    assert data["health_score"] > 0


def test_migrate_rules_out_creates_file(tmp_path):
    out = tmp_path / "migrated.json"
    p = run_cmd([
        "python3", "src/main.py",
        "--workspace", "examples/bad_workspace",
        "--rules", "rules/default.json",
        "--format", "json",
        "--migrate-rules-out", str(out),
    ])
    assert out.exists()
    migrated = json.loads(out.read_text(encoding="utf-8"))
    assert "required_files_severity" in migrated
