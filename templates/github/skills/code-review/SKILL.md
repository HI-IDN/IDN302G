# Lightweight code review sanity check

Use this skill when reviewing pull requests in this repository.

This is a student team repository for IÐN302G. Keep the review lightweight, practical, and focused on
whether the PR is safe to merge and easy for teammates to understand.

## When to review

If the pull request is still a draft, do not perform a full review unless the requester explicitly
asks for a review in a PR comment.

For draft PRs without an explicit review request, respond briefly that the PR should be verified by
the requester first and reviewed when it is marked ready for review.

## Review focus

Check whether the PR:

- is scoped to one clear, reviewable task,
- references or explains the relevant GitHub Issue when appropriate,
- was opened as a draft before broader review,
- has enough explanation for teammates to understand what changed and why,
- is consistent about AI/agent use: if the PR description, commit messages, or changed files mention
  AI-assisted work, check whether the submitter updated `AGENT_LOG.md` or explained why no log entry
  is needed,
- edits source files rather than generated output,
- avoids secrets, credentials, private data, large files, caches, and local environment files.

## Quarto / GitHub Pages checks

For changes that affect the site:

- source should usually be under `site/`,
- `docs/` should not be edited directly,
- the PR description should say how the site was tested locally,
- someone on the team should verify the localhost preview before merge,
- GitHub Actions will render and publish the site after changes reach `main`.

## Tone

Prefer a short sanity-check review over a long exhaustive critique.

Only comment when there is something actionable, unclear, risky, or inconsistent with the project
workflow. If everything looks reasonable, say so briefly.

Do not update `AGENT_LOG.md` as part of the review. The log is the submitter's responsibility.
