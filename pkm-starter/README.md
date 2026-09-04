# PKM Starter — work knowledge vault for IT systems support

A ready-to-deploy personal knowledge management system designed to be driven by Claude Code.

> ⚠️ **Do not merge this into `main` of `Ignatii1/Ignatii1`.** That repo is your **public**
> GitHub profile. This kit is delivered here only as a transport mechanism — deploy it into a
> separate **private** repo and keep real work notes out of the public one.

## Deploy

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
├── .claude/skills/        ← triage, capture, doc-digest, runbook, system-profile, review
├── bin/pkm                ← CLI: find, new, sys, index, stats, check
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
