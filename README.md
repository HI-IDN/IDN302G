# IDN302G – Upplýsingaverkfræði

Námsefni fyrir námskeiðið **Upplýsingaverkfræði IÐN302G** við Háskóla Íslands.  
Efnið er skrifað í Markdown og birt á GitHub Pages.

## Vefslóð að námsefninu

👉 [hi-idn.github.io/IDN302G](https://hi-idn.github.io/IDN302G)

---

## Uppbygging geymslu

```
IDN302G/
├── src/             # Frumefni námskeiðsbókarinnar: Markdown, Quarto, myndir og stílar
│   ├── about-course/ # Upplýsingar um námskeiðið, skipulag og námsmat
│   ├── ai-tools/    # Efni um erindreka og ábyrga notkun gervigreindar
│   ├── github/      # Efni um Git og GitHub
│   ├── reproducible-reports/ # Endurtækar skýrslur
│   ├── regex/       # Reglulegar segðir
│   ├── logic-sets/  # Rökfræði, mengi og vensl
│   ├── sql-basics/  # SQL grunnatriði
│   ├── sql-advanced/ # SQL framhald
│   ├── storytelling/ # Myndræn framsetning og gagnafrásögn
│   └── styles/      # Sérsniðnir stílar fyrir námskeiðsbókina
├── docs/            # Afleidd vefsíða sem Quarto býr til úr src/
├── templates/       # Sniðmát, m.a. TEAM.md fyrir hópa
├── data/            # Gagnaskrár sem notaðar eru í æfingum
├── code/            # Kóði og hjálparskrár sem styðja við sýnidæmi/æfingar
└── README.md        # Yfirlit yfir gagnageymsluna
```

`src/` er frumútgáfa námsefnisins. `docs/` er spegill/renderuð útgáfa sem verður til þegar Quarto
bókin er byggð fyrir GitHub Pages. Ef þú sérð villu í námsefninu eða vilt leggja til breytingu á
innihaldi skaltu breyta viðeigandi source-möppu undir `src/`, til dæmis `src/github/`,
`src/reproducible-reports/`, `src/sql-basics/` eða `src/storytelling/`, ekki `docs/` beint.

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
3. Gerðu breytingarnar þínar í viðeigandi source-möppu undir `src/`, t.d. `src/github/`, `src/regex/` eða `src/sql-basics/`
4. Committaðu: `git commit -m "Lýsing á breytingu"`
5. Sendu **Pull Request** og útskýrðu hvað þú breyttir og hvers vegna

Ekki breyta skrám í `docs/` beint. Almennar efnisbreytingar eiga heima í Markdown/Quarto
source-skránum undir `src/`. `docs/` er uppfært með Quarto render.

---

## Viðmið fyrir framlög

- Skrifaðu á **íslensku** nema efnið krefjist annars (t.d. tæknileg hugtök)
- Haltu þig við Markdown – ekki nota HTML nema nauðsynlegt sé
- Eitt PR = ein breyting; ekki blanda saman mörgum ótengdum breytingum
- Lýstu breytingunni skýrt í PR lýsingunni

---

## Leyfi

Þetta verkefni er útgefið undir [GNU General Public License](LICENSE).
