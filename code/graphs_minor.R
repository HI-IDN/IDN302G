# Sýnimyndir fyrir docs/storytelling/visuals_minor.qmd (kassarit, punktarit,
# svæðarit, rúðurit og kúlurit). Notar aðeins gögn sem fylgja R, svo skriftan
# keyrir án nettengingar (Big Mac-dæmið les data/bigmac.db). Keyrt úr rót geymslunnar:
#   Rscript code/graphs_minor.R

library(ggplot2)
library(dplyr)

Sys.setlocale("LC_ALL", "en_US.UTF-8")

out <- "docs/storytelling/figures"
theme_set(theme_minimal(base_size = 12))
# Litir úr HÍ-pallettunni í docs/styles/hi-book.scss
hi_blue   <- "#10099F"
hi_orange <- "#FFA05F"
hi_teal   <- "#2DD2C0"
hi_red    <- "#FC8484"
lit <- hi_blue

# Kassarit og afbrigði: sparneytni bíla eftir fjölda strokka, sömu gögn í öllum fjórum
mtcars$cyl_f <- factor(mtcars$cyl)
kassi <- function(titill) {
  labs(title = titill, x = "Fjöldi strokka", y = "Mílur á gallon (mpg)")
}
vista <- function(p, nafn) {
  ggsave(file.path(out, nafn), p, width = 6, height = 4, dpi = 200, bg = "white", type = "cairo")
}

p_box <- ggplot(mtcars, aes(x = cyl_f, y = mpg)) +
  geom_boxplot(fill = lit, alpha = 0.6, outlier.colour = hi_red, outlier.size = 2.5) +
  kassi("Kassarit")
vista(p_box, "boxplot_example.png")

# Breytibreitt: breidd kassans fylgir kvaðratrót af fjölda í hópnum
p_box_breidd <- ggplot(mtcars, aes(x = cyl_f, y = mpg)) +
  geom_boxplot(varwidth = TRUE, fill = lit, alpha = 0.6, outlier.colour = hi_red, outlier.size = 2.5) +
  kassi("Breytibreitt kassarit: breiddin sýnir fjölda bíla")
vista(p_box_breidd, "boxplot_varwidth.png")

# Með skörðum: skarðið er um það bil 95% öryggisbil fyrir miðgildið
p_box_skard <- ggplot(mtcars, aes(x = cyl_f, y = mpg)) +
  geom_boxplot(notch = TRUE, fill = lit, alpha = 0.6, outlier.colour = hi_red, outlier.size = 2.5) +
  kassi("Kassarit með skörðum: öryggisbil um miðgildið")
vista(p_box_skard, "boxplot_notched.png")

# Fiðlurit: þéttleiki dreifingarinnar, með mjóu kassariti inni í
p_fidla <- ggplot(mtcars, aes(x = cyl_f, y = mpg)) +
  geom_violin(fill = lit, alpha = 0.35, colour = lit) +
  geom_boxplot(width = 0.12, fill = "white", outlier.colour = hi_red, outlier.size = 2) +
  kassi("Fiðlurit: lögun dreifingarinnar")
vista(p_fidla, "boxplot_violin.png")

# Punktarit (Cleveland): bílar raðaðir eftir sparneytni
bilar <- mtcars |> tibble::rownames_to_column("bill") |> slice_max(mpg, n = 12)
p_dot <- ggplot(bilar, aes(x = mpg, y = reorder(bill, mpg))) +
  geom_segment(aes(x = 0, xend = mpg, yend = bill), colour = lit, linewidth = 0.8) +
  geom_point(colour = lit, size = 3) +
  labs(title = "Punktarit: 12 sparneytnustu bílarnir",
       x = "Mílur á gallon (mpg)", y = NULL)
ggsave(file.path(out, "dotplot_example.png"), p_dot, width = 6, height = 4, dpi = 200, bg = "white", type = "cairo")

# Hefðbundið punktarit: dreifing sparneytni, einn punktur fyrir hvern bíl
p_dot_dreif <- ggplot(mtcars, aes(x = mpg)) +
  geom_dotplot(binwidth = 1, method = "histodot", fill = lit, colour = lit) +
  scale_y_continuous(NULL, breaks = NULL) +
  labs(title = "Hefðbundið punktarit: dreifing sparneytni",
       subtitle = "Hver punktur er einn bíll",
       x = "Mílur á gallon (mpg)")
ggsave(file.path(out, "dotplot_distribution.png"), p_dot_dreif, width = 6, height = 3, dpi = 200, bg = "white", type = "cairo")

