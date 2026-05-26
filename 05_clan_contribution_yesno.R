##Farah Abdel-Jawad##

#PROJECT: Somalia Capstone Project
#PURPOSE: Visualize the share of respondents who report being asked by clan elders to make regular financial contributions to the clan. Simple horizontal yes/no bar chart.
#INPUT: full_contact_weighted.csv  (produced by 02_weighting.do)
#OUTPUT: clan_tax_yesno.png


library(readr)
library(dplyr)
library(ggplot2)
library(scales)

df <- read_csv("full_contact_weighted.csv")

###Step 1: Summarize yes/no responses
df_clan <- df %>%
  filter(!is.na(clan_tax)) %>%
  count(clan_tax) %>%
  mutate(
    percent = n / sum(n),
    clan_tax = factor(clan_tax, levels = c("Yes", "No")),
    label = percent(percent, accuracy = 0.1)
  )

N_base <- sum(df_clan$n)

###Step 2: Plot
ggplot(df_clan, aes(x = percent, y = clan_tax, fill = clan_tax)) +
  geom_col(width = 0.85, show.legend = FALSE) +
  geom_text(
    aes(label = label),
    hjust = -0.15,
    size = 4.5,
    fontface = "bold",
    color = "#333333"
  ) +
  
  scale_fill_manual(values = c("Yes" = "#4CAF82", "No" = "#E05C5C")) +
  scale_x_continuous(
    limits = c(0, 1.05),
    expand = expansion(mult = c(0, 0))
  ) +
  
  labs(
    title = "Do your clan elders ask you to make regular\nfinancial contributions to the clan?",
    subtitle = paste0("N=", N_base, " respondents (excluding non-response)"),
    x = NULL, y = NULL
  ) +
  
  theme_minimal(base_size = 13) +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(size = 13, face = "bold", color = "#333333"),
    axis.ticks = element_blank(),
    plot.title = element_text(size = 14, face = "bold", lineheight = 1.25),
    plot.subtitle = element_text(size = 10, face = "italic", color = "grey55",
                                 margin = margin(t = 3, b = 12)),
    plot.margin = margin(25, 60, 25, 30)
  )

ggsave("clan_tax_yesno.png", width = 8, height = 2.2, dpi = 300)
