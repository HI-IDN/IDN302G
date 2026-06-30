---
description: >-
  Skipanaskrár halda utan um SQL skipanir svo hægt sé að endurkeyra þær án þess að skrifa þær 
  aftur. Tilvalið fyrir útgáfustýringu og endurkeyrslu.
---

Algengt er að búa til skrár sem innihalda SQL skipanir til að skilgreina og setja upp töflur.

# Skipanaskrár fyrir _SQLite_

Innlestur SQL skipana er gert með `.read` skipuninni, sem les inn SQL skipanir úr skrá og framkvæmir
þær:

``` 
-- Read and execute commands from a file 
sqlite3 grunnur.db < skipanir.sql 
```

> **Athugið:**
> - Takið eftir að goggurinn `<` er notaður til að lesa inn skipanir úr skrá.
> - Passið að nota ekki `>` gogginn, því hann skrifar yfir gögn í skránni.

Til að búa til skrá með öllum skipunum sem skilgreina núverandi gagnagrunn, notum við `.dump`
skipunina:

```
-- Dump all SQL commands to a file 
.dump > skipanir.sql
-- Export commands for a specific table, for example, operators 
.dump operators 
```

`.dump` skipunin skrifar SQL skipanir sem endurskapa núverandi töflur og gögn, sem er gagnlegt fyrir
afritun og flutning gagnagrunns.

# Skipanaskrár fyrir _PostgreSQL_

Til að lesa inn SQL skipanir úr skrá, notum við `psql` skipunina:

```bash
-- Read and execute commands from a file
psql -U notandi -d gagnagrunnur -f skipanir.sql
```

Til að búa til skrá með öllum SQL skipunum sem skilgreina núverandi gagnagrunn, er hægt að nota
`pg_dump` skipunina:

```bash
-- Dump all SQL commands to a file
pg_dump -U notandi gagnagrunnur > skipanir.sql
```

`.dump` skipunin skrifar SQL skipanir sem endurskapa núverandi töflur og gögn, sem er gagnlegt
fyrir afritun og flutning gagnagrunns.

