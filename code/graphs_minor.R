# Sýnimyndir fyrir docs/storytelling/visuals_minor.qmd (kassarit, punktarit,
# svæðarit, rúðurit og kúlurit). Notar aðeins gögn sem fylgja R, svo skriftan
# keyrir án gagnagrunns. Keyrt úr rót geymslunnar:
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

# Kassarit: sparneytni bíla eftir fjölda strokka
mtcars$cyl_f <- factor(mtcars$cyl)
p_box <- ggplot(mtcars, aes(x = cyl_f, y = mpg)) +
  geom_boxplot(fill = lit, alpha = 0.6, outlier.colour = hi_red, outlier.size = 2.5) +
  labs(title = "Kassarit: sparneytni eftir fjölda strokka",
       x = "Fjöldi strokka", y = "Mílur á gallon (mpg)")
ggsave(file.path(out, "boxplot_example.png"), p_box, width = 6, height = 4, dpi = 200, bg = "white", type = "cairo")

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

# Tengt punktarit: verð á Big Mac í dollurum í tveimur síðustu mælingum, úr
# data/bigmac.db (búið til með code/bigmac_sqlite.R). Punkturinn er nýjasta verðið
# og línan byrjar í verðinu hálfu ári fyrr. Mestu breytingarnar eru appelsínugular.
con <- DBI::dbConnect(RSQLite::SQLite(), "data/bigmac.db")
dags <- DBI::dbGetQuery(con, "SELECT DISTINCT dags FROM bigmac ORDER BY dags DESC LIMIT 2")$dags
bm <- DBI::dbGetQuery(con, "
  SELECT n.land, f.verd_usd AS fyrr, n.verd_usd AS nu
  FROM bigmac n JOIN bigmac f ON f.iso = n.iso AND f.dags = ?
  WHERE n.dags = ?", params = list(dags[2], dags[1]))
DBI::dbDisconnect(con)
bm$breyting <- bm$nu - bm$fyrr
bm$mest <- rank(-abs(bm$breyting)) <= 5
bm$land <- reorder(bm$land, bm$nu)
p_dot_tengt <- ggplot(bm, aes(y = land)) +
  geom_segment(aes(x = fyrr, xend = nu, yend = land, colour = mest), linewidth = 0.8) +
  geom_point(aes(x = nu, colour = mest), size = 1.8) +
  scale_colour_manual(values = c(`FALSE` = hi_blue, `TRUE` = hi_orange), guide = "none") +
  scale_x_continuous(labels = function(x) paste0("$", trimws(format(x, decimal.mark = ",")))) +
  labs(title = "Verð á Big Mac í dollurum",
       subtitle = paste0("Punktur: ", dags[1], ". Lína byrjar í verðinu ", dags[2],
                         ". Fimm mestu breytingarnar eru appelsínugular."),
       x = NULL, y = NULL, caption = "Heimild: The Economist, Big Mac-vísitalan") +
  theme(axis.text.y = element_text(size = 7), plot.subtitle = element_text(size = 9))
ggsave(file.path(out, "dotplot_connected.png"), p_dot_tengt, width = 7, height = 9, dpi = 200, bg = "white", type = "cairo")

# Svæðarit: atvinnulausir í Bandaríkjunum yfir tíma
p_area <- ggplot(economics, aes(x = date, y = unemploy / 1000)) +
  geom_area(fill = lit, alpha = 0.6) +
  geom_line(colour = lit) +
  labs(title = "Svæðarit: fjöldi atvinnulausra í Bandaríkjunum",
       x = NULL, y = "Milljónir manna")
ggsave(file.path(out, "areagraph_example.png"), p_area, width = 6, height = 4, dpi = 200, bg = "white", type = "cairo")

# Rúðurit (vöfflurit): ein rúða fyrir hvern bíl í mtcars, flokkað eftir strokkafjölda.
# Netið er 8 dálkar á breidd svo allar rúður passa (32 bílar = 8 x 4).
breidd <- 8
flokkar <- paste(sort(mtcars$cyl), "strokkar")
net <- data.frame(
  x = (seq_along(flokkar) - 1) %% breidd + 1,
  y = -((seq_along(flokkar) - 1) %/% breidd),
  flokkur = flokkar
)
p_waffle <- ggplot(net, aes(x, y, fill = flokkur)) +
  geom_tile(colour = "white", linewidth = 1) +
  scale_fill_manual(values = c(hi_blue, hi_orange, hi_teal), name = NULL) +
  coord_equal() +
  theme_void(base_size = 12) +
  labs(title = "Rúðurit: bílar eftir fjölda strokka",
       subtitle = "Hver rúða er einn bíll") +
  theme(plot.margin = margin(10, 20, 10, 20))
ggsave(file.path(out, "waffle_example.png"), p_waffle, width = 6, height = 4, dpi = 200, bg = "white", type = "cairo")

# Kúlurit: þyngd, sparneytni og afl (stærð kúlu)
p_bubble <- ggplot(mtcars, aes(x = wt, y = mpg, size = hp)) +
  geom_point(colour = lit, alpha = 0.55) +
  scale_size_area(max_size = 12, name = "Hestöfl") +
  labs(title = "Kúlurit: þyngd, sparneytni og afl",
       x = "Þyngd (1000 pund)", y = "Mílur á gallon (mpg)")
ggsave(file.path(out, "bubblechart_example.png"), p_bubble, width = 6, height = 4, dpi = 200, bg = "white", type = "cairo")
