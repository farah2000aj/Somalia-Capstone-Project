##Farah Abdel-Jawad##

#PROJECT: Somalia Capstone Project
#PURPOSE: Among respondents who reported being asked by clan elders to contribute financially (~30% of sample), visualize how frequently they contribute, broken down by gender.
#INPUT: full_contact_weighted.csv  (produced by 02_weighting.do)
#OUTPUT: clan_tax_freq_by_gender.png


library(readr)
library(dplyr)
library(ggplot2)
library(scales)
library(stringr)

df <- read_csv("full_contact_weighted.csv")

###Step 1: Filter to respondents asked to contribute; exclude non-response
df_asked <- df %>%
  filter(!is.na(clan_tax_freq), !is.na(gender)) %>%
  filter(!grepl("^\\s*NA$|^N/A$", clan_tax_freq))

N_total <- nrow(df_asked)

df_clean <- df_asked %>%
  filter(!grepl("know|refused", clan_tax_freq, ignore.case = TRUE)) %>%
  mutate(
    gender = factor(gender, levels = c("Male", "Female")),
    clan_tax_freq = factor(
      clan_tax_freq,
      levels = c(
        "More than once per month",
        "Once every month",
        "Once every 2 months",
        "Once every 3 months",
        "Once every 6 months",
        "Once every 12 months",
        "As need arises"
      )
    )
  ) %>%
  filter(!is.na(clan_tax_freq))

###Step 2: Summarize by frequency and gender
freq_gender <- df_clean %>%
  group_by(clan_tax_freq, gender) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(percent = count / N_total)

freq_totals <- freq_gender %>%
  group_by(clan_tax_freq) %>%
  summarise(total_percent = sum(percent), .groups = "drop") %>%
  mutate(total_label = percent(total_percent, accuracy = 1))

###Step 3: Wrap x-axis labels
wrap_levels <- str_wrap(levels(df_clean$clan_tax_freq), width = 14)

freq_gender <- freq_gender %>%
  mutate(clan_tax_freq_label = factor(
    str_wrap(as.character(clan_tax_freq), width = 14), levels = wrap_levels
  ))

freq_totals <- freq_totals %>%
  mutate(clan_tax_freq_label = factor(
    str_wrap(as.character(clan_tax_freq), width = 14), levels = wrap_levels
  ))

###Step 4: 
ggplot(freq_gender, aes(x = clan_tax_freq_label, y = percent, fill = gender)) +
  geom_col(width = 0.68, color = "white", linewidth = 0.4) +
  geom_text(
    aes(label = ifelse(percent >= 0.04, percent(percent, accuracy = 1), "")),
    position = position_stack(vjust = 0.5),
    size = 3.8, color = "white", fontface = "italic"
  ) +
  
  geom_text(
    data = freq_totals,
    aes(x = clan_tax_freq_label, y = total_percent, label = total_label),
    inherit.aes = FALSE,
    vjust = -0.5, size = 4.0, color = "#333333", fontface = "bold"
  ) +
  
  scale_fill_manual(values = c("Male" = "#89C4D4", "Female" = "#F4A7B9")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Of the 30% asked by clan elders to contribute financially,\nhow frequently do they contribute?",
    subtitle = paste0("N=", N_total, " of 882 total respondents"),
    x = NULL, y = NULL, fill = NULL
  ) +
  
  theme_minimal(base_size = 13) +
  theme(
    panel.grid = element_blank(),
    axis.ticks = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_text(size = 10.5, angle = 30, hjust = 1,
                               lineheight = 0.95, face = "bold", color = "#222222"),
    legend.position = "right",
    legend.text = element_text(size = 10),
    plot.title = element_text(size = 13.5, face = "bold", lineheight = 1.2),
    plot.subtitle = element_text(size = 10, face = "italic", color = "grey50",
                                 margin = margin(t = 3, b = 10)),
    plot.margin = margin(30, 40, 30, 40)
  )

ggsave("clan_tax_freq_by_gender.png", width = 9, height = 6, dpi = 300)
