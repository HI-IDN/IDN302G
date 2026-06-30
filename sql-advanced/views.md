---
description: >-
  Sýndartöflur eru sniðugar fyrir endurteknar fyrirspurnir og fyrirspurnir sem byggja á mörgum 
  tengdum töflum.
---

# Sýndartafla - `VIEW`

Sýndartafla (e. view) er vistuð SQL fyrirspurn sem virkar eins og tafla. Í stað þess að búa til nýja
töflu með föstum gögnum, er fyrirspurnin keyrð í hvert skipti sem sýndartaflan er notuð, og hún
endurspeglar því alltaf nýjustu gögnin í viðkomandi töflum.

## Af hverju að nota sýndartöflur?

Sýndartöflur eru mjög sniðugar í eftirfarandi tilvikum:

- **Einangrun flókinna fyrirspurna**: Ef þú ert með flóknar tengdar töflur eða fyrirspurnir sem þú
  notar reglulega, getur þú vistað þær sem sýndartöflu. Þannig þarftu ekki að skrifa sömu
  fyrirspurnina aftur og aftur.

- **Sjálfvirk uppfærsla gagna**: Sýndartafla heldur ekki sjálf gögn; hún keyrir fyrirspurn í
  rauntíma. Þetta þýðir að ef undirliggjandi töflur breytast, endurspeglar sýndartaflan alltaf
  nýjustu gögnin, sem kemur í veg fyrir að úrelt gögn séu geymd.

- **Auðveldara að viðhalda**: Ef þú ert með reglulega fyrirspurn sem notar mörg skilyrði eða marga
  `JOIN`, getur það orðið tímafrekt og flókið að skrifa það oft. Með sýndartöflu getur þú
  einfaldlega sótt niðurstöðuna eins og hún væri venjuleg tafla.

- **Engin föst gögn**: Sýndartöflur geyma ekki sjálfar gögn, sem er stór kostur ef þú vilt forðast
  að búa til tvítekin gögn. Þetta er mikilvægt þegar gögn í undirliggjandi töflum breytast oft og þú
  þarft alltaf nýjustu útkomuna.

- **Einföldun á flóknum tengingum**: Ef þú ert oft að tengja saman margar töflur með flóknum
  tengiskilyrðum, getur sýndartafla einfaldað vinnuna með því að halda utan um þessar tengingar. Þú
  getur þá unnið með hana eins og venjulega töflu án þess að þurfa að hugsa um tengingarnar í hvert
  skipti.

> Víðtæk venja er að skíra sýndartöflur með forskeytinu `v_` til að auðvelda það að greina hana 
> frá raunverulegum töflum.
> 
> Ef sýndartaflan er sérstaklega þung og flókin en mikið notuð, þá er oft búinn til `stored 
> procedure` sem tekur gögnin sem kæmu í sýndartöflunni og setur það í raunverulega töflu. 
> Yfirleitt eru slíkir ferlar keyrðir á föstum tímum (oft á miðnætti) til að uppfæra gögnin 
> fyrir næsta dag. Notendum er því bent á að nota þá töflu frekar, en sýndartöfluna ef þau þurfa 
> _nauðsynlega_ að vinna með nýjustu gögnunum. 

## Búa til sýndartöflu

```sql
CREATE VIEW got.v_character_books_pov(book_id, book_name, character_id, character_name) AS
SELECT b.id as book_id, b.name as book_name,
    c.id as character_id, c.name as character_name
FROM got.books b
         INNER JOIN got.character_books cb ON b.id = cb.book_id
         INNER JOIN got.characters c ON cb.character_id = c.id
WHERE pov = TRUE;
``` 
Hér er búin til sýndartafla á `got` skemanu sem heitir `v_character_books_pov`. Hún inniheldur 
auðkennisdálka og nafn bóka allra persónu sem eru sagðar í fyrstu persónu í bókum. 

Í raun dugar að tiltaka `CREATE VIEW got.v_character_books_pov AS` og sýndartaflan mun 
sjálfkrafa setja dálkaheitin og gagnatýpur út frá `SELECT` fyrirspurninni.

## Finna sýndartöflur og skilgreiningar

Til að finna allar sýndartöflur í grunninum er hægt að gera fyrirspurn á `pg_views` töfluna.

```sql
SELECT * FROM pg_views WHERE schemaname IN ('got','atlas')
```

Hér getiði þið skoða dálkinn `definition` til að sjá hvernig sýndartöflan er skilgreind.




