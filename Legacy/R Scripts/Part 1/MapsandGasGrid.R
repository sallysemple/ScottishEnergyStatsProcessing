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

print("MapsandGasGrid")

### Set Working Directory
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###

# This is unlikely to change from 2012
yearstart <- 2012

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")

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
############ RENEWABLE ELECTRICITY ################################################

### Load Source Data
LARenewables <- read_delim(
  "R Data Output/LARenewables.txt",
  "\t",
  escape_double = FALSE,
  trim_ws = TRUE
)

### Remove Excess Columns
LARenewables[3:17] <- list(NULL)

### Rename Columns
names(LARenewables) <- c("CODE", "LAName", "Renewables", "Year")

### Add Column of Percentages
LARenewables$Percentage <-
  (LARenewables$Renewables / sum(LARenewables$Renewables)) * 100


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
    title = "LA Renewable Percentages",
    palette = "Greens",
    breaks = c(0, 1, 2, 4, 8, 16, 32),
    # Set Break Points for the %. There is an equal amount of colour variation between 0 and 1, and 16 and 32
    style = "cont"
  ) +
  tm_borders(alpha = .1) +
  tm_text("LAName", size = .5) # Set the variable to use as Labels, and the text size.

#Export to PDF, to be used in Inkscape
save_tmap(ScotlandMap, filename = "Releases and Publications/Energy Statistics Database/Maps/Scotland.pdf")

#Subset the Central Belt
LACentral <-
  subset(
    LAMap,
    CODE == "S12000045"   # East Dunbartonshire
    | CODE == "S12000039" # West Dunbartonshite
    | CODE == "S12000014" # Falkirk
    | CODE == "S12000018" # Inverclyde
    | CODE == "S12000046" # Glasgow City
    | CODE == "S12000038" # Renfrewshire
    | CODE == "S12000044" # North Lanarkshire
    | CODE == "S12000040" # West Lothian
    | CODE == "S12000036" # City of Edinburgh
    | CODE == "S12000011" # East Renfrewshire
  )

# Create Central Belt Map
CentralMap <- tm_shape(LACentral) +
  tm_fill(
    "Percentage",
    title = "LA Renewable Percentages",
    palette = "Greens",
    breaks = c(0, 1, 2, 4, 8, 16, 32),
    style = "cont"
  ) +
  tm_borders(alpha = .1) +
  tm_text("LAName", size = 1) # Bigger Text size

#Export to PDF
save_tmap(CentralMap, filename = "Releases and Publications/Energy Statistics Database/Maps/Central.pdf")


