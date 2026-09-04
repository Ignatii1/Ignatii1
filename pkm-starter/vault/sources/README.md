# sources/

Raw vendor PDFs, manuals, config exports, ticket exports.

**These files ARE committed to git.** That is deliberate: Claude Code on the web runs in a
cloud container that has only the cloned repo — it cannot see files on your laptop. A
git-ignored `sources/` would be invisible to it, and `doc-digest` would have nothing to read.

## Workflow

1. Commit the document here (or drag it into the chat and ask Claude to save it here).
2. Run the `doc-digest` skill → writes a digest into `references/` citing this file and page.
3. The digest is what you search day to day; the original stays for exact wording.

## Keep it manageable

- Name files with the version: `exchange-2019-cu14-admin-guide.pdf`, not `manual.pdf`.
- A repo over ~1 GB gets slow to clone. If you accumulate large PDFs, either enable Git LFS
  (`git lfs track "sources/*.pdf"`) or delete originals once the digest is solid and you have
  the file elsewhere — record where in the digest's `source:` field.
- **Do not commit anything NDA-covered or licence-restricted** without checking you are allowed
  to store it in this repo. When in doubt, keep the original out and note in the digest where
  it lives instead. The digest works fine without the original; it just cannot be re-verified
  as easily.
