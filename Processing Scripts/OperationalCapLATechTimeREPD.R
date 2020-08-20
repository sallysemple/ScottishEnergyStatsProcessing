library(plyr)
library(dplyr)
library(readr)
library(readxl)
library(tidyverse)
library(reshape2)
library(readr)
library(lubridate)
library(zoo)

print("OperactionalCapByLA")



#REPD <- read_excel("C:/Users/ische/Downloads/renewable-energy-planning-database-december-2019.xlsx", 
#sheet = "Database", skip = 6)
REPD <- read_delim("Output/REPD (Operational Corrections)/REPD.txt", 
                      "\t", escape_double = FALSE, trim_ws = TRUE)


REPD <- REPD[c(2,5,6,9,19,27,21,23,47)]

REPD <- subset(REPD, `Technology Type` %in% c("Biomass (co-firing)", "EfW Incineration" ,"Biomass (dedicated)", "Advanced Conversion Technologies", "Anaerobic Digestion", "Large Hydro", "Small Hydro","Landfill Gas", "Solar Photovoltaics", "Sewage Sludge Digestion", "Tidal Barrage and Tidal Stream", "Shoreline Wave", "Wind Offshore", "Wind Onshore", "Hot Dry Rocks (HDR)"))

REPD <- REPD %>% 
  mutate(`Technology Type` = replace(`Technology Type`, `Technology Type` == "Tidal Barrage and Tidal Stream", "Shoreline wave / tidal")) %>% 
  mutate(`Technology Type` = replace(`Technology Type`, `Technology Type` == "Shoreline Wave", "Shoreline wave / tidal"))

REPD <- REPD[which(REPD$`Development Status (short)` %in% c("Operational", "Awaiting Construction", "Under Construction", "Application Submitted")),]

REPD <- REPD %>%  group_by(`Ref ID`,`Planning Authority`, `Technology Type`, `County`, `Development Status (short)`, `Operational`) %>% 
  summarise(`Installed Capacity (MWelec)` = sum(`Installed Capacity (MWelec)`, na.rm = TRUE))


PlanningAuthorityLookup <- read_excel("Data Sources/REPD (Operational Corrections)/PlanningAuthorityLookup.xlsx")

REPD <- merge(REPD, PlanningAuthorityLookup, all.x = TRUE)

CountyLookup <- read_excel("Data Sources/REPD (Operational Corrections)/CountyLookup.xlsx")


REPDCounty <-  REPD[which(is.na(REPD$LACode)),]

REPDCounty$LA <- NULL

REPDCounty$LACode <- NULL

REPDCounty <- merge(REPDCounty, CountyLookup, all.x = TRUE)

REPD <- rbind(REPDCounty, REPD)

REPD = REPD[!duplicated(REPD$`Ref ID`),]


RefIDLookup <- read_excel("Data Sources/REPD (Operational Corrections)/RefIDLALookup.xlsx")


REPDIDLookup <-  REPD[which(is.na(REPD$LACode)),]

REPDIDLookup$LA <- NULL

REPDIDLookup$LACode <- NULL

REPDIDLookup <- merge(REPDIDLookup, RefIDLookup, all.x = TRUE)

REPD <- rbind(REPDIDLookup, REPD)

REPD = REPD[!duplicated(REPD$`Ref ID`),]

REPD <- REPD %>%  group_by(`LA`, `LACode`, `Development Status (short)`, `Technology Type`, `Operational`) %>% 
  summarise(`Installed Capacity (MWelec)` = sum(`Installed Capacity (MWelec)`, na.rm = TRUE))

REPD <- REPD[which(REPD$`Development Status (short)` == "Operational"),]

REPD[which(is.na(REPD$LA)),]$LA <- "Offshore"

REPD$Operational <- substr(REPD$Operational,1,4)

REPD <- dcast(REPD, LA + LACode + `Technology Type` ~ Operational, value.var = "Installed Capacity (MWelec)", fun.aggregate = sum)

for( i in 5:ncol(REPD)){
  REPD[i] <- REPD[i] + REPD[i-1]
}

REPD <- melt(REPD)

REPD$LACode <- NULL

REPD$variable <- as.numeric(as.character(REPD$variable))

REPD <- REPD[which(REPD$variable >1999),]

names(REPD) <- c("LA", "Tech", "Year", "Capacity")

REPD <- dcast(REPD, Tech + Year ~ LA)

REPD[is.na(REPD)] <- 0

REPD <- melt(REPD, id.vars = c("Year", "Tech"))

names(REPD)[3:4] <- c("LA", "Capacity")

REPD <- dcast(REPD, Year + LA ~ Tech)

REPD$Total <- rowSums(REPD[3:13])

write.table(REPD,
            "Output/Renewable Capacity/LARenCapTechTimeREPD.txt",
            sep = "\t",
            row.names = FALSE)