################# GAS GRID   #################################
###### LOOP ######
# This Loop runs for each year between the yearstart (2012) to the current year, inclusive.###
for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  ### Multiple tryCatch allow for Year (XXXX) and revised Year (XXXXr) sheets to be opened in a single loop ###
  #If Try Catch encounters an error, code within trycatch brackets will abort, but other code will continue to run ###
  tryCatch({
    tryCatch({
      OffGas <- read_excel(
        "Data Sources/Gas Grid/Current.xlsx",
        sheet = paste(year),
        skip = 1
      )
      OffGas$Year <- year
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
    tryCatch({
      OffGas <- read_excel(
        "Data Sources/Gas Grid/Current.xlsx",
        sheet = paste(year, "r", sep = ""),
        skip = 1
      )
      OffGas$Year <- year
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
}

### Name Third Column "CODE"
names(OffGas)[3] <- "CODE"

### Name Eigth Column "Percentage"
names(OffGas)[8] <- "Percentage"

### Create Scottish Subset ###
OffGas <- subset(OffGas, Region == "Scotland")

### Multiply Percentage Column by 100, for display on the map ###
OffGas$Percentage <- OffGas$Percentage * 100

### Attach Gas Data to Map ###
LAGasMap <-
  append_data(
    LA,
    OffGas,
    key.shp = "CODE",
    key.data = "CODE",
    ignore.duplicates = TRUE,
    ignore.na = TRUE
  )

### Generate Scottish Map ###
ScotlandGasMap <- tm_shape(LAGasMap) +
  tm_fill(
    "Percentage",
    title = "LA Gas Percentages",
    palette = "Reds",
    breaks = c(0, 25, 50, 75, 100),
    # Linear Break Points
    style = "cont"
  ) +
  tm_borders(alpha = .1) +
  tm_text("NAME", size = .5) # Change Text Size

### Export to PDF ###
save_tmap(ScotlandGasMap, filename = "Releases and Publications/Energy Statistics Database/Maps/ScotlandGas.pdf")

### Scottish Map No Labels

ScotlandGasMapNoLabels <- tm_shape(LAGasMap) +
  tm_fill(
    "Percentage",
    title = "LA Gas Percentages",
    palette = "Reds",
    breaks = c(0, 25, 50, 75, 100),
    # Linear Break Points
    style = "cont"
  ) +
  tm_borders(alpha = .1)

### Export to PDF ###
save_tmap(ScotlandGasMapNoLabels, filename = "Releases and Publications/Energy Statistics Database/Maps/ScotlandGasNoLabels.pdf")

### Central Belt ###
LACentralGasMap <-
  subset(
    LAGasMap,
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


CentralGasMap <- tm_shape(LACentralGasMap) +
  tm_fill(
    "Percentage",
    title = "LA Gas Percentages",
    palette = "Reds",
    breaks = c(0, 25, 50, 75, 100),
    style = "cont"
  ) +
  tm_borders(alpha = .1) +
  tm_text("NAME", size = 1) # Larger Text Size, for Display

#Export to PDF
save_tmap(CentralGasMap, filename = "Releases and Publications/Energy Statistics Database/Maps/CentralGas.pdf")

#Remove First Column
OffGas[1] <- NULL

#Export to Table
write.table(
  OffGas,
  "R Data Output/OffGas.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### LAConsumption ######

LAConsumption <- read_delim("R Data Output/Consumption.txt", 
                            "\t", escape_double = FALSE, trim_ws = TRUE)

LAConsumption <- LAConsumption[1:4]

LAConsumption <- subset(LAConsumption, LAConsumption$Year == (max(LAConsumption$Year, na.rm = TRUE)))

colnames(LAConsumption) <- c("CODE", "LAName", "Year", "Consumption")

LAConsumption$CODE <- as.character(LAConsumption$CODE)

### Combine Data with Map data
LAConMap <-
  append_data(LA, LAConsumption, key.shp = "CODE", key.data = "CODE")

### Create Full Scotland Map
ScotlandConMap <- tm_shape(LAConMap) +
  tm_fill(
    "Consumption",
    title = "LA Consumption",
    palette = "Purples",
    # Set Break Points for the %. There is an equal amount of colour variation between 0 and 1, and 16 and 32
    style = "cont"
  ) +
  tm_borders(alpha = .1) +
  tm_text("LAName", size = .5) # Set the variable to use as Labels, and the text size.

#Export to PDF, to be used in Inkscape
save_tmap(ScotlandConMap, filename = "Releases and Publications/Energy Statistics Database/Maps/ScotlandConsumption.pdf")

#Subset the Central Belt
LAConCentral <-
  subset(
    LAConMap,
    CODE == "S12000045"   # East Dunbartonshire
    | CODE == "S12000039" # West Dunbartonshite
    | CODE == "S12000014" # Falkirk
    | CODE == "S12000018" # Inverclyde
    | CODE == "S12000046" # Glasgow City
    | CODE == "S12000038" # Renfrewshire
    | CODE == "S12000044" # North Lanarkshire
    | CODE == "S12000040" # West Lothian
    | CODE == "S12000036" # City of Edinburgh
    | CODE == "S12000011" # East Renfrewshire
  )

# Create Central Belt Map
CentralConMap <- tm_shape(LAConCentral) +
  tm_fill(
    "Consumption",
    title = "LA Consumption",
    palette = "Purples",
    style = "cont"
  ) +
  tm_borders(alpha = .1) +
  tm_text("LAName", size = 1) # Bigger Text size

#Export to PDF
save_tmap(CentralConMap, filename = "Releases and Publications/Energy Statistics Database/Maps/CentralConsumption.pdf")
