"""Update the committed DB-Engines ranking include.

This script fetches https://db-engines.com/en/ranking, extracts the top rows from
its HTML table, and rewrites docs/sql-basics/includes/db-engines-ranking.qmd.
The rendered course material includes that generated QMD file, so normal Quarto
builds do not depend on live network access.
"""

from __future__ import annotations

from dataclasses import dataclass
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urljoin
from urllib.request import Request, urlopen
import argparse
import re
import ssl
import sys

URL = "https://db-engines.com/en/ranking"
OUT = Path("docs/sql-basics/includes/db-engines-ranking.qmd")
MONTHS_IS = {
    "January": "janúar",
    "February": "febrúar",
    "March": "mars",
    "April": "apríl",
    "May": "maí",
    "June": "júní",
    "July": "júlí",
    "August": "ágúst",
    "September": "september",
    "October": "október",
    "November": "nóvember",
    "December": "desember",
}


@dataclass
class Cell:
    text: str = ""
    links: list[tuple[str, str]] | None = None


class TableParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.in_table = False
        self.table_depth = 0
        self.in_row = False
        self.in_cell = False
        self.current_row: list[Cell] = []
        self.current_cell: Cell | None = None
        self.current_href: str | None = None
        self.rows: list[list[Cell]] = []
        self.page_text: list[str] = []
        self.skip_depth = 0

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attrs_d = dict(attrs)
        class_name = attrs_d.get("class") or ""
        if self.in_cell and tag == "span" and "info" in class_name.split():
            self.skip_depth += 1
            return
        if self.skip_depth:
            self.skip_depth += 1
            return
        if tag == "table":
            if not self.in_table:
                self.in_table = True
                self.table_depth = 1
            elif self.in_table:
                self.table_depth += 1
        elif self.in_table and tag == "tr":
            if self.in_row:
                self._finish_cell()
                self._finish_row()
            self.in_row = True
            self.current_row = []
        elif self.in_table and tag in {"td", "th"}:
            if self.in_cell:
                self._finish_cell()
            self.in_cell = True
            self.current_cell = Cell("", [])
        elif self.in_cell and tag == "a":
            self.current_href = attrs_d.get("href")
        elif self.in_cell and tag == "br":
            self._append_text(" ")

    def handle_endtag(self, tag: str) -> None:
        if self.skip_depth:
            self.skip_depth -= 1
            return
        if self.in_cell and tag == "a":
            self.current_href = None
        elif self.in_table and tag in {"td", "th"}:
            self._finish_cell()
        elif self.in_table and tag == "tr":
            self._finish_cell()
            self._finish_row()
        elif self.in_table and tag == "table":
            self._finish_cell()
            self._finish_row()
            self.table_depth -= 1
            if self.table_depth == 0:
                self.in_table = False

    def handle_data(self, data: str) -> None:
        self.page_text.append(data)
        if self.in_cell and not self.skip_depth:
            self._append_text(data)
            if self.current_href and self.current_cell is not None:
                text = clean_text(data)
                if text:
                    self.current_cell.links.append((text, urljoin(URL, self.current_href)))

    def _append_text(self, data: str) -> None:
        if self.current_cell is not None:
            self.current_cell.text += data

    def _finish_cell(self) -> None:
        if self.current_cell is not None:
            self.current_cell.text = clean_text(self.current_cell.text)
            self.current_row.append(self.current_cell)
        self.current_cell = None
        self.in_cell = False
        self.current_href = None

    def _finish_row(self) -> None:
        if self.current_row:
            self.rows.append(self.current_row)
        self.current_row = []
        self.in_row = False


