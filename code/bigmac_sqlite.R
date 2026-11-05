# Big Mac-vísitalan: sækir gögn The Economist (MIT-leyfi) af GitHub og vistar í
# lítinn SQLite-grunn, data/bigmac.db. Keyrt úr rót geymslunnar:
#   Rscript code/bigmac_sqlite.R
#
# Heimild: https://github.com/TheEconomist/big-mac-data
# Grunnurinn er vistaður í geymslunni svo bókin byggist án nettengingar. Keyrðu
# skriftuna aftur til að fá nýjustu tölurnar.

slod <- paste0("https://raw.githubusercontent.com/TheEconomist/big-mac-data/",
               "master/output-data/big-mac-raw-index.csv")
hratt <- read.csv(slod, stringsAsFactors = FALSE)

# Aðeins það sem bókin notar: dagsetning, land og verð í dollurum
bigmac <- data.frame(
  dags = hratt$date,
  iso = hratt$iso_a3,
  land = hratt$name,
  verd_usd = round(hratt$dollar_price, 3)
)

skra <- "data/bigmac.db"
con <- DBI::dbConnect(RSQLite::SQLite(), skra)
DBI::dbWriteTable(con, "bigmac", bigmac, overwrite = TRUE)
DBI::dbExecute(con, "CREATE INDEX IF NOT EXISTS bigmac_dags ON bigmac (dags)")
DBI::dbDisconnect(con)

cat("Vistaði", nrow(bigmac), "raðir frá", min(bigmac$dags), "til", max(bigmac$dags), "í", skra, "\n")
