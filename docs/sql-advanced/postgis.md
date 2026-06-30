---
description: >-
  PostGIS er viðbót við PostgreSQL sem bætir við stuðningi fyrir landfræðileg og rúmfræðileg gögn, 
  sem gerir mögulegt að vinna með gagnapunkta, línur, margflötunga og fleiri form í gagnagrunnum.
---

# PostGIS fyrir PostgreSQL

_PostGIS_ er viðbót við _PostgreSQL_ gagnagrunnskerfið sem bætir við stuðningi fyrir landfræðileg
og rúmfræðileg gögn. Með _PostGIS_ er hægt að geyma, sækja og framkvæma flóknar greiningar á
staðbundnum gögnum innan _PostgreSQL_. Þetta gerir það að verkum að _PostGIS_ er mikið notað fyrir
verkefni tengd kortagerð, landfræðilegri greiningu, og aðra vinnslu á gögn með
staðsetningarupplýsingar.

Dálkar fyrir rúmfræðileg gögn eru oftast geymd sem `geometry` eða `geography` gagnatýpur. Algeng
dálkaheiti eru því `geom` eða `geog` fyrir margflötunga. Eins eru `point`, `linestring`,
`polygon` fyrir einfaldari rúmfræðileg gögn.

## Game of Thrones gagnasettið

Skemað `atlas` inniheldur tvær töflur:
- `atlas.locations` sem inniheldur staðsetningar í dálknum `geog` sem er `POINT`.
- `atlas.kingdoms` sem inniheldur landsvæði í dálknum `geom` sem er `MULTIPOLYGON`, sem gæti 
  verið samsettur marghyrningur.

## Helstu föll í PostGIS

_PostGIS_ bætir við miklum fjölda af föllum sem eru gagnleg til að vinna með staðbundin gögn. Hér
eru nokkur af helstu föllum sem PostGIS býður upp á:

- `ST_Point`: Býr til punkt með tilteknum lengdar- og breiddargráðum.
  ```sql
  SELECT ST_Point(-73.935242, 40.730610);
    ```
  niðurstaðan er `01010000001FF64201DB7B52C0B610E4A0845D4440`

- `ST_Makeline`: Býr til línustrik með gefnum punktum.
    ```sql
    SELECT ST_Makeline(
        ARRAY[ST_MakePoint(0, 0), ST_MakePoint(1, 1), ST_MakePoint(2, 2)]
    );
    ```
    - Ef það eru bara tveir punktar þá þarf að nota `ARRAY[...]::geometry[]` ritháttinn, heldur
      einfaldlega `SELECT ST_MakeLine(ST_MakePoint(0, 0), ST_MakePoint(1, 1))`.

- `ST_MakePolygon`: Býr til marghyrning með gefnum hornpunktum.
    ```sql
    SELECT ST_MakePolygon( ST_GeomFromText('LINESTRING(75 29,77 29,77 29, 75 29)'));
    ```
  sem væri marghyrningur með hornpunkta $$(75, 29)$$, $$(77, 29)$$, $$(77, 29)$$, $$(75, 29)$$.
- `ST_Area`: Skilar flatarmáli marghyrnings.
    ```sql
    SELECT ST_Area(ST_MakePolygon( ST_GeomFromText('LINESTRING(3 3, 3 5, 5 5, 5 3, 3 3)') ));
    ```
  gefur `4` (fermetra) sem er flatarmál fernings með hliðarlengd `2` og upphaf í $$(3, 3)$$.
- `ST_Length`: Skilar lengd línu eða línuhluta.
    ```sql
    SELECT ST_Length(
        ST_Makeline(
            ARRAY[ST_MakePoint(1, 1), ST_MakePoint(3, 3), ST_MakePoint(4, 5)]
        )
    );
    ```
  sem gefur `5.06449510224598` sem er það sama og evklíðsa fjarlægðin á milli $$(1,1)$$ og $$(3,3)
  $$ og svo $$(3,3)$$ og $$(4,5)$$:

  $$ \text{length} = \sqrt{(3 - 1)^2 + (3 - 1)^2} + \sqrt{(4 - 3)^2 + (5 - 3)^2} = \sqrt{8} + \sqrt{5} \approx 5.07$$

