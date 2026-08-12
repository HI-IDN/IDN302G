# Makefile fyrir Quarto-bókina.
# Keyrt úr rót public-geymslunnar.
#
#   make            # renderar aðeins .qmd/.md sem hafa breyst (hratt, fyrir efnisbreytingar)
#   make full       # heildar-render (þarf eftir _quarto.yml / .scss / uppbyggingarbreytingar)
#   make preview    # quarto preview: fylgist með breytingum og endurhleður sjálfkrafa
#   make clean      # eyðir docs/ og afleiddum cache (.quarto/_freeze/site_libs)
#
# Heimildaskrár eru í src/ (þar er _quarto.yml). Quarto skrifar HTML í docs/.
# Sniðmát í src/templates/ afritar Quarto sjálft inn í docs/templates/ (skráð sem
# `resources` í _quarto.yml) — Makefile þarf ekki að sjá um það lengur.

# Finna skrár með hreinum make-föllum (ekki find/shell) svo þetta virki eins
# á Windows (GnuWin32 make + cmd) og á macOS/Linux.
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2)$(filter $(subst *,%,$2),$d))

# Allar .qmd og .md heimildaskrár undir src/ (sleppum cache og templates/ — þau
# eru gögn sem eru afrituð, ekki bóksíður sem á að renderða).
ALL  := $(call rwildcard,src,*.qmd) $(call rwildcard,src,*.md)
# Sleppum cache, afrituðum gögnum og skrám sem eru EKKI bóksíður (AGENTS.md er
# agent-leiðbeiningar, ekki kafli).
SRC  := $(filter-out src/_freeze/% src/site_libs/% src/.quarto/% src/templates/% src/AGENTS.md,$(ALL))

# Samsvarandi HTML í docs/ (t.d. src/github/index.qmd -> docs/github/index.html).
HTML := $(patsubst src/%,docs/%,$(patsubst %.qmd,%.html,$(patsubst %.md,%.html,$(SRC))))

.PHONY: help all full preview clean server

# Höfn fyrir `make server` (static server á docs/).
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
	@echo "  make server   Static server a tilbunu docs/ (skoda lokautgafu, sja PORT)."
	@echo "  make clean    Eydir docs/ og afleiddum cache (.quarto/_freeze/site_libs)."
	@echo "  make help     Synir thennan lista."
	@echo ""
	@echo "Efnisbreyting -> 'make'.  Uppbygging/hlidarstika -> 'make full'."
	@echo "Vinna med live-reload -> 'make preview'.  Skoda lokautgafu -> 'make server'."

# Sjálfgefið: renderar hverja skrá sem er nýrri en HTML-úttakið hennar.
all: $(HTML)

# Regla: HTML fer eftir sinni heimildaskrá. Make ber saman tímastimpla og
# keyrir quarto aðeins ef .qmd/.md er nýrra en .html. Quarto er keyrt inni í src/.
docs/%.html: src/%.qmd
	cd src && quarto render $(patsubst src/%,%,$<)
docs/%.html: src/%.md
	cd src && quarto render $(patsubst src/%,%,$<)

# Heildar-render. NAUÐSYNLEGT eftir breytingar á _quarto.yml, styles/*.scss eða
# partials/* því þær hafa áhrif á hliðarstiku/þema ALLRA síðna, ekki bara einnar.
# Quarto afritar líka src/templates/ inn í docs/templates/ í leiðinni.
full:
	cd src && quarto render

preview:
	cd src && quarto preview

# Static server á tilbúnu docs/ (það sem GitHub Pages birtir). Sjálfgefið á porti
# 8000 — breyta má með `make server PORT=8080`. Byggðu fyrst með `make full`.
server:
	cd docs && python -m http.server $(PORT)

clean:
	rm -rf docs
	rm -rf src/.quarto src/_freeze src/site_libs
