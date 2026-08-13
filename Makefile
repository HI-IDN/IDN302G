# Makefile fyrir Quarto-bókina.
# Keyrt úr rót public-geymslunnar.
#
#   make            # renderar aðeins .qmd/.md sem hafa breyst (hratt, fyrir efnisbreytingar)
#   make full       # heildar-render (þarf eftir _quarto.yml / .scss / uppbyggingarbreytingar)
#   make preview    # quarto preview: fylgist með breytingum og endurhleður sjálfkrafa
#   make server      # static server á tilbúnu _site/ (skoða lokaútgáfu)
#
# Heimildaskrár eru í docs/ (þar er _quarto.yml). Quarto skrifar HTML í _site/
# (byggt af GitHub Actions í skýinu, ekki commit-að). Sniðmát eru í templates/ á
# rót geymslunnar og tengjast beint á GitHub — ekki afrituð inn í úttakið.

# Finna skrár með hreinum make-föllum (ekki find/shell) svo þetta virki eins
# á Windows (GnuWin32 make + cmd) og á macOS/Linux.
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2)$(filter $(subst *,%,$2),$d))

# Allar .qmd og .md heimildaskrár undir docs/ (sleppum cache og skrám sem eru
# EKKI bóksíður).
ALL  := $(call rwildcard,docs,*.qmd) $(call rwildcard,docs,*.md)
# Sleppum cache, afrituðum gögnum og AGENTS.md (agent-leiðbeiningar, ekki kafli).
SRC  := $(filter-out docs/_freeze/% docs/site_libs/% docs/.quarto/% docs/AGENTS.md,$(ALL))

# Samsvarandi HTML í _site/ (t.d. docs/github/index.qmd -> _site/github/index.html).
HTML := $(patsubst docs/%,_site/%,$(patsubst %.qmd,%.html,$(patsubst %.md,%.html,$(SRC))))

.PHONY: help all full preview server lint lint-fix

# Höfn fyrir `make server` (static server á _site/).
PORT ?= 8000

# Bert `make` byggir (all), ekki help.
.DEFAULT_GOAL := all

# Yfirlit yfir helstu aðgerðir.
help:
	@echo "Quarto-bokin - helstu adgerdir (keyrt ur rot public/):"
	@echo ""
	@echo "  make          Renderar adeins .qmd/.md sem hafa breyst (hratt)."
	@echo "  make all      Sama og 'make' - byggir bara breyttar sidur."
	@echo "  make full     Heildar-render. Nota eftir _quarto.yml / .scss /"
	@echo "                kaflabreytingar (uppfaerir hlidarstiku a OLLUM sidum)."
	@echo "  make preview  Quarto preview: fylgist med breytingum + endurhledur (vinna)."
	@echo "  make server   Static server a tilbunu _site/ (skoda lokautgafu, sja PORT)."
	@echo "  make lint     Athugar .qmd: title/description i frontmatter + newline i enda."
	@echo "  make lint-fix Sama og 'make lint' en lagar oruggu newline-atridin sjalfvirkt."
	@echo "  make help     Synir thennan lista."
	@echo ""
	@echo "Efnisbreyting -> 'make'.  Uppbygging/hlidarstika -> 'make full'."
	@echo "Vinna med live-reload -> 'make preview'.  Skoda lokautgafu -> 'make server'."

# Sjálfgefið: renderar hverja skrá sem er nýrri en HTML-úttakið hennar.
all: $(HTML)

# Regla: HTML fer eftir sinni heimildaskrá. Make ber saman tímastimpla og
# keyrir quarto aðeins ef .qmd/.md er nýrra en .html. Quarto er keyrt inni í docs/.
_site/%.html: docs/%.qmd
	cd docs && quarto render $(patsubst docs/%,%,$<)
_site/%.html: docs/%.md
	cd docs && quarto render $(patsubst docs/%,%,$<)

# Heildar-render. NAUÐSYNLEGT eftir breytingar á _quarto.yml, styles/*.scss eða
# partials/* því þær hafa áhrif á hliðarstiku/þema ALLRA síðna, ekki bara einnar.
full:
	cd docs && quarto render && quarto render slides/intro.qmd && mkdir -p ../_site/slides ../_site/styles && rm -f ../_site/slides/intro.html && rm -rf ../_site/slides/intro_files && cp -r slides/intro.html slides/intro_files ../_site/slides/ && cp styles/watermark.css ../_site/styles/watermark.css

preview:
	cd docs && quarto preview

# Static server á tilbúnu _site/ (það sem GitHub Pages birtir). Sjálfgefið á porti
# 8000 — breyta má með `make server PORT=8080`. Byggðu fyrst með `make full`.
server:
	cd _site && python -m http.server $(PORT)

# Linter fyrir .qmd: title/description í frontmatter og newline í enda skrár.
lint:
	python scripts/lint_qmd.py

lint-fix:
	python scripts/lint_qmd.py --fix
