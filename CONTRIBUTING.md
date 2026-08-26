# Að leggja til efni

Takk fyrir að vilja bæta námsefnið. Þessi geymsla hýsir kennslubók IÐN302G og allir mega leggja
til — nemendur í námskeiðinu jafnt sem aðrir.

Vefurinn er á [hi-idn.github.io/IDN302G](https://hi-idn.github.io/IDN302G) og er byggður
sjálfvirkt úr `docs/` með [Quarto](https://quarto.org/).

## Fljótlegasta leiðin: segðu okkur frá því

Þú þarft ekki að kunna Git til að hjálpa. Flestar ábendingar eru best komnar sem
[issue](https://github.com/HI-IDN/IDN302G/issues/new/choose) — það eru til tilbúin form fyrir
villur í efni, tæknilegar villur á vefnum og viðbætur.

Spurningar og hugmyndir eiga hins vegar heima í
[Discussions](https://github.com/HI-IDN/IDN302G/discussions), ekki sem issue.

## Ef þú vilt laga það sjálf

1. Forkaðu geymsluna og búðu til grein út frá `main`.
2. Gerðu breytinguna í `docs/`.
3. **Þýddu staðbundið og skoðaðu niðurstöðuna** áður en þú sendir hana inn.
4. Opnaðu pull request á `main`.

Byrjaðu sem **drög** (draft). Þegar þú merkir hann *Ready for review* fer þýðingarprófið af stað
og yfirferð hefst.

### Uppsetning

```bash
python -m pip install -r requirements.txt
```

R-pakkarnir eru taldir upp í [`.github/workflows/publish.yml`](.github/workflows/publish.yml).

Quarto keyrir `{python}`-búta gegnum **reticulate**, ekki gegnum þann `python` sem er á `PATH`.
Sé `RETICULATE_PYTHON` ekki sett býr reticulate til sitt eigið umhverfi án `pandas`, og þýðingin
fellur á `ModuleNotFoundError` þótt `pip list` sýni pakkann:

```bash
export RETICULATE_PYTHON="$(which python)"
```

Settu þá línu í `.Renviron` svo hún haldi milli lota.

### Þýðing

```bash
make        # aðeins breyttar síður
make full   # allt; nauðsynlegt eftir breytingar á _quarto.yml eða stílum
make preview
```

## Reglur um kóða í efninu

Þrennt sem skiptir mestu og er auðvelt að misstíga sig á:

**Kóðabútar eiga að keyra.** Skrifaðu ```` ```{r} ```` eða ```` ```{python} ```` og láttu Quarto búa til
úttakið. Handskrifuð niðurstaða lítur eins út en úreldist þegjandi — kóðinn breytist, talan ekki.
Sama gildir um tölur í texta: skrifaðu `` `r nrow(x)` `` í stað þess að slá töluna inn.

**Hver bútur þarf nafn.** Án þess segir villuboðið `[unnamed-chunk-14]` og þú þarft að telja búta
í skránni til að finna hann. Venjan er `<síða>-<r|py>-<n>`.

**Tvær síður eru frystar** af því að þjónustan sem þær tala við hleypir byggingarþjóninum ekki
að. Breytirðu þeim þarftu að endurþýða þær sérstaklega og skila frystu niðurstöðunni með.
Nánar í [`docs/AGENTS.md`](docs/AGENTS.md).

Sú skrá geymir ítarlegri leiðbeiningar um uppbyggingu bókarinnar og er lesin bæði af fólki og
erindrekum.

## Efni sem er ekki þitt

Námsefnið vitnar í ytri heimildir og sækir gögn úr opnum vefþjónustum. Þegar þú bætir slíku við:

- Geymdu ekki afrit af efni annarra í geymslunni. Vísaðu í það.
- Virtu `robots.txt` og skilmála þjónustunnar þegar þú sækir gögn.
- Aðgangslyklar fara **aldrei** í geymsluna, ekki heldur í kóðabút sem er merktur `eval: false`.

## Framkoma

Þátttaka í þessari geymslu lýtur [siðareglunum](CODE_OF_CONDUCT.md).
