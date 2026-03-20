# GitHub Auth Setup (for first push)

If `git push` fails with:

```text
fatal: could not read Username for 'https://github.com': No such device or address
```

set up SSH auth once.

## 1) Generate key and print public key
```bash
./scripts/setup-github-auth.sh your-email@example.com
```

## 2) Add printed key to GitHub
- Open: https://github.com/settings/keys
- New SSH key
- Paste key and save

## 3) Verify
```bash
ssh -T git@github.com
```
Expected: authenticated message.

## 4) Switch remote to SSH and push
```bash
git remote set-url origin git@github.com:superdoccimo/agent-config-lint.git
./scripts/publish-github.sh
```
