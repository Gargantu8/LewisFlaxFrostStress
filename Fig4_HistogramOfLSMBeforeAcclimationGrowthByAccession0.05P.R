library(ggplot2)
library(viridis)

# Set working directory
setwd("/mmfs1/projects/brent.hulke/LewisFlax/FlaxFrostTolerance/")

# Load the data
data <- read.csv("flaxAcclimatizationGrowthFreeze.csv")

# Add a column for significance
data$Significant <- data$Pvalue < 0.05

# Create a new column for fill color based on significance and value of leastSquareMeanCM
data$FillColor <- ifelse(data$Accession == "Maple Grove", "Maple Grove", 
                         ifelse(data$Significant & data$leastSquareMeanCM >= 50, "Significant Above 50", 
                                ifelse(data$Significant & data$leastSquareMeanCM < 50, "Significant Below 50",
                                       "Non-Significant")))

# Reorder the Accession factor levels
data$Accession <- factor(data$Accession, levels = data$Accession[order(-data$leastSquareMeanCM)])

# Define colors from different points of the Viridis palette
viridis_colors <- viridis(10)

# Calculate the range for the error bars
data$ymin <- data$leastSquareMeanCM - data$standardError
data$ymax <- data$leastSquareMeanCM + data$standardError

# Create the histogram with error bars
ggplot(data, aes(x = Accession, y = leastSquareMeanCM, fill = FillColor)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_errorbar(aes(ymin = ymin, ymax = ymax), width = 0.2) +  # Add error bars
  labs(x = "Accession", y = "Growth Before Acclimation (cm)") +
  scale_fill_manual(values = c("Maple Grove" = viridis_colors[4], 
                               "Significant Above 50" = viridis_colors[2], 
                               "Significant Below 50" = viridis_colors[8],
                               "Non-Significant" = "gray50")) +
  theme_bw() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1, size = 8))

# Save the plot
ggsave("LSMgrowthBeforeAcclimationByAccession_17x17cm_600dpi.jpg", units = "cm", width = 17, height = 17, dpi = 600)