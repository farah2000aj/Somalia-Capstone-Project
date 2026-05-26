##Farah Abdel-Jawad##

#PROJECT: Somalia Capstone Project
#PURPOSE: Visualize willingness to pay taxes to support local government services, broken down by gender. Produces a faceted bar chart with percentage labels
#INPUT: full_contact_weighted.csv  (produced by 02_weighting.do)
#OUTPUT: tax_willing_by_gender.png

  
library(readr)
library(dplyr)
library(ggplot2)
library(scales)
library(stringr)

df <- read_csv("full_contact_weighted.csv")

###Step 1: Summarize tax willingness by gender
df_tax <- df %>%
  filter(!is.na(tax_willing), !is.na(gender)) %>%
  group_by(gender, tax_willing) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(gender) %>%
  mutate(
    percent = count / sum(count),
    label = percent(percent, accuracy = 0.1),
    tax_willing = factor(tax_willing,
                         levels = c("Not willing", "Somewhat willing", "Very willing")),
    gender = factor(gender, levels = c("Female", "Male"))
  )

###Step 2: Plot
ggplot(df_tax, aes(x = tax_willing, y = percent, fill = tax_willing)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(
    aes(label = label),
    vjust = -0.5,
    size = 4,
    fontface = "bold",
    color = "#333333"
  ) +
  
  facet_wrap(~ gender) +
  scale_fill_manual(values = c(
    "Not willing"      = "#E05C5C",
    "Somewhat willing" = "#B0A8A0",
    "Very willing"     = "#4CAF82"
  )) +
  
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    expand = expansion(mult = c(0, 0.12))
  ) +
  
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
  labs(
    title = "How willing are you to pay taxes to support local government services?",
    x = NULL,
    y = NULL
  ) +
  
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "grey90", linewidth = 0.4),
    axis.text.y = element_blank(),
    axis.text.x = element_text(size = 11, color = "#333333"),
    axis.ticks = element_blank(),
    strip.text = element_text(size = 12, color = "grey50"),
    strip.background = element_blank(),
    plot.title = element_text(size = 13.5, face = "bold", lineheight = 1.25),
    plot.margin = margin(25, 40, 25, 40)
  )

ggsave("tax_willing_by_gender.png", width = 8, height = 5, dpi = 300)
