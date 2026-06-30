---
description: >-
  UNION í SQL sameina niðurstöður úr tveimur eða fleiri fyrirspurnum og hvernig þær vinna með 
  endurtekningar.
---

# Sameining niðurstaðna

Í SQL eru `UNION` og `UNION ALL` notaðar til að sameina niðurstöður úr tveimur eða fleiri
fyrirspurnum í eina útkomu. Þær hjálpa til við að vinna með gögn úr mörgum fyrirspurnum á einfaldan
hátt.

## `UNION`

`UNION` sameinar niðurstöður tveggja eða fleiri fyrirspurna og skilar **aðeins einstökum línum**.
Það fjarlægir sjálfkrafa afrit, þannig að hver lína birtist aðeins einu sinni, jafnvel þó hún komi
fyrir í báðum fyrirspurnunum.

## `UNION ALL`

`UNION ALL` virkar á sama hátt og `UNION`, nema að það **fjarlægir ekki afrit**. Þetta þýðir að
allar línur, þar með talið afrit, verða með í niðurstöðunum. Þetta getur verið gagnlegt þegar þú
vilt sjá allar línur án þess að sameina eða samræma þær.

## Munur á `UNION` og `UNION ALL`:

- **`UNION`**: Skilar einstökum línum þar sem afrit eru fjarlægð.
- **`UNION ALL`**: Skilar öllum línum, þar með talið afritum.

Bæði `UNION` og `UNION ALL` krefjast þess að fyrirspurnirnar sem sameinaðar eru hafi sama fjölda
dálka og að gagnatýpurnar í samsvarandi dálkum séu samhæfar. Hér er _ekki_ átt við að dálkarnir 
þurfa að heita það sama, heldur að þeir þurfi að hafa sömu gagnatýpu. Heitið sem mun birtast 
munu vera samkvæmt fyrstu fyrirspurninni í sameiningunni.

`UNION` er umtalsvert dýrari að keyra en `UNION ALL`, þar sem `UNION` þarf að athuga hvort línur 
séu eins og hún fer yfir niðurstöðurnar.
