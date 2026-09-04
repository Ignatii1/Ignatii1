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
bin/pkm index
```
Then link the digest from the relevant `systems/` profile — an unlinked reference is orphaned.
