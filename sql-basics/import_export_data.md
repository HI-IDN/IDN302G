---
description: >-
  Innflutningur og útflutningur gagna í gagnagrunnum, t.d. með CSV skrám. 
---

# _SQLite_

## Innflutningur gagna í _SQLite_

Til að setja inn stór gagnasöfn í töflur í _SQLite_ er hægt að nota `.import` skipunina. Þessi
aðferð gerir það auðveldara að flytja inn gögn úr CSV skjölum í stað þess að nota `INSERT` skipanir
trekk í trekk.

`.import` skipunin í _SQLite_ les inn gögn úr tiltekinni skrá og býr til töflu með þeim gögnum.
Dæmi:

```bash
-- Import data from skra.csv into a table called Nafn 
.import skra.csv Nafn 
```

Það er mikilvægt að passa að nota rétt aðskilnaðartákn. Sjálfgefið er aðskilnaðartáknið `|`, en það
er hægt að breyta því með `.separator` skipuninni:

```bash
-- Set the separator to semicolon 
.separator ;
-- Import data with the new separator 
.import skra.csv Nafn 
```

## Útflutningur gagna

_SQLite_ gerir einnig auðvelt að flytja út gögn með notkun á `.output` og öðrum skipunum til að
skrifa gögn út í skrár, til dæmis á CSV formi.
Til að flytja út gögn á CSV formi, notum við eftirfarandi skipanir:

```
-- Include headers in the output 
.headers on
-- Set the mode to CSV 
.mode csv
-- Set the separator to semicolon 
.separator ;
-- Specify the output file 
.output test.csv
-- Export data from the operators table 
SELECT * FROM operators;
-- Stop writing to the output 
file .output 
```

`.output` skipunin stýrir hvert úttak fyrirspurnar fer, og í þessu tilviki skrifar gögnin út í
skrána `test.csv`.

# PostgreSQL

## Innflutningur gagna

Til að setja inn stór gagnasöfn í töflur í _PostgreSQL_ er hægt að nota `\copy` skipunina í
`psql`. Þessi aðferð gerir það auðveldara að flytja inn gögn úr CSV skrám.

Dæmi um hvernig á að nota `\copy`:

```sql
-- Import data from skra.csv into a table called nafnið
\
copy nafnið FROM 'skra.csv' DELIMITER ',' CSV HEADER;
```

## Útflutningur gagna

Einnig er hægt að flytja út gögn með `\copy` skipuninni í _PostgreSQL_. Til að flytja út gögn á
CSV formi, notum við eftirfarandi skipanir:

```sql
-- Export data from the operators table to a CSV file
\copy
(SELECT * FROM operators) TO 'operators.csv' WITH (FORMAT CSV, HEADER);
```

