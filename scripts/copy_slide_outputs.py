"""Copy rendered slide assets into the book output directory.

Run from the repository root after rendering ``docs/slides/intro.qmd``.
This replaces shell-specific ``mkdir``/``rm``/``cp`` commands so ``make full``
works on Windows as well as macOS/Linux.
"""

from __future__ import annotations

import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"
SITE = ROOT / "_site"


def replace_path(source: Path, target: Path) -> None:
    if target.is_dir():
        shutil.rmtree(target)
    elif target.exists():
        target.unlink()

    target.parent.mkdir(parents=True, exist_ok=True)
    if source.is_dir():
        shutil.copytree(source, target)
    else:
        shutil.copy2(source, target)


def main() -> int:
    replace_path(DOCS / "slides" / "intro.html", SITE / "slides" / "intro.html")
    replace_path(DOCS / "slides" / "intro_files", SITE / "slides" / "intro_files")
    replace_path(DOCS / "styles" / "watermark.css", SITE / "styles" / "watermark.css")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
