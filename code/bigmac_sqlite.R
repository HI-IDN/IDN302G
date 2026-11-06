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

# Íslensk landaheiti, tengd við bigmac á iso-kóða. Land sem vantar hér heldur enska
# heitinu (COALESCE í fyrirspurnunum), svo nýtt land í gögnunum brýtur ekkert.
lond <- data.frame(iso = c(
  "ARE", "ARG", "AUS", "AZE", "BHR", "BRA", "CAN", "CHE", "CHL", "CHN", "COL", "CRI", "CZE", "DNK",
  "EGY", "EUZ", "GBR", "GTM", "HKG", "HND", "HUN", "IDN", "IND", "ISR", "JOR", "JPN", "KOR", "KWT",
  "LBN", "LKA", "MDA", "MEX", "MYS", "NIC", "NOR", "NZL", "OMN", "PAK", "PER", "PHL", "POL", "QAT",
  "ROU", "RUS", "SAU", "SGP", "SWE", "THA", "TUR", "TWN", "UKR", "URY", "USA", "VEN", "VNM", "ZAF"),
  nafn = c(
  "Sameinuðu arabísku furstadæmin", "Argentína", "Ástralía", "Aserbaídsjan", "Barein", "Brasilía",
  "Kanada", "Sviss", "Síle", "Kína", "Kólumbía", "Kosta Ríka", "Tékkland", "Danmörk",
  "Egyptaland", "Evrusvæðið", "Bretland", "Gvatemala", "Hong Kong", "Hondúras", "Ungverjaland",
  "Indónesía", "Indland", "Ísrael", "Jórdanía", "Japan", "Suður-Kórea", "Kúveit",
  "Líbanon", "Srí Lanka", "Moldóva", "Mexíkó", "Malasía", "Níkaragva", "Noregur", "Nýja-Sjáland",
  "Óman", "Pakistan", "Perú", "Filippseyjar", "Pólland", "Katar",
  "Rúmenía", "Rússland", "Sádi-Arabía", "Singapúr", "Svíþjóð", "Taíland", "Tyrkland", "Taívan",
  "Úkraína", "Úrúgvæ", "Bandaríkin", "Venesúela", "Víetnam", "Suður-Afríka"))
DBI::dbWriteTable(con, "land", lond, overwrite = TRUE)
DBI::dbDisconnect(con)

cat("Vistaði", nrow(bigmac), "raðir frá", min(bigmac$dags), "til", max(bigmac$dags), "í", skra, "\n")
