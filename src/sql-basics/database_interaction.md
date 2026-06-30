---
description: >-
  Hægt er að eiga samskipti við gagnagrunnana með mismunandi tólum og tungumálum, allt frá 
  skipanatólum, þróunarumhverfum eða önnur forritunarmál.
---

Í þessu námskeiði munum við styðjast við _SQLite_ í skel til að búa til gagnagrunn og framkvæma SQL
skipanir. Í hluta námskeiðsins sem snýr að _PostgreSQL_ munum við fá gefinn aðgang að gagnagrunn sem
hýstur er annars staðar. Þið munuð nota IDE til að tengjast þessum grunninum og framkvæma
fyrirspurnir. Vinsamlegast athugið að þið hafið aðeins lesréttindi (e. _read access_) á _PostgreSQL_
grunninum, en í _SQLite_ eruð þið með staðbundinn gagnagrunnur þar sem þið getið skrifað og
lesið að vild.

# SQLite

_SQLite_ er létt gagnagrunnskerfi sem hentar vel fyrir minni verkefni þar sem einfaldleiki og hraði
eru mikilvægir þættir. _SQLite_ er frjálst, auðvelt í uppsetningu og þarf ekki sérstaka
gagnasafnsþjóna. Það er víða notað, meðal annars í vöfrum, símum og ýmsum forritum (sjá þekkt
dæmi [hér](https://www.sqlite.org/famous.html)).

_SQLite_ var búið til af Richard Hipp í kringum 2000 þegar hann vann hjá General Dynamics í
samstarfi við Bandaríkjaher. Hönnunarmarkmið var að þróa kerfi sem getur verið notað án þess að
þurfa gagnasafnskerfi
([sjá hér](https://thenewstack.io/the-origin-story-of-sqlite-the-worlds-most-widely-used-database-software/)).

## Uppsetning

### Windows

Til að setja upp _SQLite_ á Windows:

1. Farðu á [www.sqlite.com](https://www.sqlite.com).
2. Sæktu og unzipaðu nýjustu útgáfu.
3. Settu möppuna á rót disks (t.d. `C:\SQLite`).
4. Bættu við slóðinni í _Environment Variables_ undir _system path_ (`PATH` breytan).

### Linux og macOS

_SQLite_ er oftast sjálfgefið uppsett á macOS og flestum Linux dreifingum, undir `sqlite3`.

### Aðrar uppsetningaleiðir

- **DB-Browser:** Ágætis tól til að halda utan um lítil venslagagnasöfn og byggir á
  _SQLite_: [https://sqlitebrowser.org/](https://sqlitebrowser.org/)
- **SQLiteOnline.com:** Hægt að æfa sig online hér og m.a. loada `.db` skrám. En notið þetta
  einungis sem síðasta úrræði ef uppsetning gengur
  ekki: [https://sqliteonline.com/](https://sqliteonline.com/)
- **SQLite í R:** Hægt að nota R til að halda utan um gagnagrunninn og framkvæma fyrirspurnir. Hér
  náið þið að slá tvær flugur í einu höggi með að gera skýrslugerð og gagnavinnslu í sama skjali.

## Notkun á skipanaskel

_SQLite_ er notað í gegnum skipanaskel sem gerir notendum kleift að framkvæma SQL fyrirspurnir
beint á gagnagrunnum.

Sækið skránna [surgeries.db](../../data/surgeries.db) og keyrið í skel (e. _terminal_) úr sömu
möppu og skráin er. Notið `cd` (stendur fyrir _change directory_) til að breyta um möppu.

Keyrið skipunina `sqlite3` í skelinni. Opnið gagnasafnið með skipuninni `.open surgeries.db`. Prófið
nokkrar skipanir sem finnast með `.help`.

```bash 
-- Open the database
.open surgeries.db

-- List all tables
.tables

-- Show the structure of a table
.schema table_name

-- Display results in column mode
.mode columns

-- Enable headers in results
.headers on
```

_SQLite_ er hannað til að vera einfalt og hratt, sem gerir það að góðu vali fyrir notendur sem þurfa
ekki flóknari eiginleika stærri gagnagrunnskerfa eins og _PostgreSQL_ eða _MySQL_.

# PostgreSQL

_PostgreSQL_ er mjög öflugt og opið gagnagrunnskerfi sem hentar vel fyrir bæði smá og stór verkefni
þar sem gagnasöfnun, samhliða vinnsla, og flókin fyrirspurnarefni eru mikilvæg. Það er byggt á
SQL staðlinum og styður einnig fjölbreyttar útvíkkanir. _PostgreSQL_ er þekkt fyrir sveigjanleika
sinn, öryggi, og mikla virkni, sem gerir það að vinsælu vali í mörgum forritum og þjónustum.

Uppruni PostgreSQL má rekja til áranna 1986 á Berkeley háskólanum, og það hefur þróast í gegnum
árin í samræmi við þarfir notenda, með áherslu á stuðning við flókin gögn og stærðfræðilega
útreikninga.

`psql` er skipunartól fyrir _PostgreSQL_ sem gerir notendum kleift að framkvæma SQL fyrirspurnir og
stjórna gagnagrunnum í skel. Þetta tól býður upp á öfluga aðgerðir og skýrslur.

Þar sem _PostgreSQL_ er hannað fyrir stærri verkefni og flóknari gagnasöfn, er það oftast notað
í þróunarumhverfum (IDE) til að tengjast gagnagrunnum og framkvæma fyrirspurnir.

### Uppsetning

- [PostgreSQL niðurhal](https://www.postgresql.org/download/): Veldu réttan stýrikerfi og fylgdu
  leiðbeiningunum fyrir að setja upp _PostgreSQL_ og _psql_.

# IDE fyrir gagnagrunnskerfi

Til að auðvelda vinnu með gagnagrunan er gott að nota þróunarumhverfi (IDE) sem býður upp á
sérstakar aðgerðir fyrir gagnagrunna. Hér eru þrjú tól sem mælt er með:

### 1. [DataGrip](https://www.jetbrains.com/datagrip/)

**Kostir:**

- DataGrip er öflugt IDE frá _JetBrains_ sem styður marga gagnagrunnsþjónustu, þar á meðal
  _PostgreSQL_.
- Hægt er að tengja _GitHub CoPilot_ við DataGrip til að fá tillögur að SQL fyrirspurnum.
- Nemandar geta sótt um frítt leyfi sem gildir í eitt ár í senn, á meðan þeir eru í námi.
- Sækið [DataGrip](https://www.jetbrains.com/datagrip/download/) og fylgið leiðbeiningum fyrir
  uppsetningu.
- Opnið nýja tengingu og veljið *PostgreSQL* sem gagnagrunnskerfi. Fyllið inn tengingarupplýsingar
  sem þið fenguð: host, port, database, user, password. Gott er að prófa tenginguna til að vera
  viss um að hún virki.
  - Í fyrsta skipti þarf að bæta við PostgreSQL driver, IDE mun spyrja um það og gefa leiðbeiningar.

{% embed url="https://www.youtube.com/watch?v=X_RznmyuNyA" %}

### 2. [DBeaver](https://dbeaver.io/)

**Kostir:**

- DBeaver er opinn hugbúnaður (e. _open source_) sem styður mörg gagnagrunnskerfi, þar á meðal
  _PostgreSQL_.
- Það býður upp á einfalt og aðgengilegt viðmót.
- DBeaver er frítt og auðvelt í notkun, sem gerir það að frábærum valkost fyrir nemendur og
  minni fyrirtæki.
- Sækið [DBeaver Community Edition](https://dbeaver.io/download/) til að byrja. Fylgið leiðbeiningum
  fyrir uppsetningu.
- Opnið nýja tengingu og veljið *PostgreSQL* sem gagnagrunnskerfi. Fyllið inn tengingarupplýsingar
  sem þið fenguð: host, port, database, user, password. Gott er að prófa tenginguna til að vera 
  viss um að hún virki. 
  - Í fyrsta skipti þarf að bæta við PostgreSQL driver, IDE mun spyrja um það og gefa leiðbeiningar.
  
{% embed url="https://www.youtube.com/watch?v=W5AumdArlO8" %}

### 3. [Visual Studio Code (VSCode)](https://code.visualstudio.com/)

**Kostir:**

- VSCode er mjög aðgengilegt þróunarumhverfi sem styður marga viðbótarpakka fyrir vinnu með SQL,
  eins og _PostgreSQL_.
- Með því að nota VSCode geturðu unnið með kóða og SQL í sama umhverfi, sem sparar tíma og eykur
  framleiðni.
- VSCode er opinn hugbúnaður frá Microsoft og hentar vel fyrir þá sem vilja einfalt og öflugt IDE
  sem virkar m.a. fyrir gagnagrunnskerfi.


# Gagnagrunnar með R

[Gagnagrunnar og SQL í RStudio - R-bloggers](https://www.r-bloggers.com/2022/02/working-with-databases-and-sql-in-rstudio/)
útskýrir hvernig hægt er að vinna með gagnagrunna og SQL beint í _RStudio_. Hún fer yfir
helstu tól og aðferðir til að tengjast gagnagrunnum eins og _SQLite_ og _PostgreSQL_ með R.

## SQLite með R

### [RSQLite pakki](https://cran.r-project.org/web/packages/RSQLite/index.html)

**Kostir:**

- `RSQLite` gerir R notendum kleift að vinna með _SQLite_ gagnagrunna beint innan R umhverfisins.
- Auðvelt í notkun fyrir smærri gagnasöfn eða sýnidæmi þar sem ekki er þörf á stórum
  gagnagrunnskerfum.
- [Skjölun fyrir RSQLite](https://cran.r-project.org/web/packages/RSQLite/RSQLite.pdf) útskýrir
  uppsetningu og notkun.

**Dæmi um notkun:**

```r
# Hlaða inn pakkanum
library(RSQLite)

# Tengja við SQLite gagnagrunn
con <- dbConnect(RSQLite::SQLite(), "nafn_grunns.db")

# Keyra SQL fyrirspurn
res <- dbSendQuery(con, "SELECT * FROM tafla")
data <- fetch(res, n = -1)

# Loka tengingu
dbDisconnect(con)
```

## PostgreSQL með R

### [RPostgreSQL pakki](https://cran.r-project.org/web/packages/RPostgreSQL/index.html)

**Kostir:**

- `RPostgreSQL` pakkinn leyfir R notendum að tengjast _PostgreSQL_ gagnagrunnum beint og vinna með
  gögn í R.
- Gagnlegt fyrir þá sem vinna með stór gagnasöfn í _PostgreSQL_ og þurfa að framkvæma
  tölfræðigreiningu í R.
- [Skjölun fyrir RPostgreSQL](https://cran.r-project.org/web/packages/RPostgreSQL/vignettes/RPostgreSQL.pdf)
  veitir ítarlegar upplýsingar um uppsetningu og notkun.

**Dæmi um notkun:**

```r
# Hlaða inn pakkanum
library(RPostgreSQL)

# Tengja við PostgreSQL gagnagrunn
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "nafn_grunns", host = "localhost",
                 port = 5432, user = "notandi", password = "lykilorð")

# Keyra SQL fyrirspurn
res <- dbSendQuery(con, "SELECT * FROM tafla")
data <- fetch(res, n = -1)

# Loka tengingu
dbDisconnect(con)
```

# Gagnagrunnar í Python

## SQLite með Python

### [sqlite3 pakki](https://docs.python.org/3/library/sqlite3.html)

**Kostir:**

- `sqlite3` er innbyggður gagnagrunnspakki í Python sem gerir auðvelt að vinna með _SQLite_
  gagnagrunna án þess að setja upp auka hugbúnað.
- Hentar fyrir smærri verkefni eða þegar einföld gagnavinnsla er nauðsynleg.
- [Skjölun fyrir sqlite3](https://docs.python.org/3/library/sqlite3.html) útskýrir hvernig á að nota
  þennan pakka með einföldum dæmum.

**Dæmi um notkun:**

```python
import sqlite3

# Tengja við SQLite gagnagrunn
conn = sqlite3.connect('nafn_grunns.db')

# Búa til cursor og keyra SQL fyrirspurn
cur = conn.cursor()
cur.execute("SELECT * FROM tafla;")
results = cur.fetchall()

# Loka tengingu
cur.close()
conn.close()
```

## PostgreSQL með Python

### [psycopg2 pakki](https://www.psycopg.org/)

**Kostir:**

- `psycopg2` er vinsælasti pakkinn fyrir tengingar við _PostgreSQL_ gagnagrunna í Python.
- Styður flóknar SQL fyrirspurnir, tengingar við stór gagnasöfn, og gerir auðvelt að sækja og vinna
  með gögn.
- [Skjölun fyrir psycopg2](https://www.psycopg.org/docs/) veitir nákvæmar leiðbeiningar um
  uppsetningu og notkun.

**Dæmi um notkun:**

```python
import psycopg2

# Tengja við PostgreSQL gagnagrunn
conn = psycopg2.connect(
    host="localhost",
    database="nafn_grunns",
    user="notandi",
    password="lykilorð"
)

# Búa til cursor og keyra SQL fyrirspurn
cur = conn.cursor()
cur.execute("SELECT * FROM tafla;")
results = cur.fetchall()

# Loka tengingu
cur.close()
conn.close()
```