
library(ggplot2)

# Sömu gögn notuð í báðum gröfum
gogn <- data.frame(
  ar = factor(c("2024", "2025"), levels = c("2024", "2025")),
  anaegja = c(82, 86)
)

# Graf 1: Villandi Y-ás sem byrjar í 80
villandi <- ggplot(gogn, aes(x = ar, y = anaegja)) +
  geom_col(fill = "#C46B55", width = 0.55) +
  geom_text(aes(label = paste0(anaegja, "%")), vjust = -0.5) +
  coord_cartesian(ylim = c(80, 90)) +
  labs(
    title = "Ánægja viðskiptavina",
    x = "Ár",
    y = "Ánægja (%)"
  ) +
  theme_minimal()

ggsave(
  "docs/storytelling/figures/finndu-villuna/villandi-sulurit.png",
  villandi, width = 6, height = 4, dpi = 160
)

# Graf 2: Skýrari Y-ás sem byrjar í 0
skyrt <- ggplot(gogn, aes(x = ar, y = anaegja)) +
  geom_col(fill = "#4084A3", width = 0.55) +
  geom_text(aes(label = paste0(anaegja, "%")), vjust = -0.5) +
  scale_y_continuous(limits = c(0, 100)) +
  labs(
    title = "Ánægja viðskiptavina",
    x = "Ár",
    y = "Ánægja (%)"
  ) +
  theme_minimal()

ggsave(
  "docs/storytelling/figures/finndu-villuna/skyrt-sulurit.png",
  skyrt, width = 6, height = 4, dpi = 160
)

# Graf 3: Bensínverð úr grafi Fox News (fox_gascost.png) með réttum tímaás.
# Tölurnar eru lesnar af upprunalega grafinu; dagar eru miðað við „current“.
bensin <- data.frame(
  dagar = c(-365, -7, 0),
  verd = c(3.17, 3.51, 3.57),
  # Síðustu tveir punktarnir eru viku á milli, svo merkin fara hvort sínum megin
  hjust = c(0.5, 1.15, 0),
  vjust = c(-1, 1.8, -1)
)

timaas <- ggplot(bensin, aes(x = dagar, y = verd)) +
  geom_line(colour = "#4084A3", linewidth = 1) +
  geom_point(colour = "#4084A3", size = 2.5) +
  geom_text(aes(label = sprintf("$%.2f", verd), hjust = hjust, vjust = vjust), size = 3.5) +
  scale_x_continuous(
    breaks = c(-365, -273, -182, -91, 0),
    labels = c("Fyrir ári", "9 mán.", "6 mán.", "3 mán.", "Nú"),
    expand = expansion(mult = c(0.05, 0.1))
  ) +
  scale_y_continuous(limits = c(0, 4), labels = function(x) sprintf("$%.2f", x)) +
  labs(
    title = "Bensínverð, landsmeðaltal",
    x = NULL,
    y = "Verð á gallon"
  ) +
  theme_minimal()

ggsave(
  "docs/storytelling/figures/finndu-villuna/rett-timaas.png",
  timaas, width = 6, height = 4, dpi = 160
)

cat("Gröfin hafa verið vistuð!\n")
