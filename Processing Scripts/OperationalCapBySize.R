library(plyr)
library(dplyr)
library(readr)
library(readxl)
library(tidyverse)
library(reshape2)
library(readr)
library(lubridate)
library(zoo)
library("writexl")


print("OperationalCapBySize")

source("Processing Scripts/Datatable.R")


names(RESTATS) <- c("RenewableArea", "Project Name", "Site Name", "Capacity")

DECCsheets <- RESTATS %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Anaerobic Digestion", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Photovoltaics", "Solar Photovoltaics")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Small Hydro", "Hydro")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Large Hydro", "Hydro")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Wind Onshore", "Wind Onshore")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Wind Offshore", "Wind Offshore")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Landfill Gas", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Landfill gas", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Sewage Sludge Digestion", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Biomass", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Poultry Litter", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Municipal Solid Waste Combustion", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Shoreline Wave", "Shoreline wave / tidal")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Tidal", "Shoreline wave / tidal")) 


DECCsheets$CapacityBand <- "50MW +"

DECCsheets[which(DECCsheets$`Capacity` < 50),]$CapacityBand <- "10-50MW"
DECCsheets[which(DECCsheets$`Capacity` < 10),]$CapacityBand <- "5 - 10MW"
DECCsheets[which(DECCsheets$`Capacity` < 5),]$CapacityBand <- "<5MW"

DECCsheets[which(substr(DECCsheets$`Project Name`,1,4) == "FIT-"),]$CapacityBand <- "<5MW"

DECCsheets <- DECCsheets %>%  group_by(RenewableArea,   CapacityBand) %>% 
  summarise(`Capacity` = sum(`Capacity`, na.rm = TRUE))

Table <- dcast(DECCsheets, `RenewableArea` ~ CapacityBand, value.var = "Capacity")

Table[is.na(Table)] <- 0

Table$Total <- Table$`10-50MW`+Table$`5 - 10MW`+Table$`50MW +`+Table$`<5MW`

Table <- Table[order(-Table$Total),]

names(Table)[1] <- "Technology Type"

###




QTRCapacityScotland <- read_delim("Output/Quarter Capacity/QTRCapacityScotland.txt", 
                                  "\t", escape_double = FALSE, trim_ws = TRUE)

QTRCapacityScotland <- tail(QTRCapacityScotland,1)

Table[which(Table$`Technology Type` == "Wind Onshore"),]$Total <- QTRCapacityScotland$`Onshore Wind`
Table[which(Table$`Technology Type` == "Wind Offshore"),]$Total <- QTRCapacityScotland$`Offshore Wind - Seabed` + QTRCapacityScotland$`Offshore Wind - Floating`
Table[which(Table$`Technology Type` == "Hydro"),]$Total <- QTRCapacityScotland$`Small scale Hydro` + QTRCapacityScotland$`Large scale Hydro`
Table[which(Table$`Technology Type` == "Solar Photovoltaics"),]$Total <- QTRCapacityScotland$`Solar photovoltaics`
Table[which(Table$`Technology Type` == "Biomass and Waste"),]$Total <-  QTRCapacityScotland$`Anaerobic Digestion` + 
                                                                        QTRCapacityScotland$`Landfill gas` + 
                                                                        QTRCapacityScotland$`Sewage sludge digestion` + 
                                                                        QTRCapacityScotland$`Energy from Waste` + 
                                                                        QTRCapacityScotland$`Animal Biomass`  + 
                                                                        QTRCapacityScotland$`Plant Biomass`
Table[which(Table$`Technology Type` == "Shoreline wave / tidal"),]$Total <- QTRCapacityScotland$`Shoreline wave / tidal`

Table$`<5MW` <- Table$Total - Table$`50MW +` - Table$`10-50MW` - Table$`5 - 10MW`

x <-as_tibble(t(as.data.frame(colSums(Table[2:6], na.rm=TRUE))))
x$`Technology Type` <- "All Technologies"

Table <- rbind(Table,x)

write.table(Table[c(1,2,4,3,5,6)],
          "Output/Capacity by Size/CapacitySizeTech.txt",
          sep = "\t",
          row.names = FALSE)


