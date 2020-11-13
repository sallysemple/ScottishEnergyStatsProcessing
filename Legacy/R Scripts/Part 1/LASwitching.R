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


print("LASwitching")


### Set Working Directory
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Load Shapefile
LAinitial <- readShapePoly("Local Authority Map/LocalAuthority.shp")

LAinitial$CODE <- as.character(LAinitial$CODE)
LAinitial$CODE[LAinitial$CODE == "S12000015"] <- "S12000047"
LAinitial$CODE[LAinitial$CODE == "S12000024"] <- "S12000048"
LAinitial$CODE <- as.factor(LAinitial$CODE)

### Simplify Shapefile for later image manipulation
LAsimple <- gSimplify(LAinitial, tol = 200, topologyPreserve = TRUE)

### Add Simplified shape back to the Shapefile
LA = SpatialPolygonsDataFrame(LAsimple, data = LAinitial@data)

Switching <- read_excel("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/Data Sources/LA Switching/Current.xlsx")


### Attach Switching Data to Map ###
LASwitchingMap <-
  append_data(
    LA,
    Switching,
    key.shp = "CODE",
    key.data = "CODE",
    ignore.duplicates = TRUE,
    ignore.na = TRUE
  )

### Generate Scottish Map ###
ScotlandSwitchingMap <- tm_shape(LASwitchingMap) +
  tm_fill(
    "Percentage",
    title = "LA Switching Percentages",
    palette = "Greens",
    breaks = c(8, 16, 24),
    # Linear Break Points
    style = "cont"
  ) +
  tm_borders(alpha = .1) +
  tm_text("NAME", size = .5) # Change Text Size

### Export to PDF ###
save_tmap(ScotlandSwitchingMap, filename = "Releases and Publications/Energy Statistics Database/Maps/ScotlandSwitching.pdf")

### Scottish Map No Labels

ScotlandSwitchingMapNoLabels <- tm_shape(LASwitchingMap) +
  tm_fill(
    "Percentage",
    title = "LA Switching Percentages",
    palette = "Greens",
    breaks = c(8, 16, 24),
    # Linear Break Points
    style = "cont"
  ) +
  tm_borders(alpha = .1)

### Export to PDF ###
save_tmap(ScotlandSwitchingMapNoLabels, filename = "Releases and Publications/Energy Statistics Database/Maps/ScotlandSwitchingNoLabels.pdf")

### Central Belt ###
LACentralSwitchingMap <-
  subset(
    LASwitchingMap,
    CODE == "S12000045"   # East Dunbartonshire
    | CODE == "S12000039" # West Dunbartonshire
    | CODE == "S12000014" # Falkirk
    | CODE == "S12000018" # Inverclyde
    | CODE == "S12000046" # Glasgow City
    | CODE == "S12000038" # Renfrewshire
    | CODE == "S12000044" # North Lanarkshire
    | CODE == "S12000040" # West Lothian
    | CODE == "S12000036" # City of Edinbugh
    | CODE == "S12000011" # East Renfrewshire
  )


CentralSwitchingMap <- tm_shape(LACentralSwitchingMap) +
  tm_fill(
    "Percentage",
    title = "LA Switching Percentages",
    palette = "Greens",
    breaks = c(8, 16, 24),
    style = "cont"
  ) +
  tm_borders(alpha = .1) +
  tm_text("NAME", size = 1) # Larger Text Size, for Display

#Export to PDF
save_tmap(CentralSwitchingMap, filename = "Releases and Publications/Energy Statistics Database/Maps/CentralSwitching.pdf")


#Export to Table
write.table(
  Switching,
  "R Data Output/Switching.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

