---
name: capture
description: Turn raw unstructured material in inbox/ — pasted tickets, chat logs, stack traces, scratch notes — into properly structured, linked, greppable vault notes. Use when the inbox has accumulated, or immediately after dumping something raw.
---

# Capture

Convert `inbox/` into knowledge. Batch work — cheaper than structuring at capture time, which
is what kills these systems.

## Process

1. `ls inbox/` and read each item.
2. For each, classify: **incident** (something broke) · **reference** (external doc knowledge) ·
   **decision** (a choice + rationale) · **system** update · **runbook** material ·
   **contact** · **discard**.
3. Discard aggressively. Not everything is knowledge. A note that will never be re-read is
   pure cost — deleting is a valid, common outcome. Say what you discarded and why.
4. Create with `bin/pkm new <type> <slug> "<title>"`, then fill it in.
5. **Delete the inbox file** once filed. An inbox item that survives capture is a bug.

## Quality bar

Each note must earn its place:

- **`systems:` is mandatory and must match an existing `systems/<slug>.md`.** If the system has
  no profile, create a stub with the `system-profile` skill first — otherwise the note is
  unreachable and effectively does not exist.
- **Preserve verbatim error strings.** Never paraphrase an error message; it is the primary
  retrieval key. Fence it in a code block.
- **Title as a searchable statement**, not a label: "Outlook fails TLS after CA rotation",
  not "Email problem".
- **Strip secrets** — replace with `1Password → "<item>"`. Pseudonymise customer data.
- Add cross-links to related existing notes, both directions.

## When the source is ambiguous

Raw material is often half a story — a chat log with no resolution, a ticket with no root
cause. Do not invent the missing half. Write what is known, mark the gaps explicitly in an
**Open questions** section, and set `status: open`. A note that honestly says "root cause
never established" is far more valuable than a confident fabrication.

Ask the user only about gaps that change the note's usefulness; note the rest inline.

## Finish

```bash
bin/pkm index && bin/pkm check
```
