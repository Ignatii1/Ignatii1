# Work Knowledge Vault

A git-backed personal knowledge system for IT systems support, designed to be driven by
Claude Code. Plain markdown, no database, no lock-in.

**Read `CLAUDE.md` first** — it is the operating manual, and it is what Claude loads into
every session.

## Why it is shaped this way

Claude has **no memory between sessions**. So the repo *is* the memory, and everything is
optimised for one thing: Claude finding the right note fast, without loading the whole vault.

- **Plain markdown + git** — greppable, diffable, portable, readable without any tool.
- **YAML frontmatter** — turns `rg` into a query engine with no index to maintain.
- **`CLAUDE.md` stays under ~100 lines** — it costs context on every single session, so it
  holds the map and the rules, never the content.
- **Progressive disclosure** — `INDEX.md` → targeted files. Never `cat` the vault.
- **Skills over prompting** — repeatable workflows live in `.claude/skills/`, so you get the
  same quality on a bad day as on a good one.

## Setup

```bash
bin/pkm install-hooks          # pre-commit secret scan (local git use)
bin/pkm index                  # build INDEX.md
bin/pkm map                    # build MAP.md
bin/pkm stats                  # see what is missing
```

Add to your shell: `alias pkm='<path-to-vault>/bin/pkm'`

### If you use Claude Code on the web

The session sees only the committed repo — never your laptop. So:

- **Commit documents to `sources/`** before asking Claude to digest them (or drag a file into
  the chat and ask Claude to save it there). `sources/` is deliberately *not* git-ignored.
- Ask Claude to run `bin/pkm check` before it commits; the pre-commit hook only exists in
  clones where you ran `install-hooks`.
- Live API calls to an internal helpdesk or monitoring system will not work from the cloud
  container. Paste or commit exports instead.

## Daily use

| Situation | Do this |
|-----------|---------|
| Something broke | `triage` skill — searches prior art before hypothesising |
| "How does this all fit together?" | `explain` skill + `MAP.md` |
| Closed an IntraService ticket | `ticket` skill — extracts the knowledge, drops the noise |
| Solved something | It writes the incident note; make sure `status: resolved` |
| Random thought / ticket / log | Paste into `inbox/`, walk away |
| Big vendor PDF to understand | Drop in `sources/`, run `doc-digest` |
| Third time doing a task | `runbook` skill |
| New system to support | `system-profile` skill |
| Friday | `review` skill |

## CLI

```bash
pkm find "TLS handshake"    # search everything, grouped by type
pkm sys exchange            # every note touching one system
pkm new incident db-timeout "Orders DB times out under load"
pkm open                    # open incidents / draft runbooks
pkm recent 10
pkm err "TLS negotiation failed"   # search only verbatim error blocks
pkm index                   # rebuild INDEX.md
pkm map                     # rebuild MAP.md — dependency graph, blast radius, SPOFs
pkm conflicts               # unresolved doc contradictions + untrusted facts
pkm stats                   # counts + systems with no runbook
pkm check                   # frontmatter lint + secret scan
```

## First week

Do not try to document everything — that fails every time. Instead:

1. Create profiles for your **top 3 systems** (stubs are fine) and fill in `depends_on:` —
   then run `bin/pkm map`. The blind spots it lists are your real documentation backlog.
2. From then on, write an incident note for **every** problem you solve. No exceptions.
3. Dump anything else into `inbox/`.
4. Run `review` on Friday.

The vault becomes useful at around 20 notes and genuinely valuable at around 100. The incidents
are the compounding asset — they are the knowledge nobody else has and that you will otherwise
re-derive every time.

## Example notes

`systems/exchange.md`, `incidents/2026-08-14-*.md`, `runbooks/rotate-exchange-tls-cert.md` are
synthetic examples showing the format and the cross-linking. Delete them once you have real
notes — or run `bootstrap.sh --clean` at install time to skip them.

## Security

Read `SECURITY.md`. Short version: **private repo, never commit a secret, reference the
password manager instead.**
