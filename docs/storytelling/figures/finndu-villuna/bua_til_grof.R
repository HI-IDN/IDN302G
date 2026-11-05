
library(ggplot2)

# Litur úr HÍ-pallettunni í styles/hi-book.scss ($hi-blue)
hi_blue <- "#10099F"

# Íslensk tugabrot: $3,17
dollarar <- function(x) paste0("$", formatC(x, format = "f", digits = 2, decimal.mark = ","))

# Sömu gögn notuð í báðum gröfum
gogn <- data.frame(
  ar = factor(c("2024", "2025"), levels = c("2024", "2025")),
  anaegja = c(82, 86)
)

# Graf 1: Villandi Y-ás sem byrjar í 80
villandi <- ggplot(gogn, aes(x = ar, y = anaegja)) +
  geom_col(fill = hi_blue, width = 0.55) +
  geom_text(aes(label = paste0(anaegja, "%")), vjust = -0.5) +
  coord_cartesian(ylim = c(80, 90)) +
  scale_y_continuous(labels = function(x) format(x, decimal.mark = ",")) +
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
  geom_col(fill = hi_blue, width = 0.55) +
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
  geom_line(colour = hi_blue, linewidth = 1) +
  geom_point(colour = hi_blue, size = 2.5) +
  geom_text(aes(label = dollarar(verd), hjust = hjust, vjust = vjust), size = 3.5) +
  scale_x_continuous(
    breaks = c(-365, -273, -182, -91, 0),
    labels = c("Fyrir ári", "9 mán.", "6 mán.", "3 mán.", "Nú"),
    expand = expansion(mult = c(0.05, 0.1))
  ) +
  scale_y_continuous(limits = c(0, 4), labels = dollarar) +
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

# Graf 4: Kennitölur úr ársreikningi Strætó 2021 (straeto_arsreikningur2021.png),
# nú með árunum í tímaröð frá vinstri til hægri. Tölurnar eru lesnar af upprunalegu gröfunum.
straeto <- data.frame(
  ar = rep(2017:2021, 4),
  kennitala = rep(c("Eiginfjárhlutfall", "Veltufjárhlutfall",
                    "Vægi fargjaldatekna í rekstrarkostnaði", "Langtímaskuldir / eigið fé"),
                  each = 5),
  gildi = c(64, 49, 47, 40, 26,
            1.3, 0.9, 1.2, 0.8, 0.7,
            36, 34, 35, 25, 25,
            0, 56.3, 57.7, 77.8, 148.8),
  prosenta = rep(c(TRUE, FALSE, TRUE, TRUE), each = 5),
  # Sama gerð af grafi og í ársreikningnum, svo eina breytingin er röð áranna
  sulur = rep(c(FALSE, TRUE, TRUE, FALSE), each = 5)
)
straeto$kennitala <- factor(straeto$kennitala, levels = unique(straeto$kennitala))
straeto$merki <- ifelse(
  straeto$prosenta,
  paste0(formatC(straeto$gildi, format = "fg", decimal.mark = ","), "%"),
  formatC(straeto$gildi, format = "f", digits = 1, decimal.mark = ",")
)

rod <- ggplot(straeto, aes(x = ar, y = gildi)) +
  geom_col(data = subset(straeto, sulur), fill = hi_blue, width = 0.55) +
  geom_line(data = subset(straeto, !sulur), colour = hi_blue, linewidth = 1) +
  geom_point(data = subset(straeto, !sulur), colour = hi_blue, size = 2) +
  geom_text(aes(label = merki), vjust = -0.9, size = 3) +
  facet_wrap(~kennitala, scales = "free_y", ncol = 2) +
  scale_x_continuous(expand = expansion(add = 0.4)) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.25)), limits = c(0, NA),
                     labels = function(x) format(x, decimal.mark = ",")) +
  labs(title = "Strætó: kennitölur 2017–2021", x = NULL, y = NULL) +
  theme_minimal()

ggsave(
  "docs/storytelling/figures/finndu-villuna/straeto-timarod.png",
  rod, width = 8, height = 5.5, dpi = 160
)

# Graf 5: Sömu kennitölur, allar sem línurit. Þær sýna allar þróun yfir tíma,
# og línurit leggur áherslu á breytinguna milli ára.
linur <- ggplot(straeto, aes(x = ar, y = gildi)) +
  geom_line(colour = hi_blue, linewidth = 1) +
  geom_point(colour = hi_blue, size = 2) +
  geom_text(aes(label = merki), vjust = -0.9, size = 3) +
  facet_wrap(~kennitala, scales = "free_y", ncol = 2) +
  scale_x_continuous(expand = expansion(add = 0.4)) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.25)), limits = c(0, NA),
                     labels = function(x) format(x, decimal.mark = ",")) +
  labs(title = "Strætó: kennitölur 2017–2021", x = NULL, y = NULL) +
  theme_minimal()

ggsave(
  "docs/storytelling/figures/finndu-villuna/straeto-linurit.png",
  linur, width = 8, height = 5.5, dpi = 160
)

cat("Gröfin hafa verið vistuð!\n")
