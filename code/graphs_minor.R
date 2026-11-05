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
ggsave(file.path(out, "dotplot_connected.png"), p_dot_tengt, width = 6, height = 4, dpi = 200, bg = "white", type = "cairo")

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
