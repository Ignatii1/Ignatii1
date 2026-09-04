---
name: runbook
description: Write or update a repeatable operational procedure, usually promoted from an incident that has now happened three times. Use when documenting how to perform a recurring task safely.
---

# Runbook

A runbook is for **future-you at 3am under pressure**. Optimise for unambiguous execution, not
for explanation.

## When to write one

- Third occurrence of the same incident → promote it. Search first: `bin/pkm find "<symptom>"`.
- Any procedure someone else may have to run while you are on leave.
- Anything with a rollback that is non-obvious.

## Process

```bash
bin/pkm new runbook <slug> "<title>"
```

Pull the steps from the source incidents (link them in). Then harden:

1. **Preconditions** — what must be true before starting. Access, approvals, change window,
   a verified backup. Written as checkboxes.
2. **Steps** — numbered, one action each, exact commands in code blocks. After each,
   *Expect:* the observable result. If a step's outcome is not observable, it cannot be
   verified, and the runbook is not finished.
3. **Verification** — how you know it actually worked, independent of step output. "The service
   started" is not verification; "a test message delivers end-to-end" is.
4. **Rollback** — **mandatory**. If you cannot describe how to undo it, the runbook is not
   ready and should stay `status: draft`. Say so rather than shipping it.
5. **Blast radius** — who is affected, who to notify first, at the top where it cannot be missed.

## Rules

- Exact commands, no placeholders except clearly marked `<ANGLE_BRACKETS>` with an explanation
  of where the value comes from.
- Never inline credentials — `1Password → "<item>"`.
- Mark destructive steps unmistakably: **⚠️ DESTRUCTIVE — cannot be undone without a restore.**
- `status: draft` until executed end-to-end at least once. Set `last_executed:` when run —
  an untested runbook is a hypothesis, and mislabelling one as verified is how outages
  get worse.
- Every execution is a review: if reality differed from the runbook, fix the runbook **in the
  same session**, and add a row to the change log. Drift is the normal failure mode.

## Finish

Cross-link the source incidents and the system profile's **Recurring work**, then:
```bash
bin/pkm index
```
