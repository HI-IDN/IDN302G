---
description: >-
  CTE (Common Table Expression) er flóknari SQL aðferð til að vinna með gögn en undirfyrirspurnir.
---

# Common Table Expression (CTE)

CTE er sérstök gerð af undirfyrirspurn sem er skilgreind fyrir ofan aðal fyrirspurnina og er
hægt að vísa í hana í aðal fyrirspurninni. CTE er oftast notuð til að einfalda flóknar fyrirspurnir
og gera kóðann læsilegri.

Ekkert gott íslenskt orð fyrir CTE, og er þessi skammstöfun oftast notuð í daglegu tali.

Allar CTE byrja á `WITH` lykilorðinu, og er hægt að skilgreina mörg CTE í einu, en það er aðeins
eitt `WITH` lykilorð í fyrirspurninni allra fremst. Fleiri CTE eru aðskild með kommu. Að lokum
kemur aðal fyrirspurnin sem notar eitt eða fleiri undanfarinna CTE.


Hér er einfalt dæmi um hvernig við viljum nota CTE til að finna hús í norðrinu, og hvaða hús eru 
tegnd þeim húsunum:
```sql 
WITH cte AS (SELECT name, cadet_branches
             FROM got.houses
             WHERE region = 'The North')
SELECT *
FROM cte
ORDER BY cadet_branches LIMIT 3;
```

 name                         | cadet_branches 
------------------------------|----------------
 House Flint of Widow's Watch | {129,131}      
 House Flint of the mountains | {132}          
 House Stark of Winterfell    | {170,215}      

Ef við viljum vita hvaða þessi tengdu hús heita, þá getum við bætt við CTE:
```sql
WITH cadet_ids AS (SELECT name, unnest(cadet_branches) AS cadet_branch
                   FROM got.houses
                   WHERE region = 'The North'),
     cadet_names AS (SELECT cadet_ids.name,
                            houses.name AS cadet_branch,
                            houses.id   as cadet_branch_id
                     FROM cadet_ids
                              INNER JOIN got.houses ON cadet_ids.cadet_branch = got.houses.id
                     WHERE cadet_branch IS NOT NULL)
SELECT name, array_agg(cadet_branch ORDER BY cadet_branch_id) AS cadet_branches
FROM cadet_names
GROUP BY 1;
``` 
sem gefur okkur

 name                         | cadet_branches 
------------------------------|----------------
House Flint of the mountains  | {House Flint of Flint's Finger}
House Flint of Widow's Watch  | {House Flint of the mountains,House Flint of Flint's Finger}
House Stark of Winterfell     | {House Greystark of Wolf's Den,House Karstark of Karhold}


## Hvers vegna notum við CTE?
CTE eru notuð til að einfalda flóknar fyrirspurnir og gera kóðann læsilegri. Þegar fyrirspurnin
er mjög flókin og þarf að vinna með gögn úr mörgum töflum, getur CTE hjálpað til við að skilja
hvernig gögnin eru tengd saman.

CTE er ekki einskorðuð við `SELECT` fyrirspurnir. Það væri hægt að blanda saman `INSERT`, 
`UPDATE` og jafnvel `DELETE` fyrirspurnum í CTE. 

Hægt er að nota CTE til að búa til [sýndartöflur](views.md) sem geyma flóknar fyrirspurnir. 

> Það er jafnvel hægt að nota ítranir í CTE (recursive CTE), en það er utan efniviðar þessa 
> námskeiðs.

Frekari upplýsingar um CTE má finna í 
[PostgreSQL skjölunum](https://www.postgresql.org/docs/current/queries-with.html).