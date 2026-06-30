---
description: >-
  Grunnskipanir í SQL eru í brennidepli, þar á meðal SELECT, WHERE, AND, OR, og NOT. 
  Einnig hvernig megi setja inn (INSERT), uppfæra (UPDATE) og eyða (DELETE) gögnum í töflum.
---

> *Athugið*: Hér koma sýnidæmi með SQL fyrirspurnum fyrir _SQLite_ gagnagrunn. Nánar til tekið
> skráin [surgeries.db](../../data/surgeries.db) sem inniheldur töflur með upplýsingum um
> sjúklinga. Lesið [notkun á _SQLite_ skipanaskel](database_interaction.md#notkun-á-skipanaskel)
> til að sjá hvernig á að snögglega til að sjá hvernig á að tengjast gagnagrunni.

# SQL forsaga

SQL var hannað af IBM í kringum 1970 og byggir á fræðilegu líkani um vensl með smá útvíkkun. SQL var
fyrst tekið í notkun í tölvum um 1980 og er sérstaklega hannað til að vinna með gagnagrunna sem eru
samsettir úr töflum.

SQL inniheldur margar gerðir skipana, þar sem ein aðalskipunin er `SELECT`. Aðrar skipanir í
SQL vinna með töflur og gögn, til dæmis til að búa til, breyta og eyða töflum, setja inn, breyta og
eyða gögnum, og breyta skipulagi gagnanna. SQL fyrirspurnir tilgreina hvaða gögn við viljum nálgast,
en ekki hvernig þau eru fundin, sem gerir SQL mjög öflugt og sveigjanlegt.

> **Athugið:** Í SQL er almennt skrifað frátekin orð (t.d. `SELECT`, `FROM`, `WHERE`) í hástöfum,
> en nöfn á töflum og dálkum (t.d. `employee`, `name`) með lágstöfum. Fyrir lengri skipanir er
> algengt að setja hvert frátekið orð á nýja línu til að auka læsileika.

# SELECT skipun

`SELECT` skipunin er notuð til að ná í innihald tafla. Hér eru tvö einföld dæmi:

```sql
SELECT *
FROM patient_list;
SELECT patient_name
FROM patient_list; 
```

Munurinn á þessum tveimur fyrirspurnum er að sú fyrri nær í öll gögnin úr töflunni `patient_list`, á
meðan sú seinni nær aðeins í gögnin úr dálkinum `patient_name`.

Útkoman úr fyrirspurninni getur birtist asnalega þegar gögnin eru sýnd í einföldu formi. Til dæmis:

```
Patient_1|101|10|M|40 
Patient_2|102|50|M|50 
```

Við getum látið _SQLite_ setja úttakið upp í dálka til að fá skýrari framsetningu með því að nota
eftirfarandi skipanir:

```bash
-- Set display mode to columns 
.mode columns

-- Enable headers in the output 
.headers on 

-- Show all tables in the database
.tables

-- exit the program
.exit
```

Nú verður sama úttak auðlæsilegra:

```
Patient_Name  Patient_SSN  Patient_DaysOnWaitingList  Patient_Sex  Patient_Age
------------  -----------  -------------------------  -----------  -----------
Patient_1     101          10                         M            40
Patient_2     102          50                         M            50
```

Þessar stillingar munu skipuleggja úttakið í dálka og sýna nöfn dálkanna, sem gerir gögnin
aðgengilegri og auðveldari í lestri. Prófaðu núna aftur að keyra fyrirspurnina að ofan.

# Röð úttaks - `ORDER BY`

Úttakið úr fyrirspurnum kemur oft í „einhverri röð“, líklega eftir því hvenær gögnin voru sett inn.
Línurnar í úttakinu eru stök í mengi, og stök í mengi hafa enga sérstaka röð. Til að stjórna röð
úttaksins, notum við `ORDER BY`. Prófið eftirfarandi:

```sql
-- Select and sort by Patient_Age 
SELECT Patient_Name, Patient_Age
FROM Patient_list
ORDER BY Patient_Age; 
```

Sjálfgefið er að `ORDER BY` raðar í hækkandi röð (e. _ascending_). Til að raða í lækkandi röð (e.
_descending_), getum við notað `DESC`, og til að halda áfram í hækkandi röð, getum við notað `ASC`.
Við getum einnig raðað eftir mörgum dálkum:

```sql
SELECT *
FROM Patient_list
ORDER BY Patient_Age DESC, Patient_DaysOnWaitingList; 
```

# Takmarka/sleppa línum með `LIMIT` og `OFFSET`

Stundum viljum við ekki fá allar línur úr fyrirspurninni heldur aðeins hluta af þeim. Við getum
takmarkað fjölda lína í úttakinu með `LIMIT` skipuninni. Hér er dæmi um hvernig á að velja aðeins
þrjár efstu línurnar:

```sql
-- Select the top 3 rows, sorted by Age in descending order
SELECT *
FROM Patient_list
ORDER BY Patient_Age DESC LIMIT 3; 
```

Ef við viljum sleppa fyrstu línunum og velja næstu línur, getum við bætt við `OFFSET` skipuninni
ásamt `LIMIT`. Hér er dæmi þar sem við sleppum fyrstu tveimur línunum og veljum næstu þrjár:

```sql
-- Skip the first 2 rows and select the next 3 
SELECT *
FROM Patient_list
ORDER BY Patient_Age DESC LIMIT 3
OFFSET 2; 
```

# `WHERE` skilyrði

Við notum `WHERE` þegar við viljum að ákveðnir dálkar í töflu uppfylli einhver skilyrði. Grunnformið
fyrir `WHERE` skipanir er:

```sql
SELECT column1, column2, ...FROM table_name
WHERE condition; 
```

Til að sýna sjúklinga sem eru 40 ára og eldri:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Age >= 40; 
```

Til að sýna sjúklinga sem eru konur:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Sex = 'F'; 
```

Eða með notkun `<>` til að velja sjúklinga sem eru ekki karlar:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Sex <> 'M'; 
```

## `AND`, `OR` og `NOT` skilyrði

Með `WHERE` skilyrðum er hægt að nota einn eða fleiri mengjavirka eins og `AND`, `OR`, og `NOT` til
að sía gögn út frá fleiri en einu skilyrði:

* `AND`er satt ef öll skilyrði eru uppfyllt.
* `OR` er satt ef eitt eða fleiri skilyrði eru uppfyllt.
* `NOT` birtir gögn þar sem skilyrðið er ekki satt (öfugt sanngildi).

Sýnið alla sjúklinga sem eru á aldrinum 40 og 60 ára:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Age >= 40
  AND Patient_Age <= 60;
```

Hér má einnig nota `BETWEEN` skilyrði sem jafngilt við `>= 40 AND <= 60`:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Age BETWEEN 40 AND 60;
```

## Útreikningar í skilyrðum

Við getum notað útreikninga í skilyrðum. Til dæmis, ef við viljum finna konur sem hafa beðið lengur
en 4 vikur á biðlista, getum við notað eftirfarandi fyrirspurn:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Sex = 'F'
  AND Patient_DaysOnWaitingList / 7 > 4;
```

Ef bæði tölurnar eru heiltölur (þ.e. af taginu `INT`), þá verður útkoman sjálfkrafa heiltala vegna
sjálfgefinna reglna um ummyndun í SQL. Til að gera samanburðinn með fleytitölum (
t.d. `FLOAT`, `DECIMAL` eða `REAL`) eða þarf önnur talan að vera fleytitala, til dæmis með því að
deila með `7.0` í stað `7`.

## Forgangur virkja

Virkjar eins og `AND`, `OR` og `NOT` hafa mismunandi forgang. Til dæmis, í
útreikningnum `4 + 5 * 3`, hefur margföldun (`*`) hærri forgang en samlagning (`+`), sem leiðir til
niðurstöðunnar 19. Notum sviga til að fá rétta útkomu ef þörf krefur:

```sql
SELECT 4 + 5 * 3   AS column1, -- Result is 19 
       (4 + 5) * 3 AS column2; -- Result is 27 
```

> **Athugið**, hér gáfum við útreiknaða dálkinum okkar ,,nafn'' með `AS`.

# Reglulegar segðir með `LIKE`

`LIKE` skipunin er notuð til að leita að mynstri í strengjum með hjálp algildisstafa (e. wildcards).
Algildisstafir eins og `%` og `_` leyfa okkur að framkvæma leitir með mynstrum í strengjum.

Ef við viljum finna hvort orð í dálki innihaldi ákveðið mynstur, eins og staf eða hluta af orði,
notum við táknið `%`, sem parast á móti 0 eða fleiri stöfum í streng:

```sql
-- Find rows where the column contains 'word' anywhere in the string 
SELECT col
FROM tbl
WHERE col LIKE '%word%';
```

Ef við viljum finna orð af ákveðinni lengd, notum við `_` (undirstrik) þar sem hvert undirstrik
táknar einn bókstaf. Til dæmis, ef við viljum finna orð með þremur stöfum:

```sql
-- Find rows where the column contains exactly three characters 
SELECT col
FROM tbl
WHERE col LIKE '___'; 
```

Ef við viljum finna gildi sem hafa X sem annan staf og enda á Y, notum við mynstur með `_` og `%`:

```sql
-- Find rows where the second character is 'X' and ends with 'Y' 
SELECT col
FROM tbl
WHERE col LIKE '_X%Y'; 
```

## `REPLACE` fallið

`REPLACE` fallið getur verið notað til að skipta út ákveðnum strengjum í gögnunum. Fallið tekur þrjú
inntök: `REPLACE(strengur, samsvörun, skipta_út)`.

## Hástafir og lágstafir

`LIKE` gerir ekki greinarmun á hástöfum og lágstöfum í _SQLite_. Þú getur breytt þessari hegðun með
því að nota skipunina:

```sql
-- Enable case sensitivity for LIKE in SQLite 
PRAGMA
case_sensitive_like = ON; 
```

`PRAGMA` er óstöðluð skipun sem hægt er að nota til að breyta hegðun _SQLite_ á ýmsa vegu.

# Tengsl við strjála stærðfræði

Hvað þýðir þetta allt saman og hvernig tengist þetta undanfarið námsefni? SQL og strjál stærðfræði
hafa ýmis tengsl sem við getum skoðað í samhengi við fyrirspurnir og mengjafræði.

SQL skipunin `SELECT x FROM A WHERE P(X);`þýðir að velja línur úr töflunni $$A$$ sem uppfylla
skilyrðið $$P(X)$$. Í strjálli stærðfræði er þetta jafngilt menginu: $$\{x \in A \mid P(x) \}$$ sem
þýðir „mengi þeirra staka $$x$$ úr $$A$$ sem uppfylla yrðinguna $$P(X)$$.“

Hér eru nokkur lykilhugtök og tengingar við strjála stærðfræði:

* **Mengi**: Tafla er mengi af línum.
* **Vensl**: Tafla skilgreinir vensl milli staka.
* **Yrðingar**: Veljum úttakið með yrðingu (`WHERE`skilyrði).
* **Reglulegar segðir**: Yrðingar geta notað reglulegar segðir (`LIKE`) til að sía gögn.

# Setja inn gögn í töflur með `INSERT`

Til að setja inn gögn í töflur í SQL notum við `INSERT` skipunina. Það eru tvær aðalleiðir til að
nota `INSERT`: með því að tilgreina dálka sem við viljum setja gögn inn í, eða með því að setja inn
gögn í alla dálka töflunnar ef öll gildi eru tilgreind.

## Notkun `INSERT` með dálkalista

Þegar við viljum setja inn gögn í ákveðna dálka í töflunni, tilgreinum við dálkalistann
í `INSERT INTO` skipuninni. Hér er dæmi:

```sql
 -- Insert data into specific columns of the operators table 
INSERT INTO operators (opID, opName, opSSN, opAge, opYearInit)
VALUES (1, 'Anna', '0101013010', 45, 2010); 
```

## Notkun `INSERT` án dálkalista

Ef öll gildi eru skilgreind fyrir alla dálka í töflunni, getum við sleppt því að tilgreina
dálkalistann og setja inn gögn beint. Þessi aðferð er aðeins nothæf ef gildi eru til staðar fyrir
alla dálka í réttri röð:

```sql
-- Insert data into all columns of the operators table 
INSERT INTO operators
VALUES (2, 'Hannes', '0102013010', 55, 2011);
```

Ef ekki eru öll gildi skilgreind í `INSERT` skipuninni, mun það valda villu (og gögnin verða þá ekki
sett inn) nema dálkurinn hafi sjálfgefna gildið (`DEFAULT`) eða leyfir `NULL`.

Til að forðast villur er gott að tilgreina dálkalistann sérstaklega ef ekki eru öll gildi til
staðar.

# Uppfæra gagnagrunn með `UPDATE`

`UPDATE` skipunin er notuð til að breyta gögnum í töflum. Hún gerir kleift að uppfæra gildi í einum
eða fleiri dálkum fyrir línur sem uppfylla tiltekin skilyrði.

Grunnformið fyrir `UPDATE` skipunina er:

```sql
UPDATE table_name
SET column1 = value1,
    column2 = value2, 
    ...
WHERE condition;
```

Ef við viljum uppfæra aldur starfsmanns með tiltekið auðkenni (`opID`), gætum við notað eftirfarandi
skipun:

```sql
-- Update the age of an operator with a specific opID 
UPDATE operators
SET opAge = 45
WHERE opID = 1;
```

Í þessu dæmi er aldur (`opAge`) uppfærður í 45 fyrir starfsmann með `opID` 1. Ef `WHERE` skilyrðið
er _ekki_ tilgreint, verður uppfært í öllum línum í töflunni, sem getur leitt til óæskilegra
breytinga.

# Að eyða gögnum úr töflum

Til að eyða gögnum úr töflum í SQL notum við `DELETE` skipunina. `DELETE` gerir kleift að fjarlægja
eina eða fleiri línur úr töflu byggt á skilyrðum sem við tilgreinum með `WHERE` skilyrði. Ef við
viljum eyða töflunni algjörlega, þá getum við notað `DROP` skipunina.

## Eyða ákveðnum línum með `DELETE`

Grunnformið fyrir `DELETE` skipunina er:

```sql
DELETE
FROM table_name
WHERE condition; 
```

Til dæmis, ef við viljum eyða starfsmanni með tiltekið auðkenni (`opID`), notum við eftirfarandi
skipun:

```sql
-- Delete an operator with a specific opID 
DELETE
FROM operators
WHERE opID = 1; 
```

Í þessu dæmi verður aðeins lína þar sem `opID` er 1 eytt úr töflunni `operators`.

> **Athugið**: Notkun `WHERE` er mikilvægt til að forðast óæskilegar eyðingar á gögnum.

## Eyða öllum línum með `DELETE` eða `TRUNCATE`

Ef þú vilt eyða öllum línum í töflunni án þess að eyða töflunni sjálfri, getur þú keyrt `DELETE`
**án** `WHERE` skilyrðisins:

```sql
-- Delete all rows from the operators table 
DELETE
FROM operators;
```

Í sumum öðrum gagnagrunnskerfum, eins og _PostgreSQL_, er hægt að nota `TRUNCATE` skipunina til að
eyða öllum línum í töflunni. `TRUNCATE` er oft hraðvirkari en `DELETE` vegna þess að hún fjarlægir
gögnin án þess að rekja hverja eyðingu fyrir sig.

```sql
-- Truncate the operators table, removing all rows 
TRUNCATE TABLE operators;
```

`TRUNCATE` hefur einnig þann kost að endurstilla sjálfvirka númerara (`AUTO_INCREMENT`) í sumum
gagnagrunnum.

## Eyða töflu með `DROP`

Ef þú vilt eyða töflunni sjálfri og öllum gögnum sem hún inniheldur, notum við `DROP TABLE`
skipunina:

```sql
-- Drop the operators table, removing the table and all its data 
DROP TABLE operators;
```

> **Athugið**: Þessi aðgerð er er óafturkræft og taflan verður alveg fjarlægð úr gagnagrunninum.