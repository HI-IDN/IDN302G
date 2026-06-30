---
description: >-
  Helstu munir við að fara úr SQLite yfir í PostgreSQL með áherslu á noktun ólíkra skema,
  flóknari gagnatýpur, regex, og fleiri möguleika.
---

# Helstu munir á _PostgreSQL_ og _SQLite_

Þó _SQLite_ sé einfaldur og hagnýtur gagnagrunnur fyrir minni verkefni, býður _PostgreSQL_ upp á
marga möguleika sem henta flóknari verkefnum með þörf á sérhæfðari gagnatýpum, fyrirspurnum, og
gagnavinnslu.

Hér verða tekin nokkur gagnleg dæmi til að sýna helstu munina á _PostgreSQL_ og _SQLite_, en
listinn er ekki tæmandi.

## Skema - `SCHEMA`

Í _PostgreSQL_ er hægt að skilgreina skemu (_schema_) sem henta til að hópa saman tengdar töflur og 
önnur gagnagrunnseiningar. Þetta gerir gagnagrunnskerfið meira skipulagt og hægt er að skilja
betur hvernig gögnin tengjast saman.

Í _SQLite_ eru allar töflur í sama skema, en í _PostgreSQL_ er hægt að skilgreina mörg skemur og
hafa mismunandi réttindi á milli þeirra. Sjálfgefna skemað er `public`, en hægt er að breyta því 
með að keyra `set search_path = got;`. Þá get ég keyrt t.d. `SELECT * FROM books;` sem þýðir í 
raun `SELECT * FROM got.books;` á bak við tjöldin. En áður en ég setti `search_path` þá þyrfti 
ég tilgreina skemað sérstaklega. Annars fengi ég villu, því það er ekki til tafla í `public` 
skemanu sem heitir `books`.


### Búa til skema:

```sql
CREATE SCHEMA got;
```

### Búa til töflu í skema:

```sql
CREATE TABLE got.books
(
    id              serial primary key,
    name            text,
    isbn            text,
    authors         text[],
    number_of_pages integer,
    publisher       text,
    country         text,
    media_type      text,
    released        date
);
```

Ef ekkert skema er gefið upp, þá er sjálfgefna skemað `public` notað, nema það hafi verið breytt 
með `set search_path` áður.



## Fylki og fylkjaðgerðir - `ARRAY`

Í _PostgreSQL_ er hægt að vinna með fylki og nota samantektaraðgerðir eins og `ARRAY_AGG` til að
safna saman gögnum í eitt fylki. Þetta býður upp á mun meiri sveigjanleika í að vinna með tengdar
upplýsingar og hópa saman gögn.

Til að skilgreina fylkjadálkagerð í _PostgreSQL_ er hægt að nota `[]` eða `ARRAY[]` fyrir 
gagnatýpuna, einsog við sjáum hér að neðan fyrir `authors` dálkinn.

