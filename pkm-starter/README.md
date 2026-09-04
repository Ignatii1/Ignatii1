# PKM Starter — work knowledge vault for IT systems support

A ready-to-deploy personal knowledge management system designed to be driven by Claude Code.

> ⚠️ **Check the destination repo's visibility before putting real notes in it.**
>
> ```bash
> gh repo view <owner>/<repo> --json visibility,isPrivate
> ```
>
> This kit was delivered into `Ignatii1/Ignatii1`, which is a **GitHub profile repo** — the
> kind whose purpose is to be publicly visible. Even when set to private, that makes it a
> poor permanent home for work documentation: restoring the public profile card is a single
> toggle, and flipping it republishes the entire vault *and its git history* at once.
>
> Prefer a dedicated private repo, where no such pressure to go public exists.

## Deploy

Built for **Claude Code on the web**: `sources/` is committed (not git-ignored) because a
cloud session can only read what is in the repo.

```bash
./bootstrap.sh ~/work-vault          # keeps the worked examples (recommended first time)
./bootstrap.sh ~/work-vault --clean  # empty vault

cd ~/work-vault
gh repo create work-vault --private --source=. --remote=origin --push
gh repo view --json visibility       # confirm: "private"
claude
```

## What is in here

```
vault/
├── CLAUDE.md              ← the operating manual, loaded every session. Start here.
├── README.md              ← day-to-day usage
├── SECURITY.md            ← what must never be committed
├── .claude/skills/        ← triage, explain, doc-digest, ticket, capture, runbook,
│                            system-profile, review
├── bin/pkm                ← CLI: find, err, new, sys, index, map, conflicts, stats, check
├── MAP.md                 ← generated dependency graph (Mermaid, renders on GitHub)
├── templates/             ← note templates with the required frontmatter
├── systems/  runbooks/  incidents/  references/  decisions/  contacts/
├── inbox/                 ← zero-friction capture
├── sources/               ← raw PDFs (git-ignored); digests go in references/
└── archive/
```

## The design in one paragraph

Claude has no memory between sessions, so the repo *is* the memory. Every design choice follows
from that: plain markdown so it is greppable and portable; YAML frontmatter so `rg` acts as a
query engine with no index to maintain; a deliberately short `CLAUDE.md` because it costs
context on every session; skills instead of ad-hoc prompting so the workflow quality does not
depend on how you are feeling at 2am; and a hard rule that every solved problem becomes an
incident note, because that is the knowledge nobody else has.
