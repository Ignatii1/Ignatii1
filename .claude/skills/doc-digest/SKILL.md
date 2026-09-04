---
name: doc-digest
description: Analyse a large vendor document — PDF manual, release notes, KB article, RFC, config export — and produce a compact reference note capturing only what matters for our environment. Use for any documentation too long to re-read on demand.
---

# Doc digest

Vendor docs are long, generic, and mostly irrelevant to us. The digest keeps the 5% that is
load-bearing and makes it findable. **The original stays in `sources/` (git-ignored); only the
digest is committed.**

## Process

1. Put the original in `sources/`. Note its **version and publication date** — a digest of an
   unversioned doc is a trap.
2. `bin/pkm new reference <slug> "<title>"`
3. Read the source. For a large PDF, work section by section rather than trying to hold it all
   at once; record page numbers as you go — every fact in the digest cites its page so the
   original can be checked without re-reading it whole.
4. Fill the template, prioritising these sections:

### "Questions this document answers"
Written as questions **you would actually type at 2am**. This is the retrieval surface — it is
what makes the digest findable months later. Ten specific questions beat a paragraph of summary.

### "What applies to OUR environment"
The entire point of the digest. Not a summary of the document — the **delta** between what the
vendor describes and how we are actually set up. Requires reading `systems/<slug>.md` alongside
the source. If our config diverges from the vendor's assumptions, that divergence is the single
most valuable line in the note.

### "Gotchas / version-specific traps"
Deprecations, breaking changes, defaults that changed between versions, features that require
a licence tier we do not have.

### "Explicitly NOT covered"
Prevents future-you re-reading 200 pages hoping the answer is in there.

## Handling bad documentation

Most vendor and internal documentation is some mix of outdated, contradictory, and wrong. The
digest is where that gets recorded rather than silently absorbed.

- **Set `trust:` honestly.** `authoritative` (vendor, current version) · `verified-here` (we
  confirmed it against our actual environment) · `unverified` (plausible, untested) ·
  `contradicted` (conflicts with another source) · `inferred` (we worked it out, the doc did
  not say). Most facts start `unverified`, and that is fine — a labelled unknown is safe.
- **Fill the Contradictions table whenever two sources disagree.** Record both claims and the
  page/path of each. Never resolve a conflict by quietly preferring one source: if you have
  not tested it in our environment, you do not know which is right, and picking one creates a
  confident error that survives for years.
- **Internal docs written by a predecessor are `unverified` by default**, however authoritative
  they look. They describe the environment as it was when written.
- **Date everything.** A fact with no date and no version cannot be aged out later, so it
  silently becomes permanent.
- When a doc is simply too poor to digest, say so and record only the few facts worth keeping.
  A short honest digest beats a long one padded with material you do not trust.

## Rules

- **Do not restate general product documentation.** If it is in the vendor's search index, it
  does not belong here. Record only: our-environment specifics, non-obvious behaviour, and
  hard-won interpretation.
- Every factual claim cites a page: `(p. 47)`. Unsourced claims in a digest are worse than
  no digest — they look authoritative and cannot be checked.
- If the doc contradicts a vault note, **flag it loudly** rather than silently preferring one.
  Either our config drifted or the doc version does not match what we run. Both need a human.
- Distinguish "the doc says X" from "I infer X". Mark inferences as inferences.
- Set `source_version:` in frontmatter. When the vendor ships a new version, that field is how
  you know the digest needs revisiting.

## Finish

```bash
bin/pkm index && bin/pkm conflicts    # conflicts lists every unresolved contradiction
```
Then link the digest from the relevant `systems/` profile — an unlinked reference is orphaned.
