---
description: >-
  Undirfyrirspurnir eru SQL fyrirspurnir sem keyrðar eru innan annars SQL fyrirspurnar.
---

# Undirfyrirspurnir

Undirfyrirspurnir (e. subqueries) eru SQL fyrirspurnir sem keyrðar eru innan annarrar fyrirspurnar.
Þær eru oft notaðar til að einangra gögn eða framkvæma flóknar aðgerðir sem ekki er hægt að
framkvæma í einni einfaldri fyrirspurn. Undirfyrirspurnir geta verið keyrðar í `WHERE`, `FROM`, eða
jafnvel `SELECT` hlutum stærri fyrirspurna, og bjóða þannig upp á aukna sveigjanleika við
gagnavinnslu.

## Undirfyrirspurn í `WHERE` skilyrði

```sql 
SELECT name, population
FROM cities
WHERE population > (SELECT AVG(population) FROM cities);
```

Í þessu dæmi finnur undirfyrirspurnin meðaltalsíbúafjölda (`AVG`) fyrir alla borgirnar í cities
töflunni, og aðalfyrirspurnin skilar borgum með íbúafjölda yfir því meðaltali.

Undirfyrirspurnin þarf ekki að skila einu gildi, hún getur skilað mörgum gildum. Ef það er listi
af gildum (þ.e.a.s. aðeins einn dálkur) þarf að nota `IN` í stað `=`:

```sql
SELECT name, population
FROM cities
WHERE population IN (SELECT population FROM cities WHERE country = 'Iceland');
```

## Undirfyrirspurn í `SELECT` hluta fyrirspurnar

Undirfyrirspurn í `SELECT` hluta fyrirspurnar þarf að skila einu gildi sem er birt í hverri línu í
niðurstöðutöflunni.

```sql
SELECT name, population, (SELECT AVG(population) FROM cities) AS avg_population
FROM cities;
```

## Undirfyrirspurn í `FROM` hluta fyrirspurnar

Við getum líka verið með undirfyrirspurnir í `FROM` klausum:

```sql
SELECT name, population
FROM (SELECT * FROM cities WHERE population > 1000000) big_cities;
```

Hér er undirfyrirspurnin notuð til að búa til tímabundna töflu sem inniheldur aðeins borgir með
íbúafjölda yfir 1 milljón. Það verður samt að gefa tímabundnu nafni á töflunni, hér er það 
`big_cities`.