# sources/

Raw vendor PDFs, config exports, log bundles. **Git-ignored** — these stay on your machine.

Workflow: drop the file here → run the `doc-digest` skill → it writes a digest into
`references/` that cites this file by name and page. The digest is what gets committed and
searched; the original stays local for when you need the exact wording.

Keeping the originals out of git keeps the repo fast to clone and avoids committing
licensed or NDA material.
