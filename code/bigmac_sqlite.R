# Big Mac-vísitalan: sækir gögn The Economist (MIT-leyfi) af GitHub og vistar í
# lítinn SQLite-grunn, data/bigmac.db. Keyrt úr rót geymslunnar:
#   Rscript code/bigmac_sqlite.R
#
# Heimildir: https://github.com/TheEconomist/big-mac-data (Big Mac-verð) og
# opinbert viðmiðunargengi Seðlabanka Íslands (gengi Bandaríkjadals).
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
  "Úkraína", "Úrúgvæ", "Bandaríkin", "Venesúela", "Víetnam", "Suður-Afríka"),
  # Staður: forsetning og þágufall, svo texti geti sagt „í Kólumbíu“
  stadur = c(
  "í Sameinuðu arabísku furstadæmunum", "í Argentínu", "í Ástralíu", "í Aserbaídsjan", "í Barein",
  "í Brasilíu", "í Kanada", "í Sviss", "í Síle", "í Kína", "í Kólumbíu", "í Kosta Ríka",
  "í Tékklandi", "í Danmörku", "í Egyptalandi", "á evrusvæðinu", "í Bretlandi", "í Gvatemala",
  "í Hong Kong", "í Hondúras", "í Ungverjalandi", "í Indónesíu", "á Indlandi", "í Ísrael",
  "í Jórdaníu", "í Japan", "í Suður-Kóreu", "í Kúveit", "í Líbanon", "á Srí Lanka", "í Moldóvu",
  "í Mexíkó", "í Malasíu", "í Níkaragva", "í Noregi", "á Nýja-Sjálandi", "í Óman", "í Pakistan",
  "í Perú", "á Filippseyjum", "í Póllandi", "í Katar", "í Rúmeníu", "í Rússlandi",
  "í Sádi-Arabíu", "í Singapúr", "í Svíþjóð", "í Taílandi", "í Tyrklandi", "í Taívan",
  "í Úkraínu", "í Úrúgvæ", "í Bandaríkjunum", "í Venesúela", "í Víetnam", "í Suður-Afríku"))
DBI::dbWriteTable(con, "land", lond, overwrite = TRUE)

# Gengi Bandaríkjadals í krónum: opinbert viðmiðunargengi Seðlabanka Íslands (skráð
# miðgengi, tímaröð 4055), sótt úr XML-vefþjónustu bankans. Fyrir hverja dagsetningu
# í bigmac er notað síðasta skráða gengi á eða fyrir þann dag (1. janúar er frídagur).
gengi_slod <- paste0("https://sedlabanki.is/xmltimeseries/Default.aspx?DagsFra=",
                     as.Date(min(bigmac$dags)) - 10, "&DagsTil=", max(bigmac$dags),
                     "&TimeSeriesID=4055&Type=xml")
xml <- paste(readLines(gengi_slod, warn = FALSE, encoding = "UTF-8"), collapse = "")
faerslur <- regmatches(xml, gregexpr("<Entry>.*?</Entry>", xml, perl = TRUE))[[1]]
skrad <- data.frame(
  dagur = as.Date(sub(".*<Date>([0-9/]+) .*", "\\1", faerslur), format = "%m/%d/%Y"),
  isk = as.numeric(sub(".*<Value>([0-9.]+)</Value>.*", "\\1", faerslur))
)
dags_bm <- sort(unique(bigmac$dags))
gengi <- do.call(rbind, lapply(dags_bm, function(d) {
  fyrir <- skrad[skrad$dagur <= as.Date(d), ]
  sidast <- fyrir[which.max(fyrir$dagur), ]
  data.frame(dags = d, gengisdagur = format(sidast$dagur), isk_per_usd = sidast$isk)
}))
DBI::dbWriteTable(con, "gengi", gengi, overwrite = TRUE)

# Ísland til samanburðar: McDonald's er ekki á Íslandi, en Heimsborgari á Metro er
# íslenska ígildi Big Mac. Verðið er skráð hér í höndunum úr vefverslun Metro
# (Smáratorgi) og þarf að uppfæra handvirkt. Vefverslunin sækir matseðilinn úr
# vefþjónustu, en hún krefst innskráningar og er ekki opin.
island <- data.frame(
  vara = "Heimsborgari á Metro",
  verd_isk = 1919,
  heimild = paste0("https://metro.yonoton.shop/6bd32855-8ebc-4844-90eb-569f2ed513d1/feature/",
                   "f74b2427-53a3-404b-97db-f94b9e1dd88d",
                   "?selectedOutletId=c77ea7e1-31d5-400d-bc3f-383dfb8ddc90"),
  sott = "2026-11-06"
)
DBI::dbWriteTable(con, "island", island, overwrite = TRUE)
DBI::dbDisconnect(con)

cat("Vistaði", nrow(bigmac), "raðir frá", min(bigmac$dags), "til", max(bigmac$dags), "í", skra, "\n")
