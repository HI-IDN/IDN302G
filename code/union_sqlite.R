# Býr til litla SQLite-grunninn fyrir UNION-dæmið úr tilbúnum gögnum.
# Keyrið úr rót geymslunnar: Rscript code/union_sqlite.R
# Grunnurinn er vistaður með námsefninu svo ekki þurfi að keyra uppsetninguna
# við lestur glósanna. Endurkeyrsla endurstillir aðeins þessar tvær töflur.

if (.Platform$OS.type == "windows") {
  invisible(Sys.setlocale("LC_CTYPE", ".UTF-8"))
}

local({
  con <- DBI::dbConnect(RSQLite::SQLite(), "data/union.db")
  on.exit(DBI::dbDisconnect(con))
  DBI::dbWithTransaction(con, {
    for (tafla in c("sala_midbaer", "sala_kringlan")) {
      DBI::dbExecute(con, paste("DROP TABLE IF EXISTS", tafla))
      DBI::dbExecute(con, paste("CREATE TABLE", tafla,
        "(solunr INTEGER PRIMARY KEY, vara TEXT, upphaed INTEGER)"))
    }
    DBI::dbExecute(con, "INSERT INTO sala_midbaer VALUES
      (101, 'Kaffi', 600), (102, 'Te', 450)")
    DBI::dbExecute(con, "INSERT INTO sala_kringlan VALUES
      (201, 'Kaffi', 600), (202, 'Kakó', 700)")
  })
})
