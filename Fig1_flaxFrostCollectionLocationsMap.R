# Load necessary libraries
library(ggplot2)
library(sf)
library(viridis)
library(dplyr)
library(maps)

# Set working directory
setwd("/mmfs1/projects/brent.hulke/LewisFlax/FlaxFrostTolerance/")

# Read the data
data <- read.csv("flaxFrostAccessionLocations.csv", stringsAsFactors = FALSE)
data$elevation <- as.numeric(gsub(",", "", data$elevation)) # Clean elevation data

# Transform data into a simple features (sf) object
data_sf <- st_as_sf(data, coords = c("longitude", "latitude"), crs = 4326)

# Load North America map data
world <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
north_america <- world[world$ID %in% c("USA", "Canada", "Mexico"), ]

# Load US state boundaries
states <- st_as_sf(maps::map("state", plot = FALSE, fill = TRUE))

# Plotting
ggplot() +
  geom_sf(data = north_america, fill = "white", color = "black") +
  geom_sf(data = states, fill = NA, color = "gray", size = 0.5) + # Add US states
  geom_sf(data = data_sf, aes(color = elevation), size = 2) +
  scale_color_viridis(name = "Elevation (m)", option = "C") +
  labs(x = "Longitude", y = "Latitude") +
  theme_minimal() +
  theme(legend.position = "right") +
  coord_sf(xlim = c(-168, -65), ylim = c(25, 75), expand = FALSE) # Set display limits

# Save the plot as an image file, if desired
ggsave("Fig1_flaxFrostCollectionLocationsMap_17x10cm_600dpi.jpg", units = "cm", width = 17, height = 10, dpi = 600)