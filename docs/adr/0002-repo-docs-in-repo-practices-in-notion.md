# Repo docs live in the repo; Notion holds Practices and the index

Anything that describes one repo (how it works, why, gotchas, runbooks) lives in that repo, next to the code it describes, so both change in the same commit and an Agent working on the repo has it checked out. Notion's Development → Dev Docs holds only Practices that apply across repos and one index row per repo doc, pointing to the file on GitHub. Nothing repo-specific is copied into Notion, because two copies drift.

## Considered Options

- **Everything in Notion**: one place to browse, but goes stale against the code and needs a Notion connection to read.
- **Both, kept in sync**: rejected; nothing enforces the sync.