Sjá skjölun á [PostgreSQL](https://www.postgresql.org/docs/17/arrays.html) fyrir frekari 
upplýsingar um fylki.

```sql
SELECT region,
       ARRAY(
           SELECT name 
           FROM got.houses AS h 
           WHERE h.region = houses.region 
           ORDER BY name 
           LIMIT 5
       ) AS houses
FROM got.houses AS houses
GROUP BY region
ORDER BY region;
```

Fyrirspurnin skilar lista af svæðum með fylki af nöfnum fyrstu 5 húsanna á hverju svæði, raðað í
stafrófsröð.

- `SELECT region`: Velur svæði úr `got.houses`.
- `ARRAY(... AS houses)`: Innri fyrirspurn safnar fylki af húsanöfnum sem tilheyra hverju svæði,
  raðað í stafrófsröð með takmörkun á 5 nöfnum.
    - `WHERE h.region = houses.region`: Velur hús sem tilheyra sama svæði.
    - `ORDER BY name`: Raðar húsum í stafrófsröð.
    - `LIMIT 5`: Takmarkar niðurstöður við fyrstu 5 húsin.
- `GROUP BY region`: Hópar niðurstöður eftir svæði.
- `ORDER BY region`: Raðar niðurstöðum eftir svæðisnafni.

| Region          | Houses                                                                                                                                            |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| Beyond the Wall | {House Redbeard}                                                                                                                                  |
| Dorne           | {House Allyrion of Godsgrace, House Blackmont of Blackmont, House Briar, House Brook, House Brownhill}                                            |
| Iron Islands    | {House Blacktyde of Blacktyde, House Botley of Lordsport, House Codd, House Drumm of Old Wyk, House Farwynd of Sealskin Point}                    |
| The Crownlands  | {House Baratheon of Dragonstone, House Baratheon of King's Landing, House Bar Emmon of Sharp Point, House Blount, House Boggs of Crackclaw Point} |
| The Neck        | {House Blackmyre, House Cray, House Fenn, House Greengood, House Peat}                                                                            |
| The North       | {House Amber, House Ashwood, House Boggs, House Bole, House Bolton of the Dreadfort}                                                              |
| The Reach       | {House Ambrose, House Appleton of Appleton, House Ashford of Ashford, House Ball, House Beesbury of Honeyholt}                                    |
| The Riverlands  | {House Baelish of Harrenhal, House Bigglestone, House Blackwood of Raventree Hall, House Blanetree, House Bracken of Stone Hedge}                 |
| The Stormlands  | {House Baratheon of Storm's End, House Bolling, House Buckler of Bronzegate, House Cafferen of Fawnton, House Caron of Nightsong}                 |
| The Vale        | {House Arryn of Gulltown, House Arryn of the Eyrie, House Baelish of the Fingers, House Belmore of Strongsong, House Borrell of Sweetsister}      |
| The Westerlands | {House Algood, House Banefort of Banefort, House Bettley, House Brax of Hornvale, House Broom}                                                    |

## Vinna með bil - `RANGE`

_PostgreSQL_ býður upp á `RANGE` gagnatýpur sem gera okkur kleift að vinna með bil (t.d. aldur,
tímabil). Þetta gefur möguleika á að finna skörun milli bita af gögnum, eins og t.d. hvaða
karakterar voru uppi á sama tíma.

Hér eru nokkur algeng notkunardæmi:
- `daterange` gagnatýpan er notuð til að skilgreina dagsetningabil.
- `tsrange` gagnatýpan er notuð til að skilgreina tímabil.
- `int4range` gagnatýpan er notuð til að skilgreina heiltölubil.
- `numrange` gagnatýpan er notuð til að skilgreina bili fyrir tölur.

Á þeim getum við notað sérstaka virkja til að athuga hvort bili skeri eða innihaldi annan.
- `@>`: Athugar hvort fyrri bilið innihaldi seinna bilið.
- `<@`: Athugar hvort fyrri bilið sé innan seinna bilsins.
- `&&`: Athugar hvort bilið skeri annað bili (*overlap*).
- `=`: Athugar hvort bilið sé nákvæmlega eins og annað bili.
- `<>`: Athugar hvort bilið sé ekki eins og annað bili.
- `<<`: Athugar hvort fyrri bilið sé til vinstri um seinna bilið.
- `>>`: Athugar hvort fyrri bilið sé til hægri um seinna bilið.

Sjá [skjölun á PostgreSQL](https://www.postgresql.org/docs/current/rangetypes.html) fyrir
frekari notkun á `RANGE` gagnatýpum.

``` sql 
SELECT name book_after_2012, released
FROM got.books
WHERE daterange('2012-01-01', NULL, '[]') @> released
ORDER BY released DESC;
```

Þessi fyrirspurn velur nöfn allra bóka úr gagnagrunninum þar sem útgáfudagsetningin fellur eftir 2012.

- Fyrirspurnin býr til dagsetningabil sem byrjar 1. janúar 2012 og hefur engan lokaendan, sem þýðir
  að hún tekur til allra dagsetninga eftir þennan tíma.
- Hún athugar hvort útgáfudagsetningin bókarinnar falli innan þessa bils.
- Að lokum raðast niðurstöðurnar í lækkandi röð eftir útgáfudagsetningu, þannig að nýjustu bækurnar
  koma fyrst.

| book_after_2012                | released   |
|--------------------------------|------------|
| A Knight of the Seven Kingdoms | 2015-10-06 |
| The World of Ice and Fire      | 2014-10-28 |
| The Rogue Prince               | 2014-06-17 |
| The Princess and the Queen     | 2013-12-03 |

## Flóknari regex fyrirspurnir

Í _SQLite_ höfum við takmarkaða regex virkni með `LIKE`, en _PostgreSQL_ býður upp á fullkomna
regex-aðgerðir með `regexp_match` og `regexp_matches`, sem gerir okkur kleift að nota flóknari
og öflugri reglulegar segðir.

```sql
SELECT name,
       born,
       (SELECT ARRAY_AGG(match[1]::int)
        FROM regexp_matches(born, '(\d+)\sAC\y', 'g') AS match) AS matches
FROM got.characters
WHERE name IN ('Bronn', 'Jon Snow', 'Melisandre', 'Otto Hightower')
ORDER BY matches DESC NULLS LAST, name;
```

Fyrirspurnin finnur fæðingarár sem enda með _AC_ (stendur fyrir _After Conquest_) fyrir tiltekna
karaktera og safnar þeim saman í fylki fyrir hvern karakter. Niðurstöðurnar eru síðan raðaðar
þannig að karakterar með samsvörun koma fyrst, og karakterar með engar samsvörunir (`NULL`) koma
síðast, síðan raðað eftir nafni.

- `regexp_matches(born, '(\d+)\sAC\y', 'g')`: Hér er verið að nota reglulega segðina til að
  finna tölur sem eru fyrir framan strenginn "AC" og það er notað `\y` til að tákna
  orðamörk (word boundary) í _PostgreSQL_. 
  > Athugið að í _PostgreSQL_ er `\y` notað fyrir orðamörk en
  ekki `\b`, sem er algengara í öðrum regex tólum.

- `ARRAY_AGG(match[1]::int)`: Safnar öllum samsvörunum (tölustöfunum fyrir "AC") í fylki, en
  fyrst er gildinu breytt í heiltölu með `::int`.

- `ORDER BY matches DESC NULLS LAST, name`: Fyrirspurnin raðar niðurstöðunum þannig að þeir sem
  hafa samsvörun við "XXX AC" koma fyrst (í lækkandi röð) og aðrir (með `NULL`) koma síðast.

| name           | born                            | matches    |
|----------------|---------------------------------|------------|
| Jon Snow       | In 283 AC                       | {283}      |
| Bronn          | In or between 264 AC and 268 AC | {264, 268} |
| Melisandre     | At Unknown                      |            |
| Otto Hightower |                                 |            |

Sjá [skjölun á PostgreSQL](https://www.postgresql.org/docs/current/functions-matching.html)
fyrir frekari notkun á regex-aðgerðum.

## Sérsniðnar gagnatýpur - `ENUM`

_PostgreSQL_ býður upp á möguleikann að skilgreina sérsniðnar gagnatýpur með `ENUM`, sem hentar
vel til að takmarka gildin í dálkum. Til dæmis er hægt að búa til sérsniðna tegund fyrir
staðsetningarflokka (_location types_) í _Game of Thrones_ gagnagrunni.

Sjá [skjölun á PostgreSQL](https://www.postgresql.org/docs/current/datatype-enum.html) fyrir
frekari notkun á sérsniðnum gagnatýpum.

### Búa til sérsniðna gagnatýpu:

```sql
CREATE TYPE location_type AS ENUM ('Castle','City','Landmark','Region','Ruin','Town');
```

### Nota sérsniðna gagnatýpu í töflu:

```sql
CREATE TABLE atlas.locations
(
    id   SERIAL PRIMARY KEY,
    name TEXT,
    type location_type
);
```

Kosturinn hér er að gagnagrunnskerfið getur núna passað upp á að eingöngu sé hægt að setja inn
lögleg gildi í dálkinn `type`. Til dæmis mætti ekki setja inn gildið _Village_ eða _castle_ í
dálkinn `type`.

### Finna öll skilgreind gildi í sérsniðinni gagnatýpu:

```sql
SELECT enum_range(NULL::location_type)
```

Þetta getur verið gagnlegt ef við gleymum hvaða gildi eru lögleg í sérsniðinni gagnatýpu. Þessi
fyrirspurn gefur okkur lista yfir öll gildi í sérsniðinni gagnatýpu.

| enum_range                              |
|-----------------------------------------|
| {Castle,City,Landmark,Region,Ruin,Town} |

Þetta stemmir við  skilgreininguna hér að ofan. Ef við viljum fá hvert gildi í
sérniðinnni gagnatýpu fyrir sig, þá getum við notað `unnest` fallið á undan.

## Aðrar breytingar

- **Meira gagnsæi í gagnatýpum**: _PostgreSQL_ býður upp á mun skýrari gagnatýpur, eins og `jsonb`,
  `tsvector`, og `inet`, sem gerir gagnagrunnsgerðina mun fjölbreyttari og öflugri en _SQLite_. Sjá

- **Fyrirspurnahagræðing**: _PostgreSQL_ býður upp á öflugri fyrirspurnahagræðingarvélar, sem geta
  aukið afköst fyrir stór gagnasöfn.

