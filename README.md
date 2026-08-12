# IDN302G – Upplýsingaverkfræði

Námsefni fyrir námskeiðið **Upplýsingaverkfræði IÐN302G** við Háskóla Íslands.  
Efnið er skrifað í Markdown og birt á GitHub Pages.

## Vefslóð að námsefninu

👉 [hi-idn.github.io/IDN302G](https://hi-idn.github.io/IDN302G)

---

## Uppbygging geymslu

```
IDN302G/
├── docs/            # Frumefni námskeiðsbókarinnar: Markdown, Quarto, myndir og stílar
│   ├── about-course/ # Upplýsingar um námskeiðið, skipulag og námsmat
│   ├── ai-tools/    # Efni um erindreka og ábyrga notkun gervigreindar
│   ├── github/      # Efni um Git og GitHub
│   ├── reproducible-reports/ # Endurtækar skýrslur
│   ├── regex/       # Reglulegar segðir
│   ├── logic-sets/  # Rökfræði, mengi og vensl
│   ├── sql-basics/  # SQL grunnatriði
│   ├── sql-advanced/ # SQL framhald
│   ├── storytelling/ # Myndræn framsetning og gagnafrásögn
│   ├── styles/      # Sérsniðnir stílar fyrir námskeiðsbókina
│   └── _freeze/     # Frystar niðurstöður keyranlegs kóða (svo Actions þarf ekki R)
├── templates/       # Sniðmát, m.a. TEAM.md fyrir hópa
├── data/            # Gagnaskrár sem notaðar eru í æfingum
├── code/            # Kóði og hjálparskrár sem styðja við sýnidæmi/æfingar
└── README.md        # Yfirlit yfir gagnageymsluna
```

`docs/` er frumútgáfa námsefnisins. Þegar Quarto byggir bókina fer renderaða vefsíðan í `_site/`,
sem er **ekki** í geymslunni — GitHub Actions byggir hana í skýinu og birtir á GitHub Pages. Ef þú
sérð villu í námsefninu eða vilt leggja til breytingu á innihaldi skaltu breyta viðeigandi
source-möppu undir `docs/`, til dæmis `docs/github/`, `docs/reproducible-reports/`,
`docs/sql-basics/` eða `docs/storytelling/`.

---

## Hvernig á að leggja til breytingar

Við hvetjum nemendur til að koma með endurbætur á námsefninu. Hér er hvernig það virkar:

### 1. Villur og ábendingar → Issue

Ef þú:
- rekst á villu (stafsetning, kóði, útskýring)
- finnst eitthvað óskýrt eða vanta
- ert með tillögu að breytingu

➡️ [Opnaðu Issue](../../issues/new)

### 2. Umræður og hugmyndir → Discussion

Ef þú vilt ræða hugmynd, spyrja spurninga eða koma með tillögur án þess að þær séu formlegar:

➡️ [Byrjaðu Discussion](../../discussions)

### 3. Leggja beint til breytingar → Pull Request

1. Gerðu **fork** af þessum repo
2. Búðu til nýjan branch: `git checkout -b fix/lýsing-á-breytingu`
3. Gerðu breytingarnar þínar í viðeigandi source-möppu undir `docs/`, t.d. `docs/github/`, `docs/regex/` eða `docs/sql-basics/`
4. Committaðu: `git commit -m "Lýsing á breytingu"`
5. Sendu **Pull Request** og útskýrðu hvað þú breyttir og hvers vegna

Almennar efnisbreytingar eiga heima í Markdown/Quarto source-skránum undir `docs/`. Renderaða
vefsíðan (`_site/`) er byggð sjálfkrafa af GitHub Actions — þú þarft ekki að byggja hana handvirkt.

---

## Byggja bókina staðbundið

Til að einfalda byggingu og forskoðun fylgir **`Makefile`** í rót geymslunnar. Það kallar á
Quarto fyrir þig og virkar bæði í Git Bash og PowerShell (þarf [Quarto](https://quarto.org)
uppsett, og `make`).

| Skipun | Aðgerð |
|--------|--------|
| `make` | Renderar aðeins þær síður sem hafa breyst (hratt, fyrir efnisbreytingar). |
| `make full` | Heildar-render. Nota eftir breytingar á `_quarto.yml`, stílum eða kaflaskipan. |
| `make preview` | Quarto preview með sjálfvirkri endurhleðslu meðan þú vinnur. |
| `make serve` | Static server á tilbúnu `_site/` (skoða lokaútgáfu; `make serve PORT=8080`). |
| `make help` | Sýnir þennan lista. |

Dæmigert vinnuflæði: keyrðu `make preview` meðan þú breytir. Ef þú breytir keyranlegum kóða
skaltu keyra `make full` áður en þú commitar svo frystu niðurstöðurnar í `docs/_freeze/` uppfærist.

---

## Viðmið fyrir framlög

- Skrifaðu á **íslensku** nema efnið krefjist annars (t.d. tæknileg hugtök)
- Haltu þig við Markdown – ekki nota HTML nema nauðsynlegt sé
- Eitt PR = ein breyting; ekki blanda saman mörgum ótengdum breytingum
- Lýstu breytingunni skýrt í PR lýsingunni

---

## Leyfi

Þetta verkefni er útgefið undir [GNU General Public License](LICENSE).
