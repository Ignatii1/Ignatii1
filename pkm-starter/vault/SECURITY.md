# Handling rules

This vault documents production systems. Treat it as **confidential**.

## Repository
- **Private repo only.** Verify before every remote add: `gh repo view --json visibility`.
- Do not fork into a personal/public org. Do not enable GitHub Pages.
- If the employer has a policy on where work documentation may live, that policy wins over
  this vault. Check before the first push, not after.

## What must never be committed
| Never | Instead |
|-------|---------|
| Passwords, tokens, API keys | `creds: 1Password → "item name"` |
| Private keys, `.pfx`, `.kdbx` | Reference the store and path |
| Full customer PII | Pseudonymise: `CUST-01`, `USER-A` |
| Raw vendor PDFs under NDA | Keep in `sources/` (git-ignored), digest in `references/` |

Internal hostnames, IPs, AD group names and server roles are acceptable in a private repo —
they are what makes the vault useful. Draw the line at anything that grants access.

## Controls
- `bin/secret-scan.sh` — regex scan, wired into `bin/pkm check`.
- Install the pre-commit hook: `bin/pkm install-hooks`.
- The scanner is a safety net with false negatives. It is not a substitute for not pasting
  secrets in the first place.

## If a secret is committed
1. Rotate the secret **first**. Assume it is compromised the moment it is committed.
2. Then purge history (`git filter-repo`) and force-push.
3. Order matters: purging first just delays the rotation you still have to do.
