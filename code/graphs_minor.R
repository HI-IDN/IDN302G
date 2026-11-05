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
ggsave(file.path(out, "boxplot_example.png"), p_box, width = 6, height = 4, dpi = 120, bg = "white", type = "cairo")

# Punktarit (Cleveland): bílar raðaðir eftir sparneytni
bilar <- mtcars |> tibble::rownames_to_column("bill") |> slice_max(mpg, n = 12)
p_dot <- ggplot(bilar, aes(x = mpg, y = reorder(bill, mpg))) +
  geom_segment(aes(x = 0, xend = mpg, yend = bill), colour = "grey80") +
  geom_point(colour = lit, size = 3) +
  labs(title = "Punktarit: 12 sparneytnustu bílarnir",
       x = "Mílur á gallon (mpg)", y = NULL)
ggsave(file.path(out, "dotplot_example.png"), p_dot, width = 6, height = 4, dpi = 120, bg = "white", type = "cairo")

# Svæðarit: atvinnulausir í Bandaríkjunum yfir tíma
p_area <- ggplot(economics, aes(x = date, y = unemploy / 1000)) +
  geom_area(fill = lit, alpha = 0.6) +
  geom_line(colour = lit) +
  labs(title = "Svæðarit: fjöldi atvinnulausra í Bandaríkjunum",
       x = NULL, y = "Milljónir manna")
ggsave(file.path(out, "areagraph_example.png"), p_area, width = 6, height = 4, dpi = 120, bg = "white", type = "cairo")

# Rúðurit (vöfflurit): 10x10 net, 32 bílar flokkaðir eftir strokkafjölda,
# hver rúða er um 1% af heildinni
hlutf <- round(prop.table(table(mtcars$cyl)) * 100)
hlutf[length(hlutf)] <- 100 - sum(hlutf[-length(hlutf)])
flokkar <- rep(paste(names(hlutf), "strokkar"), times = hlutf)
net <- expand.grid(x = 1:10, y = 10:1)
net$flokkur <- flokkar
p_waffle <- ggplot(net, aes(x, y, fill = flokkur)) +
  geom_tile(colour = "white", linewidth = 1) +
  scale_fill_manual(values = c(hi_blue, hi_orange, hi_teal), name = NULL) +
  coord_equal() +
  theme_void(base_size = 12) +
  labs(title = "Rúðurit: hlutfall bíla eftir fjölda strokka",
       subtitle = "Hver rúða er um 1% af bílunum")
ggsave(file.path(out, "waffle_example.png"), p_waffle, width = 6, height = 4, dpi = 120, bg = "white", type = "cairo")

# Kúlurit: þyngd, sparneytni og afl (stærð kúlu)
p_bubble <- ggplot(mtcars, aes(x = wt, y = mpg, size = hp)) +
  geom_point(colour = lit, alpha = 0.55) +
  scale_size_area(max_size = 12, name = "Hestöfl") +
  labs(title = "Kúlurit: þyngd, sparneytni og afl",
       x = "Þyngd (1000 pund)", y = "Mílur á gallon (mpg)")
ggsave(file.path(out, "bubblechart_example.png"), p_bubble, width = 6, height = 4, dpi = 120, bg = "white", type = "cairo")