def clean_text(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip()


def markdown_link(label: str, href: str | None) -> str:
    if not href:
        return label
    return f"[{label}]({href})"


def extract_month(page_text: str) -> tuple[str, str, str]:
    match = re.search(r"(\d+) systems in ranking, ([A-Za-z]+) (\d{4})", page_text)
    if not match:
        return "", "", ""
    return match.group(1), match.group(2), match.group(3)


def parse_rows(html: str) -> tuple[str, str, str, list[dict[str, str]]]:
    systems, month, year = extract_month(clean_text(re.sub(r"<[^>]+>", " ", html)))
    table_match = re.search(r"<table class=dbi>(.*?)(?:</table>|<p><div)", html, flags=re.S)
    if not table_match:
        raise RuntimeError("Could not find DB-Engines ranking table")
    table_html = table_match.group(1)

    data: list[dict[str, str]] = []
    for row_html in re.split(r"<tr[^>]*>", table_html):
        cell_htmls = re.findall(r"<(?:td|th)[^>]*>(.*?)(?=<(?:td|th|tr)\b|$)", row_html, flags=re.S)
        if not cell_htmls:
            continue
        cells = [html_to_text(cell) for cell in cell_htmls]
        if len(cells) < 8 or not re.match(r"^\d+\.?$", cells[0]):
            continue

        dbms_name, dbms_href = first_link(cell_htmls[3])
        dbms_name = dbms_name or cells[3]
        model_html = re.split(r"<span class=info\b", cell_htmls[4], maxsplit=1)[0]
        model = html_to_text(model_html)
        model = model or "—"

        data.append(
            {
                "rank": cells[0].rstrip("."),
                "prev_month": cells[1].rstrip("."),
                "prev_year": cells[2].rstrip("."),
                "dbms": markdown_link(dbms_name, dbms_href),
                "model": model,
                "score": cells[5],
                "delta_month": cells[6],
                "delta_year": cells[7],
            }
        )
        if len(data) == 10:
            break

    if len(data) < 10:
        raise RuntimeError(f"Expected at least 10 ranking rows, found {len(data)}")
    return systems, month, year, data


def html_to_text(html: str) -> str:
    html = re.sub(r"<br\s*/?>", " ", html, flags=re.I)
    html = re.sub(r"<[^>]+>", "", html)
    html = html.replace("&amp;", "&").replace("&nbsp;", " ")
    return clean_text(html)


def first_link(html: str) -> tuple[str, str]:
    match = re.search(r'<a\s+href="([^"]+)">([^<]+)</a>', html)
    if not match:
        return "", ""
    return html_to_text(match.group(2)), urljoin(URL, match.group(1))


def build_qmd(systems: str, month: str, year: str, rows: list[dict[str, str]]) -> str:
    month_label = MONTHS_IS.get(month, month)
    title = f"DB-Engines Ranking, {month_label} {year}" if month and year else "DB-Engines Ranking"
    summary = f"{systems} kerfi í röðun, {month_label} {year}" if systems and month and year else "DB-Engines Ranking"
    lines = [
        f"::: {{.callout-note title=\"{title}\"}}",
        f"Taflan er afrit af efstu 10 sætunum í [DB-Engines Ranking]({URL}). Hún er geymd sem stöðug tafla í námsefninu og má endurnýja mánaðarlega með `scripts/update_db_engines_ranking.py`.",
        "",
        f"*{summary}*",
        "",
        "| Sæti | Fyrri mán. | Fyrra ár | Gagnagrunnskerfi | Gagnalíkan | Einkunn | Breyting frá fyrri mán. | Breyting frá fyrra ári |",
        "|---:|---:|---:|---|---|---:|---:|---:|",
    ]
    for row in rows:
        lines.append(
            "| {rank} | {prev_month} | {prev_year} | {dbms} | {model} | {score} | {delta_month} | {delta_year} |".format(**row)
        )
    lines.append(":::")
    lines.append("")
    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--insecure",
        action="store_true",
        help="Disable TLS certificate verification. Use only when local Python certificates are misconfigured.",
    )
    args = parser.parse_args(argv)

    req = Request(URL, headers={"User-Agent": "IDN302G course material updater"})
    context = ssl._create_unverified_context() if args.insecure else None
    with urlopen(req, timeout=30, context=context) as response:
        html = response.read().decode("utf-8", errors="replace")
    systems, month, year, rows = parse_rows(html)
    OUT.write_text(build_qmd(systems, month, year, rows), encoding="utf-8")
    print(f"Wrote {OUT} from {month} {year}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
