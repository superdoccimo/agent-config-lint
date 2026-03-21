# GitHub Auth Setup (for first push)

If `git push` fails with:

```text
fatal: could not read Username for 'https://github.com': No such device or address
```

use either SSH auth (recommended) or HTTPS token.

## Quick diagnostics
```bash
./scripts/check-github-auth.sh
```

## Option A: SSH (recommended)

### 1) Generate key and print public key
```bash
./scripts/setup-github-auth.sh your-email@example.com
```

### 2) Add printed key to GitHub
- Open: https://github.com/settings/keys
- New SSH key
- Paste key and save

### 3) Verify
```bash
ssh -T git@github.com
```
Expected: authenticated message.

### 4) Push
```bash
./scripts/publish-github.sh --ssh
```

## Option B: HTTPS token

### 1) Create token
- GitHub > Settings > Developer settings > Personal access tokens
- Grant repo write permission

### 2) Export token and push
```bash
export GITHUB_TOKEN=ghp_xxx
./scripts/publish-github.sh --https-token
```

## Notes
- Script requires clean working tree.
- `--https-token` rewrites `origin` URL with token. After push, you may switch back to SSH:
```bash
git remote set-url origin git@github.com:superdoccimo/agent-config-lint.git
```
