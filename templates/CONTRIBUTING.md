# Vinnuflæði

Þetta repo notar Pull Request vinnuflæði.

## Issues

Góð venja er að byrja á GitHub Issue áður en farið er í stærri breytingu.

Issue hjálpar teyminu að:

- afmarka hvað á að gera,
- ræða lausn áður en byrjað er að breyta mörgum skrám,
- tengja saman vinnu, Pull Request og skil,
- halda PR nógu litlum til að hægt sé að rýna hann vel.

## Branch

Notið stutt og lýsandi branch-nöfn:

```text
feature/staedsetningar
fix/dagsetningar
docs/uppfaera-readme
analysis/fyrsta-talning
```

## Commit

Skrifið commit-skilaboð sem segja hvað breyttist.

Gott:

```text
Bætir við fyrstu gagnahreinsun fyrir hverfanöfn
```

Óskýrt:

```text
fix
```

Ef erindreki / AI-agent lagði marktækt til breytinguna, bætið honum við sem co-author í
commit-skilaboðin:

```text
Co-authored-by: AI Agent <agent@example.com>
```

## Pull Request

PR á að vera nógu lítið til að hægt sé að rýna það vel.

Opnið PR fyrst sem **draft**. Sá sem bað um breytinguna á að skoða og staðfesta draftið áður en
óskað er eftir rýni frá öðrum í teyminu. Þegar requester hefur yfirfarið breytinguna má merkja PR
sem ready for review.

Í PR-lýsingunni á að koma fram:

- hvað var breytt,
- hvers vegna breytingin var gerð,
- hvernig hægt er að prófa eða skoða breytinguna,
- hvort eitthvað vanti enn,
- hvort erindreki / AI-agent aðstoðaði við breytinguna.

Ef erindreki var notaður marktækt á PR að vísa í viðeigandi færslu í `AGENT_LOG.md`.

## Kóðarýni

Rýnandi skoðar meðal annars:

- hvort breytingin sé skiljanleg,
- hvort hún passi við verkefnið,
- hvort README eða leiðbeiningar þurfi að uppfærast,
- hvort afleiddar eða stórar skrár hafi óvart farið inn,
- hvort agent-logg og PR-lýsing séu samræmd ef AI var notað.

Rýni á að vera hjálpleg og nákvæm. Ekki skrifa bara „lgtm“ ef þú hefur ekki lesið breytinguna.
