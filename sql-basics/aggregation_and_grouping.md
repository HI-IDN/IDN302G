---
description: >-
  Samsöfnun og hópun gagna með SQL, þar sem farið er yfir notkun á föllum eins og 
  AVG, COUNT og GROUP BY til að framkvæma útreikninga á gögnum jafnvel eftir hópun gagna með eða 
  án skilyrða.
---

# Samsöfnun gagna

- Oft viljum við finna heildarupplýsingar um gögn til að mynda fyrir hópa.
- SQLite býður meðal annars upp á þessar aðgerðir:
    - Meðaltal - `AVG()`
    - Lággildi - `MIN()`
    - Hágildi - `MAX()`
    - Summa - `SUM()`
    - Teljari - `COUNT()`

Til að finna meðalbið einstaklinga eftir skurðaðgerð:

```sql
SELECT avg(Patient_DaysOnWaitingList)
FROM Patient_list;
```

Til að finna hágildi (`MAX`) og lággildi (`MIN`):

```sql
SELECT MAX(Patient_DaysOnWaitingList)
FROM Patient_list;
```

## Samsöfnun með skilyrðum

Einnig er hægt að nota þetta með skilyrðum. Til dæmis, ef við viljum reikna út meðalbiðtíma þeirra
sem hafa beðið eftir aðgerð og eru undir 50 ára:

```sql
SELECT AVG(Patient_DaysOnWaitingList) AS Avg_Waiting_Time
FROM Patient_list
WHERE Patient_Age < 50;
```

þar sem `AS` er notað til að búa til nafn fyrir niðurstöðuna.

## Stjórnun marktækra stafa

Til að stýra marktækum stöfum er hægt að nota fallið `ROUND()`:

```sql
SELECT ROUND(AVG(Patient_DaysOnWaitingList), 2) AS Meðaltal
FROM Patient_list
WHERE Patient_Age < 50;
```

Gefur: 36.55 í stað 36.5454545454545.

## Teljari - `COUNT()`

Oft viljum við telja línur í töflum. Notum til þess fallið `COUNT()`:

- Til að telja allar línur í töflu:
  ```sql
  SELECT COUNT(*) FROM Patient_list;
  ```
- Til að telja öll gildi í ákveðnum dálki:
  ```sql
  SELECT COUNT(Patient_Age) FROM Patient_list;
  ```
- Til að telja ólík gildi í dálki, notum við `DISTINCT()`:
  ```sql
  SELECT COUNT(DISTINCT Patient_Age) FROM Patient_list;
  ```

# Hópun gagna - `GROUP BY`

Til að finna meðaltal eftir hópi (t.d. aldur) eru tvær leiðir færar:

1. Gera nokkrar fyrirspurnir:
    ```sql
    SELECT AVG(Patient_DaysOnWaitingList) AS Avg_Waiting_Time
    FROM Patient_list
    WHERE Patient_Sex = 'M';
    SELECT AVG(Patient_DaysOnWaitingList) AS Avg_Waiting_Time
    FROM Patient_list
    WHERE Patient_Sex = 'F';
    ```
2. Einfaldara er þó að nota hópa með `GROUP BY` og finna þannig meðaltal eftir aldurshópum:
    ```sql
    SELECT Patient_Sex, AVG(Patient_DaysOnWaitingList) AS Avg_Waiting_Time
    FROM Patient_list
    GROUP BY Patient_Sex;
    ```
   Þessi leið er miklu skilvirkari og skiljanlegri.

   > **Athugið:** Ef við veljum dálk sem er ekki í `GROUP BY` klausu, þá leyfa sum 
   > gagnagrunnsmál ekki að keyra skipunina nema það sé með samsöfnunarfalli. Þetta er ekki 
   > tilfellið í _SQLite_. Hér væri t.d. hægt að velja `Patient_Age` beint, en þá fáum við bara 
   > *eitthvert* gildi fyrir þann hóp skilgreindan með `GROUP BY`.

## Reglur um hópun

Almennt má nota fleiri en einn dálk í `GROUP BY`. Í þeim tilfellum er hópað á alla dálkana sem eru
útlistaðir:

```sql
SELECT col1, col2, AVG(col3)
FROM tbl
GROUP BY col1, col2;
```

Þetta gefur okkur allar mögulegar samsetningar af `col1` og `col2` og finnur meðaltal af `col3`
fyrir hverja samsetningu. Til dæmis væri minsta bið eftir kyni og aldri fundin með:

```sql
SELECT Patient_Sex, Patient_Age, MIN(Patient_DaysOnWaitinglist) AS Min_Waiting_Time
FROM Patient_list
GROUP BY Patient_Sex, Patient_Age;
```

## Röðun

Yfirleitt er úttakinu raðað eftir hópum. Til að vera viss um ákveðna röðun úttaks, notum
við `ORDER BY`. Hægt er að raða eftir nafni dálks eða númeri dálks:

```sql
SELECT Patient_Sex, Patient_Age, MIN(Patient_DaysOnWaitinglist) AS Min_Waiting_Time
FROM Patient_list
GROUP BY Patient_Sex, Patient_Age
ORDER BY 3 DESC, Patient_Sex;
``` 

Að velja eftir númeri dálks er sérstaklega hentugt þegar við viljum raða eftir útreikningum.

## Velja úr hópum

Til að velja úr hópum, notum við `HAVING` eftir `GROUP BY` klausu. Þetta er svipað og `WHERE` en
er framkvæmt eftir hópun:

```sql
SELECT Patient_Age, AVG(Patient_DaysOnWaitingList) AS Avg_Waiting_Time
FROM Patient_list
GROUP BY Patient_Age
HAVING COUNT(*) > 1;
```

> **Athugið:** Hægt er að nota bæði `WHERE` og `HAVING` í sömu skipun.
> - `WHERE` er notað til að sía út línur áður en hópar eru gerðir, en
> - `HAVING` á einungis við samsöfnuðu upplýsinganna fyrir hópinn.
