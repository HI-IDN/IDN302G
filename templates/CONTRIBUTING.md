# Hvernig við vinnum saman

Þetta skjal lýsir vinnuferli hópsins á GitHub — hvernig við samræmum vinnu, kóðum, rýnum og skilum.

## Grunnreglur

- Enginn committar beint á `main`
- Allt fer í gegnum Pull Request með **minnst 2 rýnum**:
  - Að lágmarki 1 rýni frá manneskju í hópnum
  - GitHub Copilot sjálfvirk rýni telst sem önnur (eftir verkefnum)
- Commit-skilaboð eru skrifuð á [íslensku / ensku — sjá TEAM.md]

## Útibúaheiti

```
lota/stutt-lýsing
```

Dæmi:
- `git/setja-upp-repo`
- `sql/hreinsa-tóm-gildi`
- `capstone/mælaboard-drög`

## Commit-skilaboð

Notið þetta snið:

```
tegund: stutt lýsing í nútíð

Lengri skýring ef þörf er á — hvers vegna, ekki hvað.
```

Tegundir:
- `feat` — ný virkni
- `fix` — villuleiðrétting
- `data` — breytingar á gögnum eða hreinsun
- `docs` — skjöl og skýrslur
- `refactor` — endurskipulagning án nýrrar virkni

## Pull Request ferli

1. Búðu til útibú frá `main`
2. Gerðu breytingarnar í litlum, röklegum commitum
3. Opnaðu PR og fylltu út lýsinguna (sjá sniðmát)
4. Biðjðu hópmeðlim um kóðarýni
5. Rýnirinn leggur til breytingar eða samþykkir
6. Sá sem opnaði PR mergear þegar samþykkt

## Kóðarýni — hvað á að leita að

- Keyrir kóðinn án villna?
- Er niðurstaðan endurtæk (*reproducible*)?
- Er kóðinn læsilegur og vel skjalfærður?
- Passar breyting við lýsingu PR?
- Er eitthvað sem þú skilst ekki — spurðu!
