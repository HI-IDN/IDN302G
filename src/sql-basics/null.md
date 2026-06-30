---
description: >-
    Oft eru gildi í gagnagrunnum óskilgreind með NULL. Þessi gildi eru ekki tóm gildi, heldur 
    segja þau til um að gildi vanti. Notkun á NULL getur valdið vandræðum í SQL fyrirspurnum.
    
---

# Tóm gildi - `NULL`

SQL leyfir dálkum að vera óskilgreindir með `NULL` gildum, það segir til um að gildi vantar. Þau
eru ekki jafngild `0` eða tómum streng.

Dæmi um hvernig við getum sett inn `NULL` gildi:

```sql
INSERT INTO operators (opID, opName, OpSSN)
VALUES (4, 'Jósef', '1010101010');
```

hér verður `NULL` gildi fyrir `opAge` og `opYearInit`.

## Breytingar á sýnilegum `NULL` gildum í _SQLite_

_SQLite_ sýnir tóman streng fyrir `NULL` gildi en við getum breytt þessari hegðun með:

```bash
.nullvalue NULL 
```

Við getum valið hvaða gildi sem er, t.d. 'NA' eða '-'.

# Samanburður með `NULL`

Samanburður á `NULL` við annað gildi getur valdið vandræðum þar sem niðurstaðan er óþekkt. Til
dæmis:

```sql
SELECT NULL + 3;
```

skilar `NULL` en ekki `0`.

# Rökaðgerðir með `NULL`

Rökaðgerðir eins og `AND`, `OR` og `NOT` skila `NULL` ef einhver þeirra er `NULL`. Til dæmis:

| Skilyrði 1 | Rökvirki | Skilyrði 2 | Niðurstaða |
|------------|----------|-------------|-------------|
| Satt       | AND      | Óþekkt     | Óþekkt     |
| Ósatt      | AND      | Óþekkt     | Ósatt      |
| Satt       | OR       | Óþekkt     | Satt       |
| Ósatt      | OR       | Óþekkt     | Óþekkt     |
|            | NOT      | Óþekkt     | Óþekkt     |

## `NULL` í `SELECT` skipunum

Þegar við notum `SELECT` ásamt `WHERE` skilyrði, þá er þeim línum skilað í úttak þar sem
skilyrðið er satt.

```sql
SELECT *
FROM Patient_list
WHERE Patient_Age > 10;
```

gefur til dæmis ekki línum sem hafa `NULL` gildi í `Patient_Age`.

Til að finna `NULL` gildi þá þarf að nota `IS NULL`:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Age IS NULL;
```

Sambærilega, til að útiloka línur með `NULL` gildi, notum við `IS NOT NULL`:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Age IS NOT NULL;
```

## Töfluskilgreiningar og `NULL`

Hægt er að banna dálkum að vera `NULL` við töfluskilgreiningu:

```sql
CREATE TABLE tbl
(
    col1 INTEGER  NOT NULL,
    col2 CHAR(30) NOT NULL,
    col3 REAL
);
```

Fyrstu tveir dálkarnir leyfa ekki `NULL`, en sá þriðji leyfir það.
