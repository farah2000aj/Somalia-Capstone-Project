##Farah Abdel-Jawad##

#PROJECT: Somalia Capstone Project
#PURPOSE: Visualize which factors respondents believe influence whether a clan member would receive financial support from their subclan. Produces a horizontal bar chart ordered from most to least cited.
#INPUT: full_contact_weighted.csv  (produced by 02_weighting.do)
#OUTPUT: factors_clan_support.png

library(readr)
library(dplyr)
library(ggplot2)
library(scales)

df <- read_csv("full_contact_weighted.csv")

###Step 1: Compute % of respondents citing each factor as important
factors_summary <- data.frame(
  factor = c("Subclan membership", "Personal connection", "Level of need",
             "Severity of situation", "Funds available", "Age", "Gender"),
  percent = c(
    mean(df$csupp_subclan   == "Yes", na.rm = TRUE),
    mean(df$csupp_connection == "Yes", na.rm = TRUE),
    mean(df$csupp_need      == "Yes", na.rm = TRUE),
    mean(df$csupp_severity  == "Yes", na.rm = TRUE),
    mean(df$csupp_fundsavail == "Yes", na.rm = TRUE),
    mean(df$csupp_age       == "Yes", na.rm = TRUE),
    mean(df$csupp_gender    == "Yes", na.rm = TRUE)
  )
) %>%
  arrange(desc(percent)) %>%
  mutate(label = percent(percent, accuracy = 0.1))

###Step 2: Plot
ggplot(factors_summary, aes(x = reorder(factor, percent), y = percent)) +
  geom_col(fill = "lightblue") +
  geom_text(aes(label = label), hjust = -0.2, size = 5) +
  coord_flip() +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    limits = c(0, max(factors_summary$percent) + 0.1)
  ) +
  
  labs(
    title = "Other than severity and depth of need, what other factors\ncould influence the clan's financial support?",
    x = NULL,
    y = "% of respondents who identified each factor as important",
    caption = "Survey question asked respondents to select all factors that apply."
  ) +
  
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 13, lineheight = 1.3),
    plot.caption = element_text(size = 8, color = "grey50"),
    axis.text.y = element_text(size = 11)
  )

ggsave("factors_clan_support.png", width = 9, height = 5, dpi = 300)
