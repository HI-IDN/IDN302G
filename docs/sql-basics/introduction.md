---
description: >-
  SQL er forritunarmál hannað til að „tala við“ venslagagnasöfn. Það 
  er mikilvægt tæki í gagnastjórnun sem gerir notendum kleift að framkvæma fyrirspurnir, búa til,
  breyta og eyða gögnum.
---

# Um SQL 

Markmið námskeiðsins er að kynnast fyrirspurnarmálinu SQL:

- búa til fyrirspurnir,
- skilja fyrirspurnir sem þið sjáið,
- geta notað SQL til að framkvæma gagnagreiningu.

SQL (Structured Query Language), borið fram eins og „sequel“ eða „ess-cue-ell“, er staðlað
fyrirspurnarmál sem er notað til að hafa samskipti við venslagagnasöfn.

## Ólík SQL fyrirspurnarmál

Samkvæmt [DB-Engines Ranking](https://db-engines.com/en/ranking) eru vinsælustu gagnagrunnskerfin:

1. Oracle
2. MySQL
3. Microsoft SQL Server
4. PostgreSQL
5. MongoDB
6. Redis
7. Snowflake
8. Elasticsearch
9. IBM Db2
10. SQLite

Við munum kynnast _SQLite_ og _PostgreSQL_ í þessu námskeiði.

## Líkindi milli SQL fyrirspurnarmála

Flest SQL fyrirspurnarmál fylgja svipuðum grunnatriðum og setningafræði. Þau leyfa notendum að
framkvæma fyrirspurnir á gagnagrunnum á einfaldan hátt. Þrátt fyrir að smávægilegur munur geti verið
til staðar milli mismunandi gagnagrunnskerfa, eins og _PostgreSQL_ og _SQLite_, eru grunnskipanirnar
oft mjög keimlíkar og auðvelt að aðlaga sig á milli kerfa. Fyrir frekari upplýsingar um
hvernig `SELECT` skipanir eru búnar til, sem verða útskýrð betur í
[grunnatriði í SQL](basic_sql_queries.md).

Hér eru dæmi um grunnskipanir í SQL fyrir mismunandi gagnagrunnskerfi:

### PostgreSQL

```sql
-- Select all rows from a table
SELECT *
FROM tbl;

-- Select specific columns and sort by a column
SELECT col1, col2
FROM tbl
ORDER BY col1 DESC;

-- Select the first 10 rows
SELECT *
FROM tbl LIMIT 10;
```

### MySQL

```sql
-- Select all rows from a table
SELECT *
FROM tbl;

-- Select specific columns and sort by a column
SELECT col1, col2
FROM tbl
ORDER BY col1 DESC;

-- Select the first 10 rows
SELECT *
FROM tbl LIMIT 10;
```

### SQLite

```sql
-- Select all rows from a table
SELECT *
FROM tbl;

-- Select specific columns and sort by a column
SELECT col1, col2
FROM tbl
ORDER BY col1 DESC;

-- Select the first 10 rows
SELECT *
FROM tbl LIMIT 10;
```

### Microsoft SQL Server

```sql
-- Select all rows from a table
SELECT *
FROM tbl;

-- Select specific columns and sort by a column
SELECT col1, col2
FROM tbl
ORDER BY col1 DESC;

-- Select the first 10 rows
SELECT TOP 10 *
FROM tbl;
```

# Gagnasafnskerfi

Gagnastjórnun er aðferð til að safna, geyma og nota gögn á öruggan, árangursríkan og kostnaðarlega
hagkvæman hátt. Markmiðið er að auðvelda notkun gagna þannig að hægt sé að nota þau til
ákvarðanatöku og skapa virði fyrir fyrirtæki.

## Helsta vinna gagnastjórnunar

- Búa til, stýra aðgengi og uppfæra gögn á fjölbreyttu gagnasviði.
- Hýsing gagna, til dæmis í skýi (e. _data cloud_) eða á staðnum.
- Gott aðgengi til notanda (t.d. margir notendur, rafmagnsleysi og fleira).
- Tryggja persónuvernd gagna (t.d. GDPR lögin) og fylgja reglugerðum þar sem við á.
- Eyðing gagna: Hvenær má eyða gögnum og hverju?
- Notkun gagna í fjölbreyttum öppum, greiningartólum og reikniritum.

## Tegundir gagnasafnskerfa

Gagnasafnskerfi samanstanda af margs konar tækni og tólum sem geta verið notuð til gagnastjórnunar.
Algengasta gerð gagnasafnskerfa eru venslagagnasöfn (e. _relational database management
systems_), þar sem gögn eru geymd á skipulögðu formi, skipt niður í töflur með röðum og dálkum sem
innihalda stök (e. _database records_). Skyld stök í öðrum töflum eru tengd saman með lyklum
(primary og foreign keys) til að koma í veg fyrir tvítekningar. Þetta fyrirkomulag byggir á
forritunarmálinu SQL og gagnalíkani/skemum.

### Aðrir möguleikar

- **Gagnasafnskerfi fyrir gríðargögn (e. _big data_):** t.d. NoSQL gagnagrunnar sem byggja ekki
  á SQL og leyfa óskipulögð eða hálf skipulögð gögn, eins og skynjaragögn (e. sensor data).
- **Vöruhúsgagna (e. _data warehouses_):** byggð á vensla- og/eða dálka-gagnasöfnum, tekin
  saman úr mismunandi kerfum, sett saman og undirbúin fyrir greiningar.
- **Gagnalindir (e. _data lakes_):** geyma gríðargögn til notkunar í spálíkanagerð, gervigreind,
  og fleira.


# Venslagagnasöfn

Venslagagnasöfn (e. _relational databases_) eru oft notuð til að skipuleggja og geyma gögn á 
skilvirkan hátt. Þau byggja á mengjum og venslum, eins og tvístæðum venslum.

## Kostir

- Gögn eru geymd á skipulögðu formi.
- Geyma gögn á öruggan hátt.
- Hraðvirk leit að gögnum.

## Gallar

- Flókin og dýr í uppsetningu.
- Henta ekki fyrir lítið gagnamagn.
- Gögn geymd á skipulögðu formi.

## Mengi og vensl

Mengi eru oft notuð til þess að halda utan um hópa hluti sem hafa svipaða eiginleika, eins og allir
nemendur í upplýsingaverkfræði eða allir nemendur Háskóla Íslands. Mengi eru óraðað safn af hlutum,
og hlutir í mengi eru kallaðir stök. Vensl segja okkur til um samband staka milli mengja, eins og
mengi starfsmanna og mengi launa eða einstaklingar og ættingjar.

Tvístæð vensl frá $$A$$ til $$B$$ er mengið $$R$$ af röðuðum pörum þar sem fyrsta stakið af hverju röðuðu
pari kemur frá $$A$$ og það síðara frá $$B$$. Þegar $$(a,b)$$ tilheyrir $$R$$ þá er $$a$$ sagt vera með vensl
í $$b$$ með $$R$$ (skrifað $$aRb$$).

Dæmi um tvístæð vensl $$R$$ frá mengi $$A$$ til $$B$$: $$A = \{0,1,2\}$$, $$B = \{a, b\} $$. Tvístæð
vensl væru þá t.d. $$R: \{(0, a), (0, b), (1, a), (2, b)\}$$. Athugið, við þurfum ekki að hafa öll pör
af tengingum milli mengja.

Töflur eru oft notaðar til að sýna vensl. Dálkur er mengið sjálft, og hver lína í dálki er stak.
Tvístæð vensl hafa tvo dálka.

Þá væri til dæmis tvístæðu venslin: $$\{$$(Helga, Upplýsingaverkfræði), (Rögnvaldur, Tæknileg
kerfi), (Tómas, Aðgerðagreining)$$\}$$ hægt að setja fram sem:

| Kennari    | Námskeið            |
|------------|---------------------|
| Helga      | Upplýsingaverkfræði |
| Rögnvaldur | Tæknileg kerfi      |
| Tómas      | Aðgerðagreining     |

## Kostir venslalíkansins

- Einfalt og gagnsætt líkan.
- Allt er sett fram sem töflur.
- Traustar stærðfræðilegar undirstöður, eins og venslareikningur og mengi.
- Passar oftast vel við raunveruleg gögn.
- Hraðvirkar útfærslur.
