# Release Checklist

## 1) Pre-release
- Run tests: `python -m pytest -q`
- Run lint command on sample workspace
- Confirm README links and commands

## 2) Tag
```bash
git tag -a v0.1.0 -m "v0.1.0"
git push origin v0.1.0
```

## 3) GitHub Release
- Create release from tag
- Include changelog summary
- Mention key features:
  - severity separation (warning/error)
  - health score
  - rule migration helper
  - rule sample output
  - pre-commit bootstrap

## 4) Post-release
- Bump version in `pyproject.toml`
- Start next milestone notes in `PROGRESS.md`
