library(tidyverse)
library(plyr)
library(dplyr)
library(magrittr)
library(lubridate)
library(zoo)
library(readxl)

print("QTRRenElecCap")


#Read Source Data
RenElecCap <- read_excel("Data Sources/Energy Trends/RenGenCap.xlsx", 
                         sheet = "Scotland - Qtr", col_names = FALSE, 
                         skip = 6, n_max = 27)
#Transpose Data Frame
RenElecCap <- as.data.frame(t(RenElecCap))

#Name Columns based on first row
names(RenElecCap) <- unlist(RenElecCap[1,])

#Name First COlumn Y
names(RenElecCap)[1] <- c("Y")

#Extract Year and Quarter into own column (source data has invisible symbols in the first column)
RenElecCap$Quarter <- paste0(substr(RenElecCap$Y,1,4), " Q", substr(RenElecCap$Y,8,8))

#Convert all but the first and last columns to numeric
RenElecCap[2:27] %<>% lapply(function(x) as.numeric(as.character(x)))

#Convert Data Frame to Tibble, keeping only important columns
RenElecCap <- as_tibble(RenElecCap[c(28,2:14)])

#Drop Rows without Data
RenElecCap <- RenElecCap[complete.cases(RenElecCap),]

#Convert Quartr Column to time format
RenElecCap$Quarter <- as.yearqtr(RenElecCap$Quarter)

#Give Columns final names
names(RenElecCap) <- c("Quarter", "Onshore Wind", "Offshore Wind", "Shoreline wave / tidal", "Solar photovoltaics", "Small scale Hydro", "Large scale Hydro", "Landfill gas", "Sewage sludge digestion", "Energy from Waste", "Animal Biomass", "Anaerobic Digestion", "Plant Biomass", "Total")


write.table(RenElecCap,
            "Output/Quarter Capacity/QTRCapacityScotland.txt",
            sep = "\t",
            row.names = FALSE)
