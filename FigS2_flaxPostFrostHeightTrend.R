library(ggplot2)
library(viridis) # For colorblind-friendly palette
library(dplyr)

# Set working directory
setwd("/mmfs1/projects/brent.hulke/LewisFlax/FlaxFrostTolerance/")

# Load data
data <- read.csv("flaxPostFrostHeightTrendNoLessThanSigns.csv", sep = ",")

# Clean the data and summarize
# Including p-value columns in the grouping and summarising
data_clean <- data %>%
  # Figure: 6, 21, 27, 38
  # Supp1: 1, 2, 3, 4, 5, 7
  # Supp2: 8, 9, 10, 11, 12, 13
  # Supp3: 14, 15, 16, 17, 18, 19
  # Supp4: 20, 22, 23, 24, 25, 26
  # Supp5: 29, 30, 31, 32, 33, 34
  # Supp6: 35, 36, 37, 39, 40, 41
  # Supp7: 42, 43, 44, 45 <-15.33cm height unlike others
  filter(Sample_Number %in% c(1, 2, 3, 4, 5, 7)) %>%
  group_by(Sample_Number, Time, treat, Accession, treatmentP, timeP, treatmentXtimeP) %>%
  summarise(Height = mean(Total_HeightRegBrady, na.rm = TRUE), .groups = 'keep')

# Convert 'treat' to a factor and ensure it has the correct levels
data_clean$treat <- factor(data_clean$treat, levels = unique(data_clean$treat))

# Order the levels of 'treat' for the legend
levels_ordered <- rev(levels(data_clean$treat))

# Function to format p-values
format_p_value <- function(p) {
  if (is.na(p)) {
    return(NA)
  } else if (p < 0.01) {
    return("< 0.01")
  } else {
    return(paste0("= ", formatC(round(p, digits = 2), format = "f", digits = 2)))
  }
}

# Apply the formatting function to p-value columns
data_clean <- data_clean %>%
  mutate(
    formatted_treatmentP = sapply(treatmentP, format_p_value),
    formatted_timeP = sapply(timeP, format_p_value),
    formatted_treatmentXtimeP = sapply(treatmentXtimeP, format_p_value)
  )

# Generate the plot with the correct legend order and formatted p-values
ggplot(data_clean, aes(x = Time, y = Height, group = interaction(Accession, treat), color = treat)) +
  geom_line(size = 1) +
  scale_color_viridis(discrete = TRUE, breaks = levels_ordered) +
  scale_y_continuous(limits = c(NA, 200)) + # Extend y-axis range
  facet_wrap(~ Accession, scales = 'fixed', ncol = 2) +
  theme_minimal(base_size = 14) +
  labs(x = "Time (weeks)", y = "Height (cm)", color = "Treatment (°C)") +
  theme(legend.position = "bottom") +
  # Adding the annotations directly with formatted p-values
  geom_label(aes(label=paste0("Trt. p ", formatted_treatmentP, 
                             ", Time p ", formatted_timeP, 
                             ", Trt.*Time p ", formatted_treatmentXtimeP)), 
            x=Inf, y=Inf, hjust=1.07, vjust=1.05, size=3, fontface="italic", show.legend = FALSE, color = "black", fill = "white")

# Save the plot as an image file, if desired
ggsave("Supp1_PostFrostHeightByAccession_17x23cm_600dpi.jpg", units = "cm", width = 17, height = 23, dpi = 600)
