library(ggplot2)
library(viridis)
library(dplyr)
library(ggrepel)
library(stringr)

# Seed for recreating the exact same layout
set.seed(22)

# Set working directory
setwd("/mmfs1/projects/brent.hulke/LewisFlax/FlaxFrostTolerance/")

# Load data
data <- read.csv("flaxFrostSurvivorFunctionEstimateHazardTime3.csv", sep = ",")

# Generate colors from the viridis palette for High, Low, and Maple Grove
colors <- viridis::viridis(10)

# Shorten the acccession labels that are too long
data <- data %>%
  mutate(accession = str_replace(accession, "Teddy Roosevelt National Park NU 1", "TRNP NU 1"))

# Define new columns 'color' and 'label_size' in your data based on 'hazardLabel'
data <- data %>%
  mutate(
    color = case_when(
      hazardLabel == "High" ~ "High",
      hazardLabel == "Low" ~ "Low",
      accession == "Maple Grove" ~ "Maple Grove",
      TRUE ~ "Non-significant"
    ),
    label_size = 3,  # Set a uniform size for all labels
    color = factor(color, levels = c("High", "Low", "Non-significant", "Maple Grove")),
    size = ifelse(color == "Non-significant", "small", "large"),
    size = factor(size)
  )

# Separate data for Maple Grove and others
data_maple_grove <- data %>% filter(accession == "Maple Grove")
data_others <- data %>% filter(accession != "Maple Grove")

# Custom labeling function for negative x-axis values
negative_label <- function(x) {
  ifelse(x == 0, "0", paste0("-", x))
}

# Create a named vector for manual color values
color_values <- c("High" = colors[8], "Low" = colors[2], "Non-significant" = "gray50", "Maple Grove" = colors[4])

# Plotting with labels for non-gray lines using ggrepel for better label placement
gg_plot <- ggplot() +
  geom_line(data = data_others, aes(x = temperature, y = survivorFunctionEstimate, group = accession, color = color, size = size)) +
  geom_line(data = data_maple_grove, aes(x = temperature, y = survivorFunctionEstimate, group = accession, color = color, size = size)) +
  geom_text_repel(
    data = filter(data, temperature == 15),
    aes(x = temperature, y = survivorFunctionEstimate, label = accession, color = color),
    size = 3,  # Set the label size here
    nudge_x = 5, nudge_y = 0,
    direction = "y",
    force_pull = 10,
    force = 1,
    box.padding = 0.1, # padding around the text label
    max.time = 5, # maximum seconds to resolve overlaps
    max.iter = 100000 # max iterations to resolve overlaps
  ) +
  scale_x_continuous(
    breaks = seq(3, 15, by = 3),
    labels = negative_label,
    limits = c(3, 20),  # Set x-axis limits here
    minor_breaks = seq(0, 1, 0.05) # Removes grid lines past final label (-15)
  ) +
  scale_y_continuous(breaks = c(0, 0.25, 0.50, 0.75, 1)) +
  theme_bw() +
  labs(x = "Temperature (°C)", y = "Survival Function Estimate") +
  scale_color_manual(values = color_values) +
  scale_size_manual(values = c("small" = 0.5, "large" = 1)) +
  guides(color = FALSE, size = FALSE) +
  theme(legend.position = "none")  # Adjust right margin

# Save the plot
ggsave("SurvivalHazardByAccession_seed22size3_17x23cm_600dpi.jpg", plot = gg_plot, units = "cm", width = 17, height = 23, dpi = 600)