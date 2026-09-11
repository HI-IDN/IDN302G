"""Update the committed DB-Engines ranking include.

This script fetches https://db-engines.com/en/ranking, extracts the top rows from
its HTML table, and rewrites docs/sql-basics/includes/db-engines-ranking.qmd.
The rendered course material includes that generated QMD file, so normal Quarto
builds do not depend on live network access.
"""

from __future__ import annotations

from pathlib import Path
from urllib.parse import urljoin
from urllib.error import URLError
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
    table_match = re.search(r"<table\b(?=[^>]*class=[\'\"][^\'\"]*(?:db-ranking|dbi)[^\'\"]*[\'\"]|[^>]*class=(?:db-ranking|dbi)\b)[^>]*>(.*?)(?:</table>|<p><div)", html, flags=re.S)
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
        f"*{summary}*",
        "",
        "| Sæti | Fyrri mán. | Fyrra ár | Gagnagrunnskerfi | Gagnalíkan | Einkunn | Breyting frá fyrri mán. | Breyting frá fyrra ári |",
        "|---:|---:|---:|---|---|---:|---:|---:|",
    ]
    for row in rows:
        lines.append(
            "| {rank} | {prev_month} | {prev_year} | {dbms} | {model} | {score} | {delta_month} | {delta_year} |".format(**row)
        )
    lines.extend(
        [
            "",
            '::: {.callout-note title="Um töfluna"}',
            f"Taflan er afrit af efstu 10 sætunum í [DB-Engines Ranking]({URL}). Hún er geymd sem stöðug tafla í námsefninu og má endurnýja mánaðarlega með `scripts/update_db_engines_ranking.py`.",
            ":::",
        ]
    )
    lines.append("")
    return "\n".join(lines)


def https_context(insecure: bool) -> ssl.SSLContext | None:
    if insecure:
        return ssl._create_unverified_context()

    try:
        import certifi  # type: ignore
    except ImportError:
        return None

    return ssl.create_default_context(cafile=certifi.where())


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--insecure",
        action="store_true",
        help="Disable TLS certificate verification. Use only when local Python certificates are misconfigured.",
    )
    parser.add_argument(
        "--strict-tls",
        action="store_true",
        help="Fail instead of falling back to --insecure when local TLS certificate verification fails.",
    )
    args = parser.parse_args(argv)

    req = Request(URL, headers={"User-Agent": "IDN302G course material updater"})
    context = https_context(args.insecure)
    try:
        with urlopen(req, timeout=30, context=context) as response:
            html = response.read().decode("utf-8", errors="replace")
    except URLError as exc:
        reason = getattr(exc, "reason", None)
        if isinstance(reason, ssl.SSLCertVerificationError) and not args.insecure and not args.strict_tls:
            print(
                "TLS certificate verification failed; retrying with --insecure. "
                "Use --strict-tls to make this a hard failure.",
                file=sys.stderr,
            )
            with urlopen(req, timeout=30, context=ssl._create_unverified_context()) as response:
                html = response.read().decode("utf-8", errors="replace")
        elif isinstance(reason, ssl.SSLCertVerificationError):
            print(
                "TLS certificate verification failed. Install/update local Python certificates "
                "or rerun without --strict-tls to allow the documented fallback.",
                file=sys.stderr,
            )
            raise
        else:
            raise
    systems, month, year, rows = parse_rows(html)
    OUT.write_text(build_qmd(systems, month, year, rows), encoding="utf-8")
    print(f"Wrote {OUT} from {month} {year}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
