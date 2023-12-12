# Load required libraries
library(dplyr)
library(sf)     # Replaces sp and rgdal
library(vegan)
library(ggrepel)
library(ggplot2)
library(viridis)
library(raster)

# Set working directory
setwd("/mmfs1/projects/brent.hulke/LewisFlax/FlaxFrostTolerance/")

# Load the environmental data
env_data <- read.csv("Freeze_Seed_Geo_Collection.csv", header = TRUE)

env_data <- env_data[, -1]

env_data <- env_data %>% mutate(source = 1:46)

# %>% #keep only pops that have coordinates (missing coords for source 37, and Appar doesn't have coords)
# mutate(Lat_s=scale(Lat), Long_s=scale(Long), Elev_m_s=scale(Elev_m)) # scale predictors
rownames(env_data) <- env_data[, 1]
head(env_data)

geo_data <-
  env_data %>% dplyr::select(population, Lat, Long, Elev_m) %>%
  filter(!is.na(Lat) | !is.na(Long))
BioClim_codes <-
  read.csv("BioClim_codes.csv") #this file matches the vague bioclim codes (e.g. bio01) with actual descriptions (e.g. Mean Annual Temp)

dem <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio6_1981-2010_V.2.1.tif"
  )
coords <- data.frame(
  Long = env_data$Long,
  Lat = env_data$Lat,
  row.names = env_data$population
) %>% na.omit()

points <- SpatialPoints(coords, dem@crs)

bio06 <-
  raster::extract(dem, points, sp = F) #previously raster::extract(r,points)

clim_data <- cbind.data.frame(coordinates(points), bio06) %>%
  tibble::rownames_to_column("source")
clim_data2 <- clim_data
clim_data2 <- geo_data


bio10 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio10_1981-2010_V.2.1.tif"
  )
bio11 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio11_1981-2010_V.2.1.tif"
  )
bio12 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio12_1981-2010_V.2.1.tif"
  )
bio13 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio13_1981-2010_V.2.1.tif"
  )
bio14 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio14_1981-2010_V.2.1.tif"
  )
bio15 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio15_1981-2010_V.2.1.tif"
  )
bio16 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio16_1981-2010_V.2.1.tif"
  )
bio17 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio17_1981-2010_V.2.1.tif"
  )
bio18 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio18_1981-2010_V.2.1.tif"
  )
bio19 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio19_1981-2010_V.2.1.tif"
  )
bio1 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio1_1981-2010_V.2.1.tif"
  )
bio2 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio2_1981-2010_V.2.1.tif"
  )
bio3 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio3_1981-2010_V.2.1.tif"
  )
bio4 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio4_1981-2010_V.2.1.tif"
  )
bio5 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio5_1981-2010_V.2.1.tif"
  )
#bio6<-raster("https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio6_1981-2010_V.2.1.tif" )
bio7 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio7_1981-2010_V.2.1.tif"
  )
bio8 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio8_1981-2010_V.2.1.tif"
  )
bio9 <-
  raster(
    "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio9_1981-2010_V.2.1.tif"
  )
#bio6<-raster("https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio6_1981-2010_V.2.1.tif")
#dem<-raster("~/Thesis Files/BioClim/CHELSA_bio6_1981-2010_V.2.1.tif")

bio1points <- SpatialPoints(coords, bio1@crs)
bio01 <-
  raster::extract(bio1, bio1points, sp = F) #previously raster::extract(r,points)
bio1_data <- cbind.data.frame(coordinates(bio1points), bio01) %>%
  tibble::rownames_to_column("source")

bio2points <- SpatialPoints(coords, bio2@crs)
bio02 <-
  raster::extract(bio2, bio2points, sp = F) #previously raster::extract(r,points)

bio3points <- SpatialPoints(coords, bio3@crs)
bio03 <-
  raster::extract(bio3, bio3points, sp = F) #previously raster::extract(r,points)

bio4points <- SpatialPoints(coords, bio4@crs)
bio04 <-
  raster::extract(bio4, bio4points, sp = F) #previously raster::extract(r,points)

bio5points <- SpatialPoints(coords, bio5@crs)
bio05 <-
  raster::extract(bio5, bio5points, sp = F) #previously raster::extract(r,points)

#dem
#bio6points <- SpatialPoints(coords, bio2@crs)
#bio06 <- raster::extract(bio2, bio2points,sp=F) #previously raster::extract(r,points)

bio7points <- SpatialPoints(coords, bio7@crs)
bio07 <-
  raster::extract(bio7, bio7points, sp = F) #previously raster::extract(r,points)

bio8points <- SpatialPoints(coords, bio8@crs)
bio08 <-
  raster::extract(bio8, bio8points, sp = F) #previously raster::extract(r,points)

