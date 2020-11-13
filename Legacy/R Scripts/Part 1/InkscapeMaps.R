### Load Packages
library(readr)
library("maptools")
library(tmaptools)
library(tmap)
library("sf")
library("leaflet")
library("rgeos")
library(readxl)
library(ggplot2)

print("InkscapeMaps")

### Set Working Directory
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###

UKMap <- readShapePoly("GB Map/GBR_adm1.shp")
UKSimple <- gSimplify(UKMap, tol = .06, topologyPreserve = TRUE)
UKMap = SpatialPolygonsDataFrame(UKSimple, data = UKMap@data)

GBMap <- tm_shape(UKMap)+
  tm_fill(
    "NAME_1",
    title = "Map",
    palette = "Greens",
    # Set Break Points for the %. There is an equal amount of colour variation between 0 and 1, and 16 and 32
    style = "cont"
  ) +
  tm_borders(alpha = .001) +
  tm_text("NAME_1", size = .5) # Set the variable to use as Labels, and the text size.

save_tmap(GBMap, filename = "Releases and Publications/Energy Statistics Database/Maps/GB.pdf")

#EUMap <- readShapePoly("EU Map/NUTS_BN_60M_2016_3035.shp")
