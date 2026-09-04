#!/usr/bin/env bash
# Regex secret scan. Safety net only — false negatives are expected.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1

PATTERNS=(
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'
  '(?i)\b(password|passwd|pwd|secret|api[_-]?key|token)\s*[:=]\s*["'"'"']?[^\s"'"'"'<{(].{6,}'
  '(?i)\bBearer\s+[A-Za-z0-9._\-]{20,}'
  'gh[pousr]_[A-Za-z0-9]{30,}'
  'sk-(ant-)?[A-Za-z0-9_\-]{20,}'
  'AKIA[0-9A-Z]{16}'
  '(?i)connectionstring\s*[:=].*(pwd|password)='
  '(?i)\bxox[baprs]-[A-Za-z0-9-]{10,}'
)

ALLOW='(1Password|Bitwarden|KeePass|Vault|<REDACTED>|\{\{|example|EXAMPLE|placeholder|NEVER inline|creds:|password manager)'

found=0
for p in "${PATTERNS[@]}"; do
  # shellcheck disable=SC2086
  if hits=$(rg -nP --no-heading -g '!INDEX.md' -g '!SECURITY.md' -g '!bin/secret-scan.sh' \
              -g '!.gitignore' -g '!CLAUDE.md' -g '!templates/**' "$p" . 2>/dev/null \
            | rg -v "$ALLOW"); then
    if [ -n "$hits" ]; then
      echo "⚠️  possible secret:"
      echo "$hits" | sed 's/^/    /'
      found=1
    fi
  fi
done

if [ "$found" -eq 0 ]; then
  echo "✅ secret scan clean"
else
  echo ""
  echo "❌ Review the above. If a real secret was already committed: ROTATE IT FIRST, then purge history."
fi
exit "$found"