# Tengt punktarit: meðalsparneytni sjálfskiptra og beinskiptra bíla eftir strokkafjölda.
# Línan milli punktanna dregur augað að muninum á skiptingunum.
medal <- aggregate(mpg ~ cyl + am, data = mtcars, FUN = mean)
medal$skipting <- ifelse(medal$am == 1, "Beinskiptur", "Sjálfskiptur")
medal$cyl_f <- factor(paste(medal$cyl, "strokkar"), levels = paste(c(8, 6, 4), "strokkar"))
bil <- merge(subset(medal, am == 0, c(cyl_f, mpg)), subset(medal, am == 1, c(cyl_f, mpg)),
             by = "cyl_f", suffixes = c("_sjalf", "_bein"))
p_dot_tengt <- ggplot(medal, aes(x = mpg, y = cyl_f)) +
  geom_segment(data = bil, aes(x = mpg_sjalf, xend = mpg_bein, y = cyl_f, yend = cyl_f),
               colour = "grey75", linewidth = 3) +
  geom_point(aes(colour = skipting), size = 5) +
  scale_colour_manual(values = c(Beinskiptur = hi_blue, Sjálfskiptur = hi_orange), name = NULL) +
  labs(title = "Tengt punktarit: meðalsparneytni eftir skiptingu",
       x = "Mílur á gallon (mpg)", y = NULL) +
  theme(legend.position = "top")
vista(p_dot_tengt, "dotplot_connected.png")

# Stærra dæmi: verð á Big Mac í dollurum í tveimur síðustu mælingum, úr data/bigmac.db
# (sótt með code/bigmac_sqlite.R). Línan byrjar í fyrra verðinu og punkturinn er nýja
# verðið. Appelsínugult þar sem verðið hækkaði.
manudir <- c("janúar", "febrúar", "mars", "apríl", "maí", "júní", "júlí", "ágúst",
             "september", "október", "nóvember", "desember")
