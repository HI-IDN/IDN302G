---
description: >-
  Heilleiki gagna er undirstöðuatriði í SQL og fyrir vikið eru settar skorður til að 
  tryggja rétt inntak. Kynnt er hvernig aðallyklar, ytri lyklar, einstakar skorður og 
  skilyrðisskorður eru notuð.
---

# Heilleiki gagna og skorður

Mikilvægt er að gögn í gagnasafninu séu rétt til að koma í veg fyrir villur og gölluð gögn. 
Við notum skorður til að tryggja rétt inntak í töflur, eins og:

- **Aðallykill (`PRIMARY KEY`)**: Einkvæmur lykill fyrir hverja línu.
- **Ytri lykill (`FOREIGN KEY`)**: Notaður til að tryggja tengsl milli tveggja tafla.
- **Einstakar skorður (`UNIQUE`)**: Tryggir að dálkur sé einkvæmur.
- **Skilyrðisskorður (`CHECK`)**: Tryggir að skilyrði sé uppfyllt.
- **NOT NULL**: Tryggir að dálkur hafi gildi.

# Aðallykill - `PRIMARY KEY`

Aðallykill er dálkur (eða safn dálka) sem ákvarðar línu einkvæmt. Dæmi um notkun aðallykils:

```sql
CREATE TABLE starfsmannalisti
(
    Kennitala INTEGER PRIMARY KEY NOT NULL,
    Nafn      CHAR                NOT NULL,
    Sími      CHAR,
    Aldur     INTEGER DEFAULT 0,
    Upphafsár INTEGER CHECK (Upphafsár > 1990)
);
```
Hér er `Kennitala` aðallykillinn (e. _primary key_), sem þarf að vera einkvæmur og ekki _NULL_. 

> **Athugið**: Aðallykill getur verið samsettur lykill, þar sem tvö eða fleiri dálkar mynda 
> aðallykilinn. En ef lykill er einn dálkur, þá er hann oftast `INTEGER` eða `SERIAL`, og 
> mögulega sjálfvirkt upphækkaður með `AUTOINCREMENT` (þ.e.a.s. þarf ekki að setja gildi í dálkinn).
> Kosturinn við hafa einn dálk er að hann er þá kjörinn kandídat til að vera ytri lykill í 
> annarri töflu.

 # Ytri lykill - `FOREIGN KEY`
Ytri lyklar eru notaðir til að viðhalda tengslum milli tveggja tafla. Dæmi um notkun ytri lykils:

```sql
CREATE TABLE nemenda_skraning
(
    kennitala   INTEGER REFERENCES nemendur (kennitala),                       -- Foreign key
    namskeid_id INTEGER NOT NULL,
    year        INTEGER NOT NULL CHECK (year > 2010),                         -- Skilyrði
    einkunn     DECIMAL(2, 1),                                                 -- 2 stafir, 1 aukastafur
    PRIMARY KEY (kennitala, namskeid_id),                                      -- Composite primary key    
    FOREIGN KEY (year, namskeid_id) REFERENCES kennsluskra (year, namskeid_id) -- Composite foreign key
);
```
Hér eru tveir ytri lyklar, `kennitala` og `namskeid_id`, sem tengjast við aðallykla í öðrum 
töflum. Hægt er að skilgreina ytri lykil í sömu línu og dálkagerðinn er skilgreind, eða neðst 
með `FOREIGN KEY` skipuninni. Hér þarf að passa að dálkagerðin á ytri lyklinum sé sú sama í 
báðum dálkum. Ekki er krafa að ytri lykillinn sé aðallykill, en skv. góðri venju er hann það 
yfirleitt.

Hér má líka sjá dæmi um hvernig hægt er að búa til samsettan aðallykil með `PRIMARY KEY`.


# Einstakar skorður - `UNIQUE`

Einstakar skorður tryggja að öll gildi í ákveðnum dálki séu ólík. Dæmi:

```sql
CREATE TABLE kennarar
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kennitala CHAR(10) UNIQUE,
    nafn CHAR(50) NOT NULL
);
```
Þegar `UNIQUE` er sett á dálk, þá er gildið í dálkinum einkvæmt. Hér hefði `kennitala` alveg 
eins getað verið aðallykillinn. En yfirleitt viljum við að aðallykillinn sé heiltala og 
sjálfvirkt upphækkaður.

