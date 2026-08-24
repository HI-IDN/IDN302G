# Agent Instructions — IDN302G (public)

This is the **student-facing course book** for *Upplýsingaverkfræði IÐN302G* at the
University of Iceland. Published at [hi-idn.github.io/IDN302G](https://hi-idn.github.io/IDN302G).

## Structure

```
./
├── docs/             ← Source for the Quarto book; edit content here
│   ├── about-course/ ← Course overview, schedule, learning outcomes, repo guide
│   ├── github/       ← Git og GitHub module
│   ├── ai-tools/     ← Erindrekar (AI agents) module
│   ├── regex/        ← Reglulegar segðir module
│   ├── sql-basics/   ← SQL grunnatriði module
│   ├── sql-advanced/ ← SQL framhald module
│   ├── storytelling/ ← Myndræn framsetning module
│   ├── index.qmd     ← Landing page
│   ├── .quarto/      ← Local Quarto cache incl. _freeze/ (gitignored, NOT committed)
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
- If you change an executable code cell, re-render locally and check the result. Nothing about
  execution is committed — CI runs every cell itself (see *Building and publishing*)

## Building and publishing

Publishing is automated: **GitHub Actions** renders the book and deploys it to GitHub Pages.
CI installs both Quarto *and* R, and **executes every runnable code cell from scratch** — see
`.github/workflows/publish.yml`. You do **not** commit the built site; `_site/` is generated in
the cloud and is gitignored.

There is no `execute: freeze:` setting. `docs/.quarto/_freeze/` is a purely local cache and is
gitignored, so nothing you have cached locally reaches CI.

**Two consequences worth knowing:**

- **Any package a runnable cell loads must be installed by the workflow.** The `Install R
  packages` step lists them explicitly with a comment saying which chapter needs each one. Add
  a `library()` call to an executed chunk without updating that step and the build fails.
  Network calls belong in `#| eval: false` chunks so CI never depends on a third-party service
  being up.
- **The local cache can serve stale output.** If a chapter shows results that do not match its
  code — wrong values, or non-ASCII printed as `<U+00E1>` — delete
  `docs/.quarto/_freeze/<chapter>/` and render again. Quarto will not re-execute a chunk whose
  source has not changed, even when the cached result is wrong.

Use the `Makefile` in the repository root for local work:

- `make` — render only changed pages (fast, for content edits)
- `make full` — full render; required after `_quarto.yml`, `styles/*.scss`, or any
  structural/chapter change, because those affect the sidebar/theme on **every** page
- `make preview` — live preview with auto-reload while editing
- `make server` — static server on the built `_site/` to inspect the final output

**Workflow:**

1. Edit source under `docs/`; preview with `make preview`.
2. If you touched executable code, render it and check the output is what you expect. Should
   it look stale, clear `docs/.quarto/_freeze/<chapter>/` and render again.
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
