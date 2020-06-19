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


REPD <- REPD[c(2,5,6,9,19,27,23)]

unique(REPD$`Development Status (short)`)
unique(REPD$Country)

REPD <- subset(REPD, `Technology Type` %in% c("Biomass (co-firing)", "EfW Incineration" ,"Biomass (dedicated)", "Advanced Conversion Technologies", "Anaerobic Digestion", "Large Hydro", "Small Hydro","Landfill Gas", "Solar Photovoltaics", "Sewage Sludge Digestion", "Tidal Barrage and Tidal Stream", "Shoreline Wave", "Wind Offshore", "Wind Onshore", "Hot Dry Rocks (HDR)"))

REPD <- REPD %>% 
  mutate(`Technology Type` = replace(`Technology Type`, `Technology Type` == "Tidal Barrage and Tidal Stream", "Shoreline wave / tidal")) %>% 
  mutate(`Technology Type` = replace(`Technology Type`, `Technology Type` == "Shoreline Wave", "Shoreline wave / tidal"))

REPD <- REPD[which(REPD$`Development Status (short)` %in% c("Operational", "Awaiting Construction", "Under Construction", "Application Submitted")),]

REPD <- REPD %>%  group_by(`Planning Authority`, `Development Status (short)`) %>% 
  summarise(`Installed Capacity (MWelec)` = sum(`Installed Capacity (MWelec)`, na.rm = TRUE))

REPD <- dcast(REPD, `Planning Authority` ~ `Development Status (short)`)

REPD[is.na(REPD)] <- 0

REPD$Pipeline <- REPD$`Application Submitted`+REPD$`Awaiting Construction`+REPD$`Under Construction`

PlanningAuthorityLookup <- read_excel("Data Sources/REPD (Operational Corrections)/PlanningAuthorityLookup.xlsx")

LARenCap <- merge(PlanningAuthorityLookup,REPD, all.x = TRUE)

source("Processing Scripts/LACodeFunction.R")

LARenCap <- LACodeUpdate(LARenCap)

LARenCap[is.na(LARenCap)] <- 0

write.table(LARenCap[c(2:5,7:8,6)],
            "Output/Renewable Capacity/LARenCap.txt",
            sep = "\t",
            row.names = FALSE)
