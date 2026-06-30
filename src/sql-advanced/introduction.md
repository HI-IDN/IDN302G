---
description: >-
  Við kynnum flóknari SQL aðgerðir, þar á meðal tengingar (joins) og flóknari fyrirspurnir 
  svokallaðar CTE (Common Table Expression).
---

# Inngangur

Hingað til höfum við aðeins skoðað SQL fyrirspurnir sem vinna á einni töflu í einu, mögulega með
einföldum undirfyrirspurnum. En hugmyndin með gagnagrunnum er að þeir eru að reyna að vera eins
„nettir“ og hægt er, og forðast endurtekningar. Þannig er einfaldara að uppfæra gögn ef það eru fáir
staðir sem hægt er að nálgast sömu upplýsingar. Þetta tryggir heilleika gagna. Oft er talað um að
reyna að koma gagnagrunni á þriðja Boyce-Codd normal form (en það er utan efniviðar þessa
námskeiðs).

# PostgreSQL tenging

Við notum dæmi um Postgres gagnagrunni úr Game of Thrones heiminum í sýnidæmum. Gagnagrunnurinn er
hýstur á Railway og er aðgengilegur með eftirfarandi tengingarupplýsingum:

- **Host:** `junction.proxy.rlwy.net`
- **Port:** `55303`
- **Database:** `railway`
- **Username:** teymisnafn
- **Password:** uppgefið í Canvas

> Tengiupplýsingar með notendanafni og lykilorð má finna á Canvas.

Notið IDE til að tengjast PostgreSQL gagnagrunninum með þessum tengingarupplýsingum. Þið getið
notað _VSCode_ með viðbótinni _PostgreSQL_. Betra er að nota IDE sem sérhæfa sig fyrir SQL en þar er
_DataGrip_ í farabroddi (með frítt stúdentaleyfa) en _DBeaver_ er líka góður kostur og er frjáls og
opinn hugbúnaðar.

Til að sjá hvaða töflur standa ykkur til boða getið þið keyrt eftirfarandi SQL fyrirspurn:

```sql
SELECT *
FROM pg_tables
WHERE schemaname IN ('atlas', 'got')
ORDER BY schemaname, tablename;
```

# Gögn

Gögnin fyrir þennan kafla koma héðan:

1. [**Ice and Fire API**](https://anapioficeandfire.com/) - Gögn frá skáldsöguheiminum *Game of
   Thrones* (schema: `got`) sem hægt er að nálgast með API köllum á vefþjónustu eftir Joakim Skoog.
2. **Game of Maps** - Gögn um kortlagningu og staðsetningar í heimi GoT (schema: `atlas`) eftir
   Patrick Triest.

# Almennt form `SELECT` skipunar

```sql
SELECT <dálkar eða útreikningur>
FROM <tafla>
WHERE <skilyrði>
GROUP BY <dálkar>
HAVING <skilyrði>
ORDER BY <dálkar>
    LIMIT <tala>
OFFSET <tala>;
```

Útskýringar:

- `SELECT`: Skilgreinir hvaða dálkar eða útreikningar verða valdir úr töflum.
- `FROM`: Hér getur verið ein eða fleiri töflur. Ef fleiri en ein tafla er notuð, er það oftast
  gert með tengingu (`JOIN`). Nánar verður farið í hvernig við tengjum saman töflur í
  [hér](sql-advanced/joins.md).
- `WHERE`: Skilyrði sem takmarkar niðurstöður. Það er einnig hægt að nota undirfyrirspurnir
  í `WHERE` hlutnum (sjá [hér](sql-basics/subquery.md)). 

