import os
import matplotlib.pyplot as plt
import geopandas as gpd
from mpl_toolkits.axes_grid1 import make_axes_locatable
import pandas as pd
import matplotlib.colors as mcolors

# Set working directory
os.chdir('/mmfs1/projects/brent.hulke/LewisFlax/FlaxFrostTolerance/')

# Load the data from the CSV file
data = pd.read_csv('flaxFrostAccessionLocations.csv')

# Clean and prepare the data
# Removing whitespace and converting to numeric
data['Elevation (m)'] = pd.to_numeric(data['Elevation (m)\xa0'].str.strip(), errors='coerce')
data['Latitude'] = pd.to_numeric(data['Latitude\xa0'].str.strip(), errors='coerce')
data['Longitude'] = pd.to_numeric(data['Longitude\xa0'].str.strip(), errors='coerce')

# Drop rows with missing values and sort data by elevation
data_clean = data.dropna(subset=['Elevation (m)', 'Latitude', 'Longitude'])
data_sorted = data_clean.sort_values(by='Elevation (m)')

# Load the low resolution world map
world = gpd.read_file(gpd.datasets.get_path('naturalearth_lowres'))
# Filter for North America
north_america = world[world['continent'] == 'North America']

# Calculate the aspect ratio for the plot dimensions
aspect_ratio = 125 / 55  # Calculated from the longitude and latitude range
height_cm = min(17 / aspect_ratio, 23)  # Height in cm, within the range 10-23 cm
figsize = (17 / 2.54, height_cm / 2.54)  # Convert cm to inches for figsize

# Create the plot with adjusted dimensions
fig, ax = plt.subplots(1, 1, figsize=figsize, dpi=600)

# Plot the North America map with light gray color and black borders
north_america.plot(ax=ax, color='lightgray', edgecolor='black')

# Set latitude and longitude limits for the plot
ax.set_xlim([-175, -50])
ax.set_ylim([20, 75])

# Normalize the elevation data for color mapping
norm = mcolors.Normalize(vmin=data_sorted['Elevation (m)'].min(), vmax=data_sorted['Elevation (m)'].max())

# Plot the sorted data points with small circles, colored by elevation
scatter = ax.scatter(data_sorted['Longitude'], data_sorted['Latitude'], 
                     c=data_sorted['Elevation (m)'], cmap='viridis', norm=norm, alpha=0.6, s=20, marker='o')

# Add a color bar close to the plot with no padding
divider = make_axes_locatable(ax)
cax = divider.append_axes("right", size="2%", pad=0.00)
cb = plt.colorbar(scatter, cax=cax)
cb.set_label('Elevation (m)')

# Set labels for the longitude and latitude axes
ax.set_xlabel('Longitude')
ax.set_ylabel('Latitude')

# Adjust the figure layout to fit all elements neatly
fig.tight_layout()

# Save the figure as a high-resolution JPG image
output_filepath = 'flaxFrostCollectionLocationsElevationsMap_17x10cm_600dpi.jpg'
plt.savefig(output_filepath, dpi=600, bbox_inches='tight', facecolor='white', format='jpg')

# Close the figure to prevent it from displaying in the notebook
plt.close()

