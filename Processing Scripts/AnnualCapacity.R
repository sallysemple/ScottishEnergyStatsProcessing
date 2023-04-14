library(tidyverse)
library(plyr)
library(dplyr)
library(magrittr)
library(lubridate)
library(zoo)
library(readxl)

print("AnnualRenElecCap")


source("Processing Scripts/QtrRenCap.R")

AnnualCapacity <- RenElecCap

AnnualCapacity$Hydro <- AnnualCapacity$`Small scale Hydro` + AnnualCapacity$`Large scale Hydro`

AnnualCapacity$`Bioenergy and Waste` <- AnnualCapacity$`Landfill gas` + AnnualCapacity$`Sewage sludge digestion` + AnnualCapacity$`Energy from Waste` + AnnualCapacity$`Animal Biomass` + AnnualCapacity$`Anaerobic Digestion` + AnnualCapacity$`Plant Biomass`
AnnualCapacity$`Offshore Wind` <- AnnualCapacity$`Offshore Wind - Seabed` + AnnualCapacity$`Offshore Wind - Floating`

AnnualCapacity <- select(AnnualCapacity,
                         "Quarter",                 
                         "Onshore Wind",
                         "Offshore Wind",
                         "Hydro",
                         "Solar photovoltaics",
                         "Bioenergy and Waste", 
                         "Shoreline wave / tidal", 
                         "Total")

AnnualCapacity <- AnnualCapacity[which(substr(AnnualCapacity$Quarter,7,7)== 4),]

AnnualCapacity$Quarter <- substr(AnnualCapacity$Quarter,1,4)

names(AnnualCapacity) <- c("Year", "Onshore Wind", "Offshore Wind", "Hydro", "Solar PV", "Bioenergy and Waste", "Wave and tidal", "Total")

OldAnnualCapacity <- read_csv("Data Sources/MANUAL/OldRenElecCap.csv")

AnnualCapacity <- merge(OldAnnualCapacity, AnnualCapacity, all = TRUE)

write_csv(AnnualCapacity, "Output/Renewable Capacity/AnnualElecCapacity.csv")