- `ST_Distance`: Skilar minnstu fjarlægð milli tveggja hluta (gæti verið punktur eða marghyrningur)
  ```sql
    SELECT st_distance(
        ST_MakePoint(0, 0),
        st_makeline(
            ARRAY[ST_MakePoint(1, 1), ST_MakePoint(3, 3), ST_MakePoint(4, 5)]
        )
    );
  ```
  sem skilar `1.4142135623730951` sem er sama og evklíðska fjarlægðin milli punktanna $$(0, 0)$$
  og $$(1, 1)$$, sem er næsti hornpunkturinn í marghyrningnum.

- `ST_Contains`: Skilar `TRUE` ef fyrri marghyrningurinn inniheldur seinni marghyrninginn. 
   - Sönn tilfelli 
  
        ![LINESTRING / MULTIPOINT](https://postgis.net/images/st_contains01.png)![POLYGON / POINT](https://postgis.net/images/st_contains02.png)![POLYGON / LINESTRING](https://postgis.net/images/st_contains03.png)![POLYGON / POLYGON](https://postgis.net/images/st_contains04.png)

   - Ósönn tilfelli

        ![POLYGON / MULTIPOINT](https://postgis.net/images/st_contains05.png)![POLYGON / LINESTRING](https://postgis.net/images/st_contains06.png)

   - Ósönn tilfelli (en gætu verið sönn með `ST_Covers`)
     
        ![LINESTRING / POINT](https://postgis.net/images/st_contains07.png)![POLYGON / LINESTRING](https://postgis.net/images/st_contains08.png)


- `ST_Intersection`: Skilar skurðpunktum tveggja marghyrna, og skilar `NULL` ef marghyrnarnir 
  skerast ekki, sbr. $$A\cap B$$. Nátengt fall `ST_Intersects` skilar `TRUE` ef marghyrnarnir 
  skerast, en skilar ekki skurðpunktum, `FALSE` annars.
- `ST_Union`: Sameinar tvo marghyrninga, sbr. $$A\cup B$$.
- `ST_Buffer`: Býr til svæði með gefinni fjarlægð frá gefnum punkti.
    ```sql
    SELECT ST_Buffer(
        ST_MakePoint(0, 0),
        1
    );
    ```
- `ST_Centroid`: Skilar miðpunkt marghyrnings.
    ```sql
    SELECT ST_Centroid(ST_MakePolygon( ST_GeomFromText('LINESTRING(75 29,77 29,77 29, 75 29)')));
    ```
- `ST_Transform`: Breytir rúmfræðilegum hlut í annað kóðunarkerfi (e. SRID).
    ```sql
    SELECT ST_Transform(
        ST_SetSRID(ST_MakePoint(0, 0), 4326),
        3857
    );
    ```
    - `4326` er kóðunarkerfið fyrir WGS 84 (World Geodetic System 1984), samanber flest heimskort.
    - `3857` er kóðunarkerfið fyrir Web Mercator, sem er algengasta kóðunarkerfið fyrir  kort á 
      vefnum, t.d. Google Maps.

    > SRID tryggir að gögn séu túlkuð rétt með tilliti til staðsetningar á jörðinni, sem þýðir að
      þau verða rétt staðsett á korti. Ef gögnin eru með mismunandi viðmiðunarkerfi, eins og eitt
      gagnasett með WGS 84 og annað með Web Mercator, gæti staðsetning þeirra verið röng ef
      viðmiðunarkerfin eru ekki samræmd. Ef þú vilt t.d. að miðja á korti sé rétt staðsett í Japan í
      stað Evrópu, þá þarf að tryggja að gögnin noti rétt SRID, annars gæti punktur eða svæði verið
      misskilið og birt á röngum stað. Með því að samræma SRID með `ST_Transform` er tryggt að
      gögnin séu túlkuð og birt rétt, hvort sem það er fyrir punkt, línu eða margflötung.

## Frekari upplýsingar

_PostGIS_ býður upp á fjölmörg önnur föll til að vinna með og greina landfræðileg gögn, sem gerir
_PostgreSQL_ að öflugri lausn fyrir rúmfræðileg verkefni.

Þú getur fengið frekari upplýsingar og skoðað opinberu handbókina á
[PostGIS.net](https://postgis.net/docs/manual-3.4/).