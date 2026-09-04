---
name: explain
description: Build an end-to-end picture of how something works across multiple systems — a data path, a login flow, a mail journey, "what happens when a user clicks X". Use when you need to understand the whole rather than one component, or when onboarding onto an unfamiliar part of the estate.
---

# Explain

For the question "how does this actually work end to end?" — the one that is hard because the
answer is spread across five systems and nobody wrote it down.

## Process

1. **Start from the map.** Read `MAP.md` (regenerate first: `bin/pkm map`). It gives the
   dependency skeleton — which systems touch which, and what the blast radius is.
2. **Walk the path**, not the alphabet. Follow the actual request/data flow hop by hop. For
   each hop read the system profile's **Topology** and **Where things live**, and note:
   - what the hop does
   - what it depends on to do it
   - how it authenticates to the next hop
   - where it logs, so this hop can be verified during an incident
3. **Pull in incident history** for each system on the path: `bin/pkm sys <slug>`. Past
   failures reveal how a system *actually* behaves, which is frequently not how it is
   documented. The **Known quirks** sections are the highest-value input here.
4. **Mark the gaps explicitly.** You will hit hops with no profile (`MAP.md` lists them as
   "no profile") or profiles with unverified facts. Do not smooth over these — an
   architecture explanation that silently guesses at one hop is worse than one that says
   "hop 3 is undocumented", because the guess gets trusted and repeated.

## Output

Write it into `references/` as `type: reference`, `tags: [architecture]`, with `systems:`
listing **every** system on the path. Structure:

- **The path** — numbered hops, one line each. This is the part you will re-read.
- **A Mermaid diagram** of just this flow (not the whole estate — scope it to the question).
- **Where it breaks** — per hop: the realistic failure mode, and the symptom you would
  actually observe. This is what makes the note useful during an incident rather than only
  during onboarding.
- **How to verify each hop** — the specific log, command, or test that proves a hop is healthy.
  This turns the explanation into a diagnostic tool.
- **Open questions** — what you could not establish, and who would know.

## Rules

- **Vault first, general knowledge second, and label which is which.** You know how Kerberos
  works generally; only the vault knows that our setup has a non-standard SPN. Where you are
  reasoning from general product behaviour rather than a vault fact, say so inline —
  "*(general Exchange behaviour, not verified here)*".
- Do not invent hops to make the diagram tidy. A path with an admitted unknown in the middle
  is accurate; a complete-looking path containing a guess is a trap.
- After writing, feed the gaps back: create stub profiles for undocumented systems and add
  the open questions to the relevant profile's **Open questions / gaps**. The explanation
  should leave the vault better, not just produce a document.
