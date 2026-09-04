# Work Knowledge Vault — Operating Manual

This repo is my memory. Claude has **no persistent memory between sessions** — anything not
written here is lost when the session ends. Treat every file as long-term storage and this
file as the boot sequence.

Domain: IT systems support. Optimised for fast recall under pressure, not for pretty prose.

---

## Directory map

| Path          | Holds                                                        | Lifespan |
|---------------|--------------------------------------------------------------|----------|
| `inbox/`      | Raw unprocessed dumps — paste anything here, zero structure   | hours    |
| `systems/`    | One profile per system I support. The spine of the vault      | forever  |
| `runbooks/`   | Repeatable procedures. Deterministic steps, verified          | forever  |
| `incidents/`  | What broke, what I tried, what actually fixed it              | forever  |
| `references/` | Distilled vendor docs. Never the raw doc — the digest         | years    |
| `decisions/`  | Why a thing is configured this way. ADR-style                 | forever  |
| `contacts/`   | Who owns what, escalation paths                               | years    |
| `sources/`    | Raw PDFs/exports. **Git-ignored.** Cited by `references/`     | n/a      |
| `archive/`    | Decommissioned systems, superseded notes                      | forever  |
| `INDEX.md`    | **Generated** by `bin/pkm index`. Never hand-edit             | n/a      |

---

## Retrieval protocol — follow this before answering anything

1. **Never answer about our environment from general knowledge.** General knowledge tells you
   how Exchange works; only this vault knows how *ours* is configured. If the two conflict,
   the vault wins, and say so.
2. Search before reading: `bin/pkm find "<terms>"` or `rg -il "<terms>" systems/ runbooks/ incidents/ references/`.
3. Read `INDEX.md` for the map. Read *targeted* files after that. **Do not `cat` the whole
   vault** — it burns the context window and buries the answer.
4. **Cite the path** for every environment-specific claim: `systems/exchange.md:34`.
   An uncited claim about our environment is a guess and must be labelled as one.
5. **Check `updated:`.** A note older than 180 days is a lead, not a fact. Say
   "per `incidents/…` (14 months old, unverified)" rather than asserting it.
6. If the vault has nothing, say so plainly and offer to create the note. Silence is a gap
   in the vault — that is useful information, not a failure.

## Write protocol

- **Every solved problem becomes an `incidents/` note.** No exceptions. The fix you found at
  23:40 is worthless if it lives only in a terminal scrollback.
- Third time an incident repeats → promote it to a `runbooks/` entry and link both ways.
- Update the affected `systems/` note in the same session. A system profile that drifts from
  reality is worse than none.
- Notes are written for *me in six months, mid-outage, on a phone.* Lead with the answer.
  Prose is a cost, not a virtue.

## Frontmatter — required on every note (this is what makes grep work)

```yaml
---
type: incident        # system | runbook | incident | reference | decision | contact
id: INC-2026-0041     # stable ID, used for cross-links, never reused
title: Outlook clients fail TLS handshake after CA rotation
systems: [exchange, adcs]     # must match a systems/<slug>.md
status: resolved      # open | resolved | active | deprecated | draft | verified
severity: p2          # incidents only: p1..p4
created: 2026-09-04
updated: 2026-09-04
tags: [tls, certificates, smtp]
---
```

Filenames: `incidents/2026-09-04-outlook-tls-handshake.md`, `systems/exchange.md`,
`runbooks/rotate-exchange-cert.md`. Lowercase, hyphens, dated prefix for incidents only.

## Secrets — hard rules

- **Never** write a password, token, API key, private key or connection string into this vault.
- Reference the secret instead: `creds: 1Password → "svc-exchange-relay"`.
- Hostnames/IPs are fine (private repo). Customer-identifying data is not — use `CUST-01`.
- `bin/pkm check` runs a secret scan. Run it before every push; the pre-commit hook does too.

## Skills (invoke by name)

| Skill            | Use when                                                        |
|------------------|-----------------------------------------------------------------|
| `capture`        | `inbox/` has raw material to file into structured notes          |
| `triage`         | Something is broken now — search prior art, build a diagnosis plan |
| `doc-digest`     | A vendor PDF/manual needs turning into a `references/` digest    |
| `runbook`        | Write or update a procedure, usually promoted from an incident   |
| `system-profile` | Onboarding a system I now support                                |
| `review`         | Weekly hygiene: drain inbox, find gaps, rebuild index            |

## Anti-patterns

- Loading the whole vault "for context" → context exhaustion, worse answers.
- Writing a note with no `systems:` → it is unreachable; it does not exist.
- Vendor docs copied in verbatim → `references/` holds the digest, `sources/` holds the PDF.
- Restating general product documentation → only record what is **true of our environment**
  or **not obvious from the vendor docs**.
