---
description: >-
  Hér koma nokkrar æfingar úr SQL sem fara yfir helstu atriði sem fjallað er um í námskeiðinu.
---

Nema annað sé tekið fram, þá má gera ráð fyrir að allar æfingar séu unnar með _SQLite_
gagnagrunninum [surgeries.db](../surgeries.db).

# Grunnatriði í SQL

Prófið að finna SQL fyrirspurnina sem:

* Sýna aðgerðardagsetningar eftir hækkandi röð , ID sjúklings í lækkandi
* Sýna upplýsingar um lengstu aðgerðina
* Sýna nöfn og biðtíma þeirra sem hafa beðið lengst
* Sýna biðtíma sjúkling með fjórða lengsta biðtímann

# Tenging við strjála stærðfræði

Æfið ykkur í að tengja saman SQL fyrirspurnir við fyrra námsefni í strjálli stærðfræði.

* Sýnið alla sjúklinga sem hafa töluna 5 í nafni sínu og hafa beðið yfir 50 daga:
* Sýnið alla sjúklinga sem uppfylla eftirfarandi skilyrði:
    * Hafa tölunina einn í nafninu sínu,
    * Eru konur (`patient_sex = 'F'`),
    * Hafa beðið í að minnsta kosti 30 daga,
    * Eru yfir 50 ára.
* Finnið aðgerð sem er með `m` sem þriðja staf og `r` sem sjötta staf:

# Samsöfnum og hópun í SQL

Æfið ykkur í að nota samsöfnum og hópun í SQL.

- Heildarfjölda daga í bið eftir aðgerð eftir kyni.
- Meðalbið eftir kyni.
- Fjölda einstaklinga eftir kyni.
- Fjölda einstaklinga eftir aldri ef fleiri en einn á þeim aldri.

# Innflutningur og útflutningur í _SQLite_

Þessi æfing hjálpar ykkur að skilja hvernig á að flytja inn og út gögn í _SQLite_, og hvernig á að
vinna með gögnin til að sía þau og skoða í öðrum forritum.

* Náið í
  skránna [lung_cancer_number_of_male_deaths.csv](../../data/lung_cancer_number_of_male_deaths.csv).
* Flytjið skránna inn í _SQLite_ með því að nota `.import` skipunina. Passið að stilla rétt
  aðskilnaðartákn ef þörf krefur með `.separator` skipuninni.
* Síðan síum við gögnin þannig að einungis gögn frá Króatíu og Íslandi eru valin.
* Setjið innihald síuðu töflunnar í nýja CSV skrá.
* Opnið CSV skránna og skoðið innihaldið, til dæmis með Excel eða öðru forriti sem styður CSV skjöl.

