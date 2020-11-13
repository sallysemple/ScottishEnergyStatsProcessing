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

### Set Working Directory
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###

# This is unlikely to change from 2012
yearstart <- 2012

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")

### Load Shapefile
LAinitial <- readShapePoly("Local Authority Map/LocalAuthority.shp")

### Simplify Shapefile for later image manipulation
LAsimple <- gSimplify(LAinitial, tol = 200, topologyPreserve = TRUE)

### Add Simplified shape back to the Shapefile
LA = SpatialPolygonsDataFrame(LAsimple, data = LAinitial@data)
############ RENEWABLE ELECTRICITY ################################################

### Load Source Data
LARenewables <- read_excel("Data Sources/Test/SwitchMap.xlsx")


### Change LA$CODE to string
LA$CODE <- as.character(LA$CODE)

### Order LAs in Shapefile
LA <- LA[order(LA$CODE),]

### Order LAs in Data
LARenewables <- LARenewables[order(LARenewables$CODE),]

### Combine Data with Map data
LAMap <-
  append_data(LA, LARenewables, key.shp = "CODE", key.data = "CODE")

### Create Full Scotland Map
ScotlandMap <- tm_shape(LAMap) +
  tm_fill(
    "Percentage",
    title = "Switch Map",
    palette = "Greens",
    style = "cont"
  ) +
  tm_borders(alpha = .1) +
  tm_text("LAName", size = .5) # Set the variable to use as Labels, and the text size.

#Export to PDF, to be used in Inkscape
save_tmap(ScotlandMap, filename = "Releases and Publications/Energy Statistics Database/Maps/ElecScotland.pdf")