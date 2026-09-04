---
name: review
description: Periodic vault maintenance — drain the inbox, find knowledge gaps, promote repeated incidents to runbooks, flag stale notes, rebuild the index. Use weekly, or when the vault feels disorganised.
---

# Review

Vaults rot silently. This is the counter-pressure. ~15 minutes, weekly.

## 1. Drain the inbox
Anything in `inbox/` → run the `capture` skill. Target: empty.

## 2. Health check
```bash
bin/pkm stats     # counts, and systems with no runbook
bin/pkm check     # frontmatter lint + secret scan
bin/pkm index     # rebuild, then read INDEX.md
```

## 3. Act on what the index shows

- **⚠️ Unreachable** (no `systems:`) → fix immediately; these notes are invisible to every
  future search.
- **Systems with no profile** (`⚠️ no profile` in the table) → create a stub.
- **Open items** → still open, or just never closed? Close them or note why they are stuck.
- **Stale >180d** → for `system` and `runbook` notes, verify against reality or mark
  `⚠️ unverified`. Do not bump `updated:` without actually checking; that launders a guess
  into a fact and is the single easiest way to make the vault untrustworthy.

## 4. Promote patterns

Look for the same root cause across incidents:
```bash
rg -oN '^tags: (.*)$' -r '$1' incidents | sort | uniq -c | sort -rn | head -20
```
Three or more related incidents → write the runbook (`runbook` skill) and cross-link.
This is the compounding step: it converts repeated pain into a one-time cost.

## 5. Prune

Archive decommissioned systems (`git mv` to `archive/`, set `status: deprecated` — never
delete; the history explains today's config). Merge duplicate notes. Delete notes that will
never be read again.

Growth is not the goal. A vault that only grows becomes unsearchable; retrieval quality is
the metric that matters.

## 6. Commit

```bash
git add -A && git commit -m "review: <what changed>" && git push
```

## Report back

Give the user a short summary: what was filed, what gaps were found, what needs their input.
Flag anything you could not verify yourself — stale facts about production are their call,
not yours.
