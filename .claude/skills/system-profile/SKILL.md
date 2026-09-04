---
name: system-profile
description: Create or substantially refresh a profile for an IT system you support — access, topology, dependencies, quirks. Use when onboarding a new system, or when an existing profile has drifted from reality.
---

# System profile

`systems/` is the spine of the vault: every other note links to a system slug. A missing
profile makes everything about that system unreachable.

## Create

```bash
bin/pkm new system <slug> "<Display Name>"
```

Slug is short, lowercase, stable, and the thing you would actually type: `exchange`, `entra`,
`vpn`, `sap-prod`. Once other notes reference it, renaming is expensive — choose carefully.

## Fill in, in this priority order

1. **Business impact if down** — drives every triage priority decision later. One sentence.
2. **Access** — how to get in, which account, where credentials live (reference only, never
   inline). The thing you need first and can never find.
3. **Dependencies, both directions** — upstream and downstream, using other systems' slugs.
   This is what turns a list of notes into a graph, and it is what tells you, mid-incident,
   why an unrelated-looking system just broke.
4. **Where things live** — logs, config, backups, monitoring. Include *last verified restore*
   for backups; an unverified backup is a rumour.
5. **Known quirks** — the highest-value section in the vault. Everything that cost you hours
   once. Seed it from existing incidents: `bin/pkm sys <slug>`.

## A stub is fine

Do not block on completeness. A profile with just name, purpose, and impact is immediately
useful and unblocks linking. Mark unknowns explicitly in **Open questions / gaps** rather than
leaving fields silently blank — a blank field is ambiguous between "unknown" and "not
applicable", and that ambiguity costs time later.

## Refresh

When a profile is flagged stale (`INDEX.md` → Stale) or an incident reveals drift: verify the
facts against reality rather than tidying the prose, bump `updated:`, and record what changed.
If you cannot verify a fact, mark it `⚠️ unverified` instead of quietly leaving it — a
confidently wrong profile is worse than an obviously incomplete one.

## Finish

```bash
bin/pkm index && bin/pkm stats   # stats shows systems with no runbook — real gaps
```
