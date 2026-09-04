---
name: ticket
description: Turn a pasted or exported helpdesk ticket (IntraService or any other system) into a structured incident note, extracting the real technical content from the conversational noise. Use when closing a ticket that taught you something worth keeping.
---

# Ticket → incident

Helpdesk tickets are mostly noise wrapped around a small amount of hard-won knowledge. This
extracts the knowledge and discards the rest.

## Input

Paste the ticket into `inbox/`, or drop an export there. Anything works: the web UI copy-paste,
an email thread, a CSV/JSON export from IntraService's API, a screenshot.

> **Live API integration is generally not available from Claude Code on the web.** The session
> runs in a cloud container that cannot reach an internal helpdesk instance. Paste or commit an
> export instead — this is a network reality, not a limitation of the vault.

## Extract

Read the whole ticket, then pull out only:

| Keep | Discard |
|------|---------|
| Verbatim error strings, IDs, timestamps | Greetings, escalation chatter, "any update?" |
| What the user actually did before it broke | Speculation that turned out wrong (unless it was *plausible* and wrong — that goes in "did NOT work") |
| The diagnostic steps and their results | Internal routing/assignment churn |
| The actual fix, and why it worked | Ticket status transitions |
| The root cause, if established | Apologies and pleasantries |

Then: `bin/pkm new incident <slug> "<title>"` and fill the template.

## Rules

- **Preserve error text in its original language, verbatim.** If your ticket system and users
  write in Russian, keep the Russian string exactly — it is the literal thing you will grep
  for next time. Add English keywords to `tags:` as well so both routes find the note.
- **Link the ticket ID** in the note (`ticket: IS-12345`) so the vault and helpdesk stay
  cross-referenced, but never rely on the helpdesk as the knowledge store — tickets get
  archived, reassigned, and purged; the vault is what persists.
- **Pseudonymise the reporter.** `USER-A`, `CUST-03`. The technical content is what matters
  and personal data is a liability in a documentation repo.
- **If the ticket was closed without a real root cause, say so.** `status: open`, and record
  what is unknown. "Restarted it and it went away" is an honest and useful note; dressing it
  up as a root cause poisons the vault for the next occurrence.
- Many tickets teach nothing. Closing one with "not worth a note" is a correct outcome —
  say so and move on rather than manufacturing content.