bio9points <- SpatialPoints(coords, bio9@crs)
bio09 <-
  raster::extract(bio9, bio9points, sp = F) #previously raster::extract(r,points)

bio10points <- SpatialPoints(coords, bio10@crs)
bio10 <-
  raster::extract(bio10, bio10points, sp = F) #previously raster::extract(r,points)

bio11points <- SpatialPoints(coords, bio11@crs)
bio11 <-
  raster::extract(bio11, bio11points, sp = F) #previously raster::extract(r,points)

bio12points <- SpatialPoints(coords, bio12@crs)
bio12 <-
  raster::extract(bio12, bio12points, sp = F) #previously raster::extract(r,points)

bio13points <- SpatialPoints(coords, bio13@crs)
bio13 <-
  raster::extract(bio13, bio13points, sp = F) #previously raster::extract(r,points)

bio14points <- SpatialPoints(coords, bio14@crs)
bio14 <-
  raster::extract(bio14, bio14points, sp = F) #previously raster::extract(r,points)

bio15points <- SpatialPoints(coords, bio15@crs)
bio15 <-
  raster::extract(bio15, bio15points, sp = F) #previously raster::extract(r,points)

bio16points <- SpatialPoints(coords, bio16@crs)
bio16 <-
  raster::extract(bio16, bio16points, sp = F) #previously raster::extract(r,points)

bio17points <- SpatialPoints(coords, bio17@crs)
bio17 <-
  raster::extract(bio17, bio17points, sp = F) #previously raster::extract(r,points)

bio18points <- SpatialPoints(coords, bio18@crs)
bio18 <-
  raster::extract(bio18, bio18points, sp = F) #previously raster::extract(r,points)

bio19points <- SpatialPoints(coords, bio19@crs)
bio19 <-
  raster::extract(bio19, bio19points, sp = F) #previously raster::extract(r,points)


Elev_m <- geo_data$Elev_m
clim_data2 <- cbind(
  bio1_data,
  bio02,
  bio03,
  bio04,
  bio05,
  bio06,
  bio07,
  bio08,
  bio09,
  bio10,
  bio11,
  bio12,
  bio13,
  bio14,
  bio15,
  bio16,
  bio17,
  bio18,
  bio19,
  Elev_m
)
#adjust the scale manually refer to chelsa website for more detail
clim_data2[, 4] <- (clim_data2[, 4] * 0.1) - 273.15
clim_data2[, 5] <- (clim_data2[, 5] * 0.1)
clim_data2[, 6] <- (clim_data2[, 6] * 0.1)
clim_data2[, 7] <- (clim_data2[, 7] * 0.1)
clim_data2[, 8] <- (clim_data2[, 8] * 0.1) - 273.15
clim_data2[, 9] <- (clim_data2[, 9] * 0.1) - 273.15
clim_data2[, 10] <- (clim_data2[, 10] * 0.1)
clim_data2[, 11] <- (clim_data2[, 11] * 0.1) - 273.15
clim_data2[, 12] <- (clim_data2[, 12] * 0.1) - 273.15
clim_data2[, 13] <- (clim_data2[, 13] * 0.1) - 273.15
clim_data2[, 14] <- (clim_data2[, 14] * 0.1) - 273.15
clim_data2[, 15] <- (clim_data2[, 15] * 0.1)
clim_data2[, 16] <- (clim_data2[, 16] * 0.1)
clim_data2[, 17] <- (clim_data2[, 17] * 0.1)
clim_data2[, 18] <- (clim_data2[, 18] * 0.1)
clim_data2[, 19] <- (clim_data2[, 19] * 0.1)
clim_data2[, 20] <- (clim_data2[, 20] * 0.1)
clim_data2[, 21] <- (clim_data2[, 21] * 0.1)
clim_data2[, 22] <- (clim_data2[, 22] * 0.1)

env_pca_df <- clim_data2
head(env_pca_df)
rownames(env_pca_df) <- env_pca_df$source
env_pca_df <- env_pca_df %>% dplyr::select(-c(source))

my_env_pca <-
  rda(env_pca_df, scale = T) #PCA of scaled geo and clim vars (skip column 1 and 2 which have source/population ID)
summary(my_env_pca)
summary(eigenvals(my_env_pca))[2, 1:12] #percent variance explained
env_pca_eigenvals <-
  round(summary(eigenvals(my_env_pca))[, 1:3], digits = 3)
summary(env_pca_eigenvals)

##This was adapted from and with assistance from Peter Innes (Innes et al. 2022)
freeze_data <- read.csv("RDA_Accession.csv", header = T)
head(freeze_data)
freeze_data_cut <- freeze_data[, -1]
summary(freeze_data_cut)
freeze_data2 <- freeze_data_cut %>% mutate(source = 1:41)
rownames(freeze_data_cut) <- freeze_data_cut[, 1]

