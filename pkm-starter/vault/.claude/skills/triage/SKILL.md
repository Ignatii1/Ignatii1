---
name: triage
description: Diagnose a live problem with an IT system by searching the vault for prior art first, then building an evidence-ordered diagnosis plan. Use whenever something is broken, erroring, degraded, or behaving unexpectedly — before proposing any fix.
---

# Triage

Something is broken. The goal is **not** to guess the fix — it is to find out whether we have
already solved this, then narrow by evidence.

## Step 1 — prior art (never skip)

Before any hypothesis, search. Most "new" incidents are repeats.

```bash
bin/pkm find "<exact error string>"     # exact strings first — highest signal
bin/pkm find "<symptom in plain words>" # then symptoms
bin/pkm sys <system>                    # everything about the affected system
```

Read: the system profile's **Known quirks**, matching incidents' **What I tried that did NOT
work**, and any runbook for the system. State plainly what the vault does and does not have —
"no prior incident matches this" is a real, useful finding.

## Step 2 — establish the delta

Nearly every incident has a change behind it. Ask, and record the answers:

- What changed? (deploy, patch, cert, GPO, firewall rule, DNS, licence, expiry, someone's "small fix")
- When did it last work? What is the blast radius — one user, one site, everyone?
- Is it total failure or intermittent? Intermittent points at load, DNS, replication, or TTL.
- Anything with a **date** attached — certificates, tokens, licences, AD passwords, DHCP leases?

If the user has not said what changed, ask before hypothesising. Do not fill the gap with a guess.

## Step 3 — hypotheses, ordered by cheap-to-disprove

Produce a short ranked list. For each: what it predicts, and the **single cheapest check** that
would rule it out. Order by (likelihood × ease of testing), not by how interesting it is.

Prefer checks that are read-only and reversible. Explicitly flag any diagnostic step that
changes state, restarts a service, or is user-visible — say so before proposing it, and say
what the blast radius is.

## Step 4 — capture as you go

Open the incident note **at the start**, not the end:

```bash
bin/pkm new incident <slug> "<title>"
```

Record failed attempts as they happen — that section is often worth more than the fix, and it
is the part always lost when written from memory afterwards.

## Step 5 — close the loop

Before considering it done:
- Fill TL;DR (symptom / root cause / fix / time lost) and paste **verbatim error strings** —
  those are the grep targets for future-you.
- Set `status: resolved`.
- Update the system profile's **Known quirks** if this cost more than an hour.
- Third occurrence → promote to a runbook (`runbook` skill) and cross-link.
- `bin/pkm index`

## Rules

- Vault facts beat general knowledge about the product. If they conflict, say so explicitly —
  it usually means the vault is stale or the environment is non-standard. Both matter.
- Never assert a config value from general knowledge. Cite the vault path or verify it live.
- "Restart it and see" is a last resort, not a hypothesis: it destroys the evidence.
