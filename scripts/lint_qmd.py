#!/usr/bin/env python3
"""Lítill linter fyrir Quarto-bókina.

Athugar hverja .qmd heimildaskrá undir docs/ (sleppir _freeze/):

  * frontmatter með `title:` og `description:`
  * skrá endar á nákvæmlega einni línuendingu (ekki engri, ekki mörgum auðum)

Athugið: aftaná-bil eru EKKI flögguð — tvö aftaná-bil eru gild Markdown (hard
line break), svo það væri rangt að strippa þau sjálfvirkt.

Notkun:
  python scripts/lint_qmd.py            # athugar allar docs/**/*.qmd
  python scripts/lint_qmd.py <skrár>    # athugar tilteknar skrár
  python scripts/lint_qmd.py --fix ...  # lagar öruggu newline-atriðin sjálfvirkt

Skilar 0 ef allt er í lagi, annars 1 (svo það virki sem CI-tékk).
"""
from __future__ import annotations
import sys, re, glob, io, os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def qmd_files(args: list[str]) -> list[str]:
    if args:
        return args
    base = os.path.join(ROOT, "docs")
    files = glob.glob(os.path.join(base, "**", "*.qmd"), recursive=True)
    return [f for f in files if os.sep + "_freeze" + os.sep not in f]


def frontmatter(text: str) -> str | None:
    m = re.match(r"^---\r?\n(.*?)\r?\n---", text, re.S)
    return m.group(1) if m else None


def fix_newlines(text: str) -> str:
    """Öruggar lagfæringar: nákvæmlega ein línuending í enda skrár."""
    return text.rstrip("\n") + "\n" if text else text


def lint_file(path: str, fix: bool = False) -> list[str]:
    problems: list[str] = []
    with io.open(path, encoding="utf-8") as fh:
        text = fh.read()

    if fix:
        fixed = fix_newlines(text)
        if fixed != text:
            with io.open(path, "w", encoding="utf-8", newline="\n") as fh:
                fh.write(fixed)
            text = fixed

    fm = frontmatter(text)
    if fm is None:
        problems.append("vantar YAML frontmatter (---) efst")
    else:
        if not re.search(r"^title:\s*\S", fm, re.M):
            problems.append("vantar `title:` í frontmatter")
        if not re.search(r"^description:\s*\S|^description:\s*>", fm, re.M):
            problems.append("vantar `description:` í frontmatter")

    if text and not text.endswith("\n"):
        problems.append("skrá endar ekki á línuendingu")
    if text.endswith("\n\n"):
        problems.append("skrá endar á fleiri en einni auðri línu")

    return problems


def main(argv: list[str]) -> int:
    args = [a for a in argv[1:] if a != "--fix"]
    fix = "--fix" in argv[1:]
    files = qmd_files(args)
    total = 0
    for path in sorted(files):
        problems = lint_file(path, fix=fix)
        if problems:
            total += len(problems)
            rel = os.path.relpath(path, ROOT)
            print(rel)
            for p in problems:
                print(f"  - {p}")

    n = len(files)
    if total:
        print(f"\n{total} athugasemd(ir) í {n} skrám skoðuðum.")
        if not fix:
            print("Keyrðu með --fix til að laga newline-atriðin sjálfvirkt.")
        return 1
    print(f"OK — engar athugasemdir ({n} skrár).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
