# Agent Instructions

This file gives GitHub Copilot and other AI coding agents context about this project.
It is read automatically by agents working in this repository.

## Project context

This is a **student project** for the university course *Upplýsingaverkfræði IÐN302G*
at the University of Iceland. The code will be read, reviewed, and assessed by:
- Teammates during code review
- Peers from other groups during peer review
- The course instructor during in-class oral questioning

Write code and comments accordingly — clarity and explainability matter as much as correctness.

## Project overview

[Short description of the project and its goal]

## Language

- Code: English (variable names, comments, commit messages)
- Documentation: [Icelandic / English — match TEAM.md]

## Tech stack

- Language: [Python / R / SQL]
- Database: [SQLite / PostgreSQL]
- Reporting: [Quarto / R Markdown / Jupyter]

## Repository structure

Keep the folder structure flat, logical, and consistent from the start.

```
project-repo/
├── data/
│   ├── raw/          ← Original source data — never modified
│   └── processed/    ← Cleaned and transformed data
├── src/              ← All code (scripts, queries, functions)
├── reports/          ← Quarto/Markdown reports and iREF reflections
│   └── iREF/         ← Individual reflections, one file per person per module
├── AGENTS.md         ← This file
├── CONTRIBUTING.md   ← Team workflow and git conventions
├── README.md         ← Project overview
└── TEAM.md           ← Team agreement
```

### File and folder naming

- All file and folder names are in **English**
- Use `kebab-case` for filenames: `clean-data.R`, `sql-queries.sql`, `regex-patterns.py`
- No spaces, no special characters, no uppercase in filenames
- Be descriptive: `filter-missing-values.R` not `script1.R`
- Reports and documentation may be written in Icelandic — only the *filename* must be English

## Coding conventions

- Use descriptive variable names — a reader should understand what a variable holds without context
- Write comments that explain *why*, not *what* — the code shows what; comments explain intent
- Write functions for repeated logic
- Keep SQL queries readable — one clause per line
- Do not hardcode file paths — use relative paths from repo root

## Git workflow

### Branches
- Never commit directly to `main`
- Create a branch for each logical piece of work: `eining/lýsing` (e.g. `sql/clean-nulls`)
- Keep your branch up to date with `main` — rebase or merge regularly to avoid drift

### Commits
- Commit frequently, but only when a change is **cohesive and complete** — do not commit
  broken or half-finished code just to save progress
- Each commit should do one thing and do it fully
- Write commit messages in the format:
  ```
  type: short description in present tense

  Longer explanation if needed — why this change, not what it does.
  ```
  Types: `feat`, `fix`, `data`, `docs`, `refactor`, `style`
- A commit message like `"changes"` or `"stuff"` is not acceptable

### Pull Requests
- Open a PR when a branch is ready for review — not before
- Fill in the PR template fully — describe *why*, not just *what*
- Request review from at least one teammate
- Do not merge your own PR without a review

## What agents should NOT do

- Do not commit directly to `main`
- Do not open a PR that is not ready for review
- Do not write code that the student cannot explain to the instructor
- Do not modify files in `data/raw/` — these are immutable source files
- Do not commit credentials, API keys, or passwords
- Do not make large, unfocused commits — split work into logical units

## Code review checklist

When reviewing a PR (whether opened by an agent or a teammate):
- Read every changed line — do not approve code you do not understand
- Check that the logic matches the stated goal in the PR description
- Run the code locally if unsure about the output
- Leave inline comments on anything unclear — ask, don't assume
- Approval means you take shared responsibility for the code
