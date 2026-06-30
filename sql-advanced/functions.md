---
description: >-
  Föll í PostgreSQL eru bæði innbyggð, eins og SUM(), COUNT(), og NOW(), og sérsniðin sem búnar eru til með CREATE FUNCTION. Sérsniðin föll geta skilað einu eða fleiri gildum og gera það auðvelt að endurnýta kóða og vinna með sértæka útreikninga.
---

# Föll í _PostgreSQL_

Föll í _PostgreSQL_ geta verið bæði innbyggð og sérsniðin, sem gerir gagnagrunnskerfið mjög
sveigjanlegt og öflugt. Innbyggð föll eins og `SUM()`, `AVG()`, `COUNT()` og `NOW()` eru
mikið notuð til útreikninga, samantekta og vinnslu gagna. Auk þess er hægt að búa til
sérsniðin föll með `CREATE FUNCTION`, sem geta skilað einu gildi, eins og summu eða texta, eða mörgum
gildum í formi töflu. Þetta gerir notendum kleift að einangra flókna lógík, endurnýta kóða og 
vinna betur með sérhæfðar aðgerðir sem ekki er hægt að ná fram með innbyggðum föllum.

## Sérsniðin föll - `CREATE FUNCTION`

Í _PostgreSQL_ er hægt að búa til sérsniðin föll með **`CREATE FUNCTION`** skipuninni. Slík föll geta
skilað einu gildi, mörgum gildum, eða jafnvel heilum töflum. Þetta er öflugt tæki til að endurnýta
kóða og bæta við sérsniðna útreikninga eða flóknar aðgerðir í gagnagrunninum.

Nánari útskýringar um hvernig sérsniðin föll virka má finna í [PostgreSQL skjölunum](https://www.postgresql.org/docs/current/sql-createfunction.html).


### Fall sem skilar einu gildi

Einfaldasta útgáfan af `CREATE FUNCTION` er fall sem tekur við einhverjum inntaksgildum og skilar
**einu** útkomugildi.

```sql
CREATE FUNCTION add_numbers(a integer, b integer) RETURNS integer AS $$
BEGIN
    RETURN a + b;
END;
$$ LANGUAGE plpgsql;
```
Útskýring:
- `CREATE FUNCTION add_numbers(a integer, b integer)`: Skilgreinir nýtt fall með tveimur 
  inntaksbreytum `a` og `b`, sem eru báðar af gerðinni `integer`.
- `RETURNS integer`: Lýsir því yfir að fallið skilar gildi af gerðinni `integer`.
- `LANGUAGE plpgsql`: Gefur til kynna að fallið sé skrifað í `plpgsql`, sem er innbyggt málsnið fyrir 
  _PostgreSQL_.

Við getum kallað á fallið `add_numbers` með því að nota `SELECT` skipun alveg einsog við höfum 
gert með innbyggðum föllum fram af þessu, hvort sem það er í `SELECT`, `FROM` eða `WHERE` 
klausum fyrirspurnarinnar.

```sql 
SELECT add_numbers(5, 10);
-- Niðurstaða:
-- add_numbers
-- ------------
--          15
```

###  Fall sem skilar mörgum gildum

Föll í _PostgreSQL_ geta líka skilað mörgum gildum, sem getur verið gagnlegt þegar við viljum fá 
fleiri upplýsingar úr einni fyrirspurn. Til að skilgreina fall sem skilar mörgum gildum þurfum við
að nota `RETURNS TABLE` í stað `RETURNS` og skilgreina dálka og gerðir þeirra.

```sql
CREATE FUNCTION calculate_values(a double precision, b double precision)
RETURNS TABLE (
    sum_value double precision,
    product_value double precision
) AS $$
BEGIN
    RETURN QUERY
    SELECT a + b, a * b;
END;
$$ LANGUAGE plpgsql;
```

Útskýring:
- `CREATE FUNCTION calculate_values(a double precision, b double precision)`: Skilgreinir nýtt fall 
sem tekur við tveimur `double precision` tölum, `a` og `b`.
- `RETURNS TABLE (...)`: Gefur til kynna að fallið skili töflu með dálkum `sum_value` og 
  `product_value`.
- `RETURN QUERY SELECT a + b, a * b`: Keyrir fyrirspurnina sem skilar bæði summu og margfeldi af `a` 
  og `b`.

Kalla á fallið:
```sql 
SELECT * FROM calculate_values(5, 10);
-- Niðurstaða:
-- sum_value | product_value
-- ----------+--------------
--       15  |           50
SELECT calculate_values(5, 10);
-- Niðurstaða:
-- calculate_values
-- ------------------
-- (15, 50)
```