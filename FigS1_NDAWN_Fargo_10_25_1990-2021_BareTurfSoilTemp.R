library("weathermetrics")
library("ggplot2")
library("viridis")

# Set working directory (already set in your script)
setwd("/mmfs1/projects/brent.hulke/LewisFlax/FlaxFrostTolerance/")

# Load data
fargoSoilTempData <- read.csv("NDAWN_Fargo_10_25_1990-2021_BareTurfSoilTemp.csv", sep = ",")

# Convert data to Celsius from Fahrenheit
fargoSoilTempData$AvgBareSoilTempC <- fahrenheit.to.celsius(fargoSoilTempData$AvgBareSoilTempF)
fargoSoilTempData$AvgTurfSoilTempC <- fahrenheit.to.celsius(fargoSoilTempData$AvgTurfSoilTempF)

# Create a Date column from Year, Month, and Day
fargoSoilTempData$Date <- as.Date(with(fargoSoilTempData, paste(Year, Month, Day, sep="-")), "%Y-%m-%d")

# Plotting
ggplot(fargoSoilTempData, aes(x = Date)) +
  geom_line(aes(y = AvgBareSoilTempC, colour = "Bare Soil")) +
  geom_line(aes(y = AvgTurfSoilTempC, colour = "Turf Soil")) +
  scale_colour_manual(values = viridis::viridis(9)[c(3, 7)]) +
  labs(x = "Year",
       y = "Temperature (°C)",
       colour = "") +
  theme_minimal() +
  theme(legend.position = "bottom",
        text = element_text(size = 12), # Set general text size to 10
        axis.title = element_text(size = 12), # Set axis titles to size 10
        axis.text = element_text(size = 12), # Set axis text to size 10
        legend.title = element_text(size = 12), # Set legend title to size 10
        legend.text = element_text(size = 12)) # Set legend text to size 10

# Save the plot to a file
ggsave(
  "SuppFargoBareTurfSoilTemps_17x10cm_600dpi.jpg",  # Specify the output filename/type
  width = 17,  # Set the width of the saved plot
  height = 10,  # Set the height of the saved plot
  units = "cm",  # Specify the units for width and height
  dpi = 600  # Set the resolution of the saved plot
)
