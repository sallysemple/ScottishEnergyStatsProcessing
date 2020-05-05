library(readr)
library(readxl)
library(tidyverse)
library(reshape2)
library(readr)
library(lubridate)
library(zoo)


#REPD <- read_excel("C:/Users/ische/Downloads/renewable-energy-planning-database-december-2019.xlsx", 
#sheet = "Database", skip = 6)
REPD <- read_delim("Output/REPD (Operational Corrections)/REPD.txt", 
                      "\t", escape_double = FALSE, trim_ws = TRUE)


REPD <- REPD[c(2,5,6,9,19,23)]

unique(REPD$`Development Status (short)`)
unique(REPD$Country)

REPD <- subset(REPD, `Technology Type` %in% c("Biomass (co-firing)", "EfW Incineration" ,"Biomass (dedicated)", "Advanced Conversion Technologies", "Anaerobic Digestion", "Large Hydro", "Small Hydro","Landfill Gas", "Solar Photovoltaics", "Sewage Sludge Digestion", "Tidal Barrage and Tidal Stream", "Shoreline Wave", "Wind Offshore", "Wind Onshore", "Hot Dry Rocks (HDR)"))

REPD <- REPD %>% 
  mutate(`Technology Type` = replace(`Technology Type`, `Technology Type` == "Tidal Barrage and Tidal Stream", "Shoreline wave / tidal")) %>% 
  mutate(`Technology Type` = replace(`Technology Type`, `Technology Type` == "Shoreline Wave", "Shoreline wave / tidal"))

REPD <- REPD[which(REPD$`Development Status (short)` %in% c("Operational")),]

REPD$CapacityBand <- "50MW +"

REPD[which(REPD$`Installed Capacity (MWelec)` < 50),]$CapacityBand <- "10-50MW"
REPD[which(REPD$`Installed Capacity (MWelec)` < 10),]$CapacityBand <- "5 - 10MW"
REPD[which(REPD$`Installed Capacity (MWelec)` < 5),]$CapacityBand <- "<5MW"

REPD <- REPD %>%  group_by(`Technology Type`, `Development Status (short)`,  CapacityBand) %>% 
  summarise(`Installed Capacity (MWelec)` = sum(`Installed Capacity (MWelec)`, na.rm = TRUE))

Table <- dcast(REPD, `Technology Type` ~ CapacityBand, value.var = "Installed Capacity (MWelec)")

Table[is.na(Table)] <- 0

Table$Total <- Table$`10-50MW`+Table$`5 - 10MW`+Table$`50MW +`+Table$`<5MW`

Table <- Table[order(-Table$Total),]



QTRCapacityScotland <- read_delim("Output/Quarter Capacity/QTRCapacityScotland.txt", 
                                  "\t", escape_double = FALSE, trim_ws = TRUE)

QTRCapacityScotland <- tail(QTRCapacityScotland,1)

Table[which(Table$`Technology Type` == "Wind Onshore"),]$Total <- QTRCapacityScotland$`Onshore Wind`
Table[which(Table$`Technology Type` == "Wind Offshore"),]$Total <- QTRCapacityScotland$`Offshore Wind`
Table[which(Table$`Technology Type` == "Large Hydro"),]$Total <- QTRCapacityScotland$`Large scale Hydro`
Table[which(Table$`Technology Type` == "Biomass (dedicated)"),]$Total <- QTRCapacityScotland$`Plant Biomass`
Table[which(Table$`Technology Type` == "Small Hydro"),]$Total <- QTRCapacityScotland$`Small scale Hydro`
Table[which(Table$`Technology Type` == "Landfill Gas"),]$Total <- QTRCapacityScotland$`Landfill gas`
Table[which(Table$`Technology Type` == "Solar Photovoltaics"),]$Total <- QTRCapacityScotland$`Solar photovoltaics`
Table[which(Table$`Technology Type` == "EfW Incineration"),]$Total <- QTRCapacityScotland$`Energy from waste`
Table[which(Table$`Technology Type` == "Anaerobic Digestion"),]$Total <- QTRCapacityScotland$`Anaerobic Digestion`
Table[which(Table$`Technology Type` == "Shoreline wave / tidal"),]$Total <- QTRCapacityScotland$`Shoreline wave / tidal`

Table$`<5MW` <- Table$Total - Table$`50MW +` - Table$`10-50MW` - Table$`5 - 10MW`

x <-as_tibble(t(as.data.frame(colSums(Table[2:6], na.rm=TRUE))))
x$`Technology Type` <- "All Technologies"

Table <- rbind(Table,x)

write.table(Table[c(1,2,4,3,5,6)],
          "Output/Capacity by Size/CapacitySizeTech.txt",
          sep = "\t",
          row.names = FALSE)

