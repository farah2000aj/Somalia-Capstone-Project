##Farah Abdel-Jawad##

#PROJECT: Somalia Capstone Project
#PURPOSE: Visualize the share of respondents reporting each source of financial support (remittances, close family, clan, aid) in the past 12 months. Produces a simple bar chart.
#INPUT: full_contact_weighted.csv  (produced by 02_weighting.do)
#OUTPUT: source_financial_support.png


library(readr)
library(dplyr)
library(ggplot2)
library(scales)

df <- read_csv("full_contact_weighted.csv")

###Step 1: Compute % reporting each support source
support_summary <- data.frame(
  source = c("Remittances", "Close family", "Clan", "Aid"),
  percent = c(
    mean(df$support_rem      == "Yes", na.rm = TRUE),
    mean(df$support_closefam == "Yes", na.rm = TRUE),
    mean(df$support_clan     == "Yes", na.rm = TRUE),
    mean(df$support_aid      == "Yes", na.rm = TRUE)
  )
) %>%
  
  mutate(
    label = percent(percent, accuracy = 0.1),
    source = reorder(source, percent)  # order bars by value
  )

###Step 2: Plot
ggplot(support_summary, aes(x = source, y = percent)) +
  geom_col(fill = "#2C7FB8", width = 0.7) +
  geom_text(aes(label = label), vjust = -0.4, size = 5) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    limits = c(0, max(support_summary$percent) + 0.05)
  ) +
  
  labs(
    title = "Reported Sources of Financial Support",
    subtitle = "Share of respondents reporting each source in the past 12 months",
    x = NULL,
    y = "Percent of respondents",
    caption = "Source: CATI survey data"
  ) +
  
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "grey40"),
    plot.caption = element_text(size = 8, color = "grey50"),
    panel.grid.major.x = element_blank()
  )

ggsave("source_financial_support.png", width = 7, height = 5, dpi = 300)