env_pca_df2 <- subset(env_pca_df, Elev_m != 1966.0)
#cut out
env_pca_df2 <- subset(env_pca_df2, Elev_m != 3183.0)
#cut out carbonate creek
env_pca_df2 <- subset(env_pca_df2, Elev_m != 2408.1)
freeze_data_cut2 <- freeze_data_cut[, -1]

my_full_rda <-
  rda(freeze_data_cut2 ~ ., data = env_pca_df2, scale = T)
summary(my_full_rda)
my_full_rda2 <-
  data.frame(scores(
    my_full_rda,
    choices = 1:2,
    display = "species",
    scaling = 0
  )) %>%
  tibble::rownames_to_column("var") %>%
  full_join(dplyr::select(BioClim_codes, var, description)) %>%
  relocate(description, .after = var)
my_full_rda3 <-
  data.frame(scores(
    my_full_rda,
    choices = 1:2,
    display = "sites",
    scaling = 0
  )) %>%
  tibble::rownames_to_column("var") %>%
  full_join(dplyr::select(BioClim_codes, var, description)) %>%
  relocate(description, .after = var)

mv_rda.sp_sc <-
  data.frame(scores(
    my_full_rda,
    choices = 1:2,
    scaling = 0,
    display = "sp"
  ))
mv_rda.env_sc <-
  data.frame(scores(
    my_full_rda,
    choices = 1:2,
    scaling = 0,
    display = "bp"
  ))
mv_rda.site_sc <-
  data.frame(scores(
    my_full_rda,
    choices = 1:2,
    scaling = 0,
    display = "wa"
  ))

mv_rda_eigenvals <-
  round(summary(eigenvals(my_full_rda, model = "constrained"))[, 1:4], digits = 3) #constrained by climate
mv_rda_eigenvals_adj <-
  round(rbind(
    mv_rda_eigenvals["Eigenvalue", ],
    data.frame(mv_rda_eigenvals[2:3, ]) * RsquareAdj(my_full_rda)[2]
  ), digits = 3) #loadings adjusted by adjusted R squared.
rownames(mv_rda_eigenvals_adj)[1] <- "Eigenvalue"

anova.cca(my_full_rda, permutations = 1000)
anova.cca(my_full_rda, by = "margin", permutations = 1000)
anova.cca(my_full_rda, by = "terms", permutations = 1000)
anova.cca(my_full_rda, by = "axis", permutations = 1000)

# Define the color palette
color_palette <- viridis::viridis(10)[c(2, 6)]

mv_rda_triplotgg_SUPP <- ggplot() +
  theme(text = element_text(size = 14)) +
  geom_point(data = mv_rda.site_sc,
             aes(x = RDA1, y = RDA2),
             size = 3,
             alpha = 0.5) +
  geom_segment(
    data = mv_rda.sp_sc,
    aes(
      x = 0,
      xend = RDA1,
      y = 0,
      yend = RDA2
    ),
    color = color_palette[1],
    arrow = arrow(length = unit(.03, "npc"))
  ) +
  geom_text_repel(
    data = mv_rda.sp_sc,
    aes(
      x = RDA1,
      y = RDA2,
      label = rownames(mv_rda.sp_sc)
    ),
    color = color_palette[1],
    size = 4
  ) +
  geom_segment(
    data = mv_rda.env_sc,
    aes(
      x = 0,
      xend = RDA1,
      y = 0,
      yend = RDA2
    ),
    color = color_palette[2],
    alpha = 0.5,
    arrow = arrow(length = unit(.03, "npc"))
  ) +
  geom_text_repel(
    data = mv_rda.env_sc,
    aes(
      x = RDA1,
      y = RDA2,
      label = rownames(mv_rda.env_sc)
    ),
    color = color_palette[2],
    alpha = 0.5,
    size = 4
  ) +
  geom_text_repel(
    data = mv_rda.site_sc,
    aes(
      x = RDA1,
      y = RDA2,
      label = rownames(mv_rda.site_sc)
    ),
    size = 3,
    alpha = 0.5
  ) +
  labs(
    x = paste0("RDA1 ", "(", 100 * mv_rda_eigenvals_adj[2, 1], "%)"),
    y = paste0("RDA2 ", "(", 100 * mv_rda_eigenvals_adj[2, 2], "%)"),
    title = ""
  ) +
  theme_bw() +
  theme(text = element_text(size = 14))
print(mv_rda_triplotgg_SUPP)

# Save the plot to a file
ggsave(
  "RDAtriplot_17x17cm_600dpi.jpg",
  # Specify the output filename/type
  width = 17,
  # Set the width of the saved plot
  height = 17,
  # Set the height of the saved plot
  units = "cm",
  # Specify the units for width and height
  dpi = 600  # Set the resolution of the saved plot
)
