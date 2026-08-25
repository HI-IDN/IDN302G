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

### Code cells

**Cells must run. Do not paste output by hand.**

Write cells as executable — ```` ```{r} ```` / ```` ```{python} ```` — and let Quarto produce the
output. A hand-written result block looks identical to a real one but drifts silently: the code
changes, the numbers do not. Two real bugs in this book were found only once the cells started
executing, because the pasted output showed a result the code never produced.

The same goes for numbers in prose. Write `` `r nrow(commits)` `` rather than typing the figure —
otherwise the text contradicts the table above it the first time the data changes.

Static output is allowed in exactly one case: **the cell cannot run in CI**. That means it needs a
personal access token (TMDB), writes files, or is a fragment that is not valid on its own. Mark
such cells `#| eval: false` and say in the text why they are not executed. Network requests to
open services are *not* an exception — they run, and a service being briefly down is handled by
`req_timeout()` / `req_retry()` and re-running the build.

**Every cell needs a label.**

```{{r}}
#| label: island-r-2
```

Without one, a failure reports `[unnamed-chunk-14]` and you have to count cells in the file to
find it. With one, the error names it directly. Convention: `<page>-<r|py>-<n>`, unique within
the document.

Cells that load packages should carry `#| message: false` and `#| warning: false`; startup
chatter from `library()` is noise in teaching material.

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

### Python setup

Python packages are pinned in `requirements.txt` at the repository root. The same file is used
locally and by Actions, so a chapter that renders on your machine renders on the build server:

```bash
python -m pip install -r requirements.txt
```

Quarto runs `{python}` cells through **reticulate**, not through the `python` on your `PATH`.
Unless told otherwise, reticulate creates its own environment — one that does not have `pandas`
in it — and the build fails with `ModuleNotFoundError` even though `pip list` shows the package.
Point it at the interpreter you installed into:

```bash
export RETICULATE_PYTHON="$(which python)"
```

Put that line in the `.Renviron` that R reads at startup so it survives between sessions. The
workflow sets the same variable, which is why this failure only ever shows up locally.

### Frozen chapters

`api/good-practices.qmd` carries `execute: freeze: true` because it queries TMDB, which needs a
personal token that must not reach CI. Its results live in `docs/_freeze/` and are committed.
Actions reads them instead of sending the request.

Quarto keys the freeze on the **md5 of the source file**. Any edit invalidates it — including a
typo fix in prose that touches no code. If you change that chapter and do not refresh the freeze,
Actions will try to execute the cell, get `401`, and the build fails.

After editing it, re-render just that file with the token available and commit the result:

```bash
cd docs && quarto render api/good-practices.qmd
git add docs/_freeze/api/good-practices
```

Never let a cell in a frozen chapter print a secret. The freeze stores the output, and the
output is committed.

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
