# Agent Instructions — IDN302G (public)

This is the **student-facing course book** for *Upplýsingaverkfræði IÐN302G* at the
University of Iceland. Published at [hi-idn.github.io/IDN302G](https://hi-idn.github.io/IDN302G).

## Structure

```
public/
├── docs/             ← Source for the Quarto book; edit content here
│   ├── about-course/ ← Course overview, schedule, learning outcomes, repo guide
│   ├── github/       ← Git og GitHub module
│   ├── ai-tools/     ← Erindrekar (AI agents) module
│   ├── regex/        ← Reglulegar segðir module
│   ├── sql-basics/   ← SQL grunnatriði module
│   ├── sql-advanced/ ← SQL framhald module
│   ├── storytelling/ ← Myndræn framsetning module
│   ├── index.qmd     ← Landing page
│   ├── _freeze/      ← Frozen results of executed code (committed; lets CI skip R)
│   └── _quarto.yml   ← Quarto book configuration; outputs to ../_site
├── templates/        ← Student templates (repo root); linked from the book via GitHub URLs
└── _site/            ← Rendered output; built by GitHub Actions, NOT committed
```

## Language

- All readable content is written in **Icelandic**
- File and folder names are in **English**
- Do not add English prose to `.qmd` or `.md` content files

## Content guidelines

- This is a Quarto book — source files are `.qmd` and `.md`
- Edit source files under `docs/`
- Templates live in `templates/` at the repo root and are for students to copy into their
  own repos; keep them generic. The book links to them with GitHub URLs
  (`github.com/HI-IDN/IDN302G/blob/main/templates/...`), not relative paths
- The `_quarto.yml` controls navigation — update it when adding or renaming pages
- If you change an executable code cell, re-render locally so `docs/_freeze/` updates,
  and commit the refreshed `_freeze/` — otherwise CI serves stale results

## Building and publishing

Publishing is automated: **GitHub Actions** renders the book and deploys it to GitHub Pages.
Because executed code results are committed in `docs/_freeze/` (`execute: freeze: auto`), CI
builds with Quarto only — it does not install R. You do **not** commit the built site; `_site/`
is generated in the cloud and is gitignored.

Use the `Makefile` in the repository root (`public/`) for local work:

- `make` — render only changed pages (fast, for content edits)
- `make full` — full render; required after `_quarto.yml`, `styles/*.scss`, or any
  structural/chapter change, because those affect the sidebar/theme on **every** page
- `make preview` — live preview with auto-reload while editing
- `make server` — static server on the built `_site/` to inspect the final output

**Workflow:**

1. Edit source under `docs/`; preview with `make preview`.
2. If you touched executable code, run `make full` so `docs/_freeze/` is up to date.
3. `main` is protected — commit on a branch and open a pull request. Draft PRs skip CI;
   mark **Ready for review** to trigger the render check. Merging to `main` publishes.

Committing and pushing happens **only when the user explicitly asks**; do not push on your own.

## Scope

This is a standalone repository. It has no knowledge of any parent or admin repository.
All context needed to work on this codebase is contained here.

## What does NOT belong here

- Student names, grades, or feedback
- Per-group or per-student content
- Anything that is not course material, templates, or Quarto configuration
