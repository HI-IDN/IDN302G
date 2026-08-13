# Agent guidance

This is a student team repository for IÐN302G.

## Core rules

- Work on a branch, never directly on `main`.
- Keep each branch scoped to one clear, reviewable task.
- If the task is becoming too broad for one PR, warn the user and suggest splitting it.
- Prefer starting from a GitHub Issue. If none exists, suggest creating one before substantial work.
- Do not commit secrets, credentials, private data, large files, or generated files unless explicitly justified.
- Edit source files, not generated output.

## Pull Request workflow

- Open PRs as draft first.
- The person requesting the change must verify the draft PR before broader teammate review.
- After requester verification, mark the PR ready for review.
- Resolve all review conversations before merging.
- Merge to `main` only after review.

## Quarto / site changes

The GitHub Pages site is built by GitHub Actions when changes reach `main`.

For site changes:

- edit files under `site/`,
- test locally with `quarto preview`,
- have a team member verify the localhost preview,
- do not edit `docs/` directly.

## Agent log

At the start of each branch, create or update an entry in `AGENT_LOG.md` using `.AGENT_LOG.md`.

Update the same branch entry before opening or updating the PR.

## Co-authorship

If the agent materially contributes to a commit, add:

```text
Co-authored-by: AI Agent <agent@example.com>
```
