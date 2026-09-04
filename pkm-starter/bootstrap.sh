#!/usr/bin/env bash
# Deploy the vault into a new directory, ready to become a PRIVATE git repo.
#
#   ./bootstrap.sh ~/work-vault           # with example notes (recommended first time)
#   ./bootstrap.sh ~/work-vault --clean   # without examples
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/vault" && pwd)"
DEST="${1:-}"
CLEAN=0
for a in "$@"; do [ "$a" = "--clean" ] && CLEAN=1; done

if [ -z "$DEST" ] || [ "$DEST" = "--clean" ]; then
  echo "usage: ./bootstrap.sh <destination-dir> [--clean]" >&2
  exit 1
fi
if [ -e "$DEST" ] && [ -n "$(ls -A "$DEST" 2>/dev/null)" ]; then
  echo "refusing: $DEST exists and is not empty" >&2
  exit 1
fi

mkdir -p "$DEST"
cp -R "$SRC/." "$DEST/"
cd "$DEST"

if [ "$CLEAN" -eq 1 ]; then
  rm -f systems/exchange.md \
        incidents/2026-08-14-lob-relay-tls-failure.md \
        runbooks/rotate-exchange-tls-cert.md
  echo "removed example notes"
fi

git init -q
bin/pkm install-hooks >/dev/null
bin/pkm index >/dev/null
bin/pkm map >/dev/null
git add -A
git commit -q -m "Initialise work knowledge vault"

cat <<BANNER

  Vault ready at: $DEST

  ⚠️  NEXT STEP — CREATE A **PRIVATE** REMOTE. This vault will hold production
     system documentation. Do not push it to a public repository.

     gh repo create work-vault --private --source=. --remote=origin --push

     Then verify:  gh repo view --json visibility

  Then:
     cd $DEST
     claude          # CLAUDE.md loads automatically; try the 'system-profile' skill

BANNER
