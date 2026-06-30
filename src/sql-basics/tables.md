---
description: >-
  Töflur eru grundvallareiningar í gagnagrunnum, þar sem gögnin eru geymd í röðum. 
  Hægt er að búa til töflur, breyta þeim, og (endur)skilgreina gerðir dálka. 
---


Töflur eru grundvallareiningar í gagnagrunnum, þar sem gögnin eru geymd í röðum og dálkum. Hver
tafla inniheldur ákveðna gerð gagna og er skipulögð þannig að hver röð (e. _row_) samsvarar einu
staki, og hver dálkur (e. _column_) samsvarar tilteknum eiginleikum gagna. Dálkar skilgreina hvaða
tegund gagna er geymd, til dæmis heiltölur, texti eða tvíundargögn.

# Búa til töflu

Til að búa til töflu notum við `CREATE TABLE` skipunina. Hér er dæmi um hvernig á að búa til töflu
sem heitir `operators`:

```sql
CREATE TABLE operators
(
    opID       INTEGER,
    opName     CHAR(30),
    opSSN      CHAR(10),
    opAge      INTEGER,
    opYearInit INTEGER
); 
```

Í þessu dæmi er taflan `operators` búin til með fimm dálkum:

* `opID`: Heiltala (`INTEGER`) sem gæti verið notuð sem auðkenni.
* `opName`: Stafastrengur (`CHAR(30)`) sem geymir nafn.
* `opSSN`: Stafastrengur (`CHAR(10)`) sem geymir kennitölu.
* `opAge`: Heiltala (`INTEGER`) fyrir aldur.
* `opYearInit`: Heiltala (`INTEGER`) fyrir ártal upphafs.

# Gerðir dálka

Í _SQLite_ eru til ýmsar tegundir dálka sem skilgreina hvernig gögn eru geymd í gagnagrunninum. Hér
eru nokkrar algengar gerðir:

* `INTEGER`: Heiltölur.
* `REAL`: Fleytitölur.
* `TEXT`: Stafir og strengir.
* `BLOB`: Tvíundargögn (Binary Large Object).

Frekari upplýsingar um dálkagerðir í _SQLite_ má finna
á: [https://www.sqlite.org/datatype3.html](https://www.sqlite.org/datatype3.html).

# Að breyta töflum

_SQLite_ styður nokkrar breytingar á töflum með `ALTER TABLE` skipuninni.

## Bæta við dálki

Þú getur bætt við nýjum dálki með `ALTER TABLE ... ADD COLUMN`:

```sql
ALTER TABLE operators
    ADD COLUMN opAddress TEXT; 
```

## Eyða dálki

Þú getur eytt dálki með `ALTER TABLE ... DROP COLUMN`:

```sql
ALTER TABLE operators DROP COLUMN opAddress; 
```

## Endurnefna dálk

Þú getur endurnefnt dálk með því að nota `ALTER TABLE ... RENAME COLUMN`:

```sql
ALTER TABLE operators RENAME COLUMN opName TO operatorName; 
```

## Breyting á dálkagerð

Það er ekki hægt að breyta gerð dálks beint með `ALTER TABLE` í _SQLite_. Til að breyta gerð dálks
þarf að fylgja eftirfarandi ferli:

* Búa nýjan dálk með réttu dálkagerðinni.
* Afrita gögnin úr gamla dálkinn yfir í nýja dálkinn með `UPDATE`.
* Eyða gamla dálkinn.
* Endurnefna nýju dálkinn með gamla nafninu.

Aftur á móti, í _PostgreSQL_ er hægt að breyta gerð dálks í einni skipun með:

```sql 
ALTER TABLE...ALTER COLUMN...TYPE...;
```

# Eyða töflu

Til að eyða töflu notum við `DROP TABLE` skipunina:

```sql
DROP TABLE operators; 
```

Þessi skipun eyðir töflunni `operators` úr gagnagrunninum. Athugaðu að þessi aðgerð er
**óafturkræf**. Ef það eru einhverjir lyklar í töflunni sem tengjast öðrum töflum, þá getur
komið villa ef reynt er að eyða töflunni. Þá þarf að fjarlægja tengingar við aðrar töflur fyrst, eða
eyða
tengdum töflum í leiðinni með viðbótinni `CASCADE`. Ekki er mælt með þeirri aðferð nema þú vitið
nákvæmlega hvað þú ert að gera.

> **Athugið:**
> - Þessi skipun eyðir töflunni `operators` úr gagnagrunninum.
> - Aðgerðin er **óafturkræf**.
> - Ef það eru einhverjir lyklar í töflunni sem tengjast öðrum töflum, getur komið villa ef reynt er
    að eyða töflunni.
> - Það þarf að fjarlægja tengingar við aðrar töflur fyrst, eða eyða tengdum töflum í leiðinni með
    viðbótinni `CASCADE`.
> - Ekki er mælt með þeirri aðferð nema þú vitir nákvæmlega hvað þú ert að gera.