manudur <- function(d) paste(manudir[as.integer(substr(d, 6, 7))], substr(d, 1, 4))
con <- DBI::dbConnect(RSQLite::SQLite(), "data/bigmac.db")
dags <- DBI::dbGetQuery(con, "SELECT DISTINCT dags FROM bigmac ORDER BY dags DESC LIMIT 2")$dags
bm <- DBI::dbGetQuery(con, "
  SELECT n.land, f.verd_usd AS fyrr, n.verd_usd AS nu
  FROM bigmac n JOIN bigmac f ON f.iso = n.iso AND f.dags = ?
  WHERE n.dags = ?", params = list(dags[2], dags[1]))
DBI::dbDisconnect(con)
bm$haekkun <- bm$nu > bm$fyrr
bm$land <- reorder(bm$land, bm$nu)
# Orðið „hækkað“ er appelsínugult í titlinum, svo ekki þarf sérstaka litaskýringu.
# Titillinn er teiknaður tvisvar ofan í sjálfan sig: einu sinni svartur þar sem orðið
# er ósýnilegt (phantom) og einu sinni appelsínugulur þar sem aðeins orðið sést.
titill_fyrir <- "Hvar hefur verð á Big Mac "
titill_eftir <- paste0(" (í dollurum) frá ", manudur(dags[2]), " til ", manudur(dags[1]), "?")
titill_svartur <- bquote(.(titill_fyrir) * phantom("hækkað") * .(titill_eftir))
titill_appels  <- bquote(phantom(.(titill_fyrir)) * "hækkað" * phantom(.(titill_eftir)))
p_bigmac <- ggplot(bm, aes(y = land)) +
  geom_segment(aes(x = fyrr, xend = nu, yend = land, colour = haekkun), linewidth = 1.3) +
  geom_point(aes(x = nu, colour = haekkun), size = 2.6) +
  scale_colour_manual(values = c(`FALSE` = hi_blue, `TRUE` = hi_orange), guide = "none") +
  scale_x_continuous(labels = function(x) paste0("$", trimws(format(x, decimal.mark = ",")))) +
  labs(title = titill_svartur,
       subtitle = paste0("Punkturinn er verðið í ", manudur(dags[1]),
                         ", línan byrjar í verðinu í ", manudur(dags[2]), "."),
       x = "Verð í dollurum", y = NULL,
       caption = paste0("Heimild: The Economist, Big Mac-vísitalan. Sótt af ",
                        "raw.githubusercontent.com/TheEconomist/big-mac-data/",
                        "master/output-data/big-mac-raw-index.csv")) +
  theme(axis.text.y = element_text(size = 7), plot.subtitle = element_text(size = 9),
        plot.caption = element_text(size = 7, hjust = 0), plot.caption.position = "plot",
        plot.title.position = "plot", plot.title = element_text(size = 12.5))
g_bigmac <- ggplotGrob(p_bigmac)
nr <- which(g_bigmac$layout$name == "title")
svartur <- g_bigmac$grobs[[nr]]
appels <- svartur
appels$name <- paste0(svartur$name, "-appels")  # grobTree hendir grobum með sama nafni
appels$children[[1]]$label <- titill_appels
appels$children[[1]]$gp$col <- hi_orange
g_bigmac$grobs[[nr]] <- grid::grobTree(svartur, appels)
ggsave(file.path(out, "dotplot_bigmac.png"), g_bigmac, width = 7.5, height = 9, dpi = 200, bg = "white", type = "cairo")

# Svæðarit: atvinnulausir í Bandaríkjunum yfir tíma
p_area <- ggplot(economics, aes(x = date, y = unemploy / 1000)) +
  geom_area(fill = lit, alpha = 0.6) +
  geom_line(colour = lit) +
  labs(title = "Svæðarit: fjöldi atvinnulausra í Bandaríkjunum",
       x = NULL, y = "Milljónir manna")
ggsave(file.path(out, "areagraph_example.png"), p_area, width = 6, height = 4, dpi = 200, bg = "white", type = "cairo")

# Rúðurit (vöfflurit): 10x10 net þar sem hver rúða er 1% af bílunum, eftir strokkafjölda.
# Prósentur eru námundaðar svo þær leggist saman í 100.
hlutf <- round(prop.table(table(mtcars$cyl)) * 100)
hlutf[length(hlutf)] <- 100 - sum(hlutf[-length(hlutf)])
merki <- paste0(names(hlutf), " strokkar: ", hlutf, "%")
net <- expand.grid(x = 1:10, y = 10:1)
net$flokkur <- factor(rep(merki, times = hlutf), levels = merki)
p_waffle <- ggplot(net, aes(x, y, fill = flokkur)) +
  geom_tile(colour = "white", linewidth = 1) +
  scale_fill_manual(values = c(hi_blue, hi_orange, hi_teal), name = NULL) +
  coord_equal() +
  theme_void(base_size = 12) +
  labs(title = "Rúðurit: bílar eftir fjölda strokka",
       subtitle = "Hver rúða er 1% af bílunum") +
  theme(plot.margin = margin(10, 20, 10, 20))
vista(p_waffle, "waffle_example.png")

# Kúlurit í þremur skrefum: þyngd (x), sparneytni (y) og hestöfl (stærð kúlu),
# svo fjöldi strokka sem litur, og loks merkingar á nokkra bíla sem segja söguna.
kula <- function(p, titill) {
  p + scale_size_area(max_size = 12, name = "Hestöfl") +
    labs(title = titill, x = "Þyngd (1000 pund)", y = "Mílur á gallon (mpg)")
}
p_bubble <- kula(ggplot(mtcars, aes(x = wt, y = mpg, size = hp)) +
                   geom_point(colour = lit, alpha = 0.55),
                 "Kúlurit: þyngd, sparneytni og afl")
vista(p_bubble, "bubblechart_example.png")

strokkar_lit <- scale_colour_manual(values = c(`4` = hi_teal, `6` = hi_orange, `8` = hi_blue),
                                    name = "Strokkar")
p_bubble_lit <- kula(ggplot(mtcars, aes(x = wt, y = mpg, size = hp, colour = cyl_f)) +
                       geom_point(alpha = 0.7) + strokkar_lit,
                     "Kúlurit með lit: fjöldi strokka sem fjórða breyta")
vista(p_bubble_lit, "bubblechart_colour.png")

# Merkjum aðeins jaðarbílana: sparneytnasta, aflmesta og þyngsta
bilar_allir <- tibble::rownames_to_column(mtcars, "bill")
merktir <- bilar_allir[unique(c(which.max(bilar_allir$mpg), which.max(bilar_allir$hp),
                                which.max(bilar_allir$wt))), ]
p_bubble_merki <- kula(ggplot(bilar_allir, aes(x = wt, y = mpg, size = hp, colour = cyl_f)) +
                         geom_point(alpha = 0.7) + strokkar_lit +
                         ggrepel::geom_text_repel(data = merktir, aes(label = bill), size = 3.5,
                                                  colour = "grey20", show.legend = FALSE,
                                                  box.padding = 0.8, min.segment.length = 0),
                       "Kúlurit með merkingum: jaðarbílarnir nefndir")
vista(p_bubble_merki, "bubblechart_labels.png")