> **Athugið**: 
> - **Ytri lyklar**: Oftast er æskilegt að gera ytri lykla á primary lykla, þar sem það 
>   auðveldar tengsl milli tafla.
> - **Plássnýting**: Til að halda gagnagrunninum eins „nettum“ og mögulegt er, er gott að reyna 
>   að hafa minnstu mögulegu dálkagerð. Til dæmis, að nota `SMALLINT` í stað `INTEGER` eða 
>   `CHAR(10)` í stað `CHAR(20)`, þar sem við vitum að kennitölur verða aldrei lengri en 10 stafir.
> - **Einkvæm gildi**: Það er ekki æskilegt að hafa `nafn` sem einstaka skorðu, því innan VON 
>    eru t.d. alnafnarnir Gunnar Stefánsson.

# Skilyrðisskorður - `CHECK`
Skilyrðisskorður leyfa aðeins gildi sem uppfylla tiltekin skilyrði. Dæmi:

```sql
CREATE TABLE vörur
(
    vöruID INTEGER PRIMARY KEY,
    verð DECIMAL CHECK (verð > 0)
);
```
Hér er verið að tryggja að verð vörunnar sé alltaf stærra en 0. Skilyrðisskorður geta verið 
margar og flóknar, og þau geta verið á einum eða mörgum dálkum.

Þegar skilyrðisskorður eru settar á töflu, þá er ekki hægt að setja inn nýjar línur (eða uppfæra 
dálkinn) sem brjóta skilyrðið. 

# `NOT NULL` skorður
Þegar dálkur er skilgreindur með `NOT NULL`, þá tryggir það að dálkurinn hafi alltaf gildi. Dæmi:

```sql
CREATE TABLE kennarar
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kennitala CHAR(10) UNIQUE NOT NULL,
    nafn CHAR(50) NOT NULL
);
```
Hér verður að bæta við kennitölu og nafni fyrir hvern kennara, annars er ekki hægt að setja 
línuna inn.

# Að bæta við skorðum eftir að töflur hafa verið búnar til

Ef skorður eru ekki skilgreindar strax þegar töflur eru búnar til, þá er hægt að bæta þeim við 
eftir á í _PostgreSQL_ með því að nota `ALTER TABLE` skipunina. Dæmi:

```sql
ALTER TABLE kennarar
ADD CONSTRAINT unique_kennitala UNIQUE (kennitala);
```
Hér er bætt við einstakri skorðu á `kennitala` dálkinn í töflunni `kennarar`. Athugið að nafnið 
`kennarar_kennitala_unique` er valið af notandanum og getur verið hvað sem er. Þegar skorða er
búin til með `CREATE TABLE` þá er nafnið á skorðunni sjálfgefið.

> **Athugið**: Í _SQLite_ er ekki hægt að bæta við skorðum eins og UNIQUE eftir að taflan hefur 
> verið búin til. Heldur þarf að framkvæma eftirfarandi aðgerðir:
> 1. Búa til nýja töflu með `UNIQUE` skorðu.
> 2. Flytja gögnin úr gömlu töflunni yfir í þá nýju.
> 3. Eyða gömlu töflunni.
> 4. Endurnefna nýju töfluna í gamla nafnið.

# Eyða skorðum úr töflu
Til að eyða skorðum úr töflu er hægt að nota `ALTER TABLE` skipunina með `DROP CONSTRAINT`. Dæmi:

```sql
ALTER TABLE kennarar
DROP CONSTRAINT kennarar_kennitala_unique;
```

> **Athugið**: Í _SQLite_ er ekki hægt að eyða skorðum úr töflu með `ALTER TABLE`. Þá þarf að
> búa til nýja töflu án skorða, flytja gögnin yfir og eyða gömlu töflunni og endurnefna nýju 
> töfluna í gamla nafnið.

# Skoða skorður í töflu
Til að skoða skorður í _SQLite_  töflu er hægt að nota `PRAGMA` skipunina með `table_info`. Dæmi:

```sql
PRAGMA table_info(kennarar);
```

Í _PostgreSQL_ er hægt að skoða skorður með `pg_constraint` töflunni. Dæmi:

```sql
SELECT 
    conname AS constraint_name, 
    contype AS constraint_type, 
    a.attname AS column_name
FROM 
    pg_constraint AS c 
JOIN 
    pg_attribute AS a ON a.attnum = ANY(c.conkey) 
WHERE 
    c.conrelid = 'kennarar'::regclass;
```
sem skilar öllum skorðum í töflunni `kennarar`.

En yfirleitt er nóg að skoða töfluna sjálfa til að sjá skorður sem eru skilgreindir, t.d. með 
`\d kennarar` (hér er gert ráð fyrir að þið séuð í `psql`). 