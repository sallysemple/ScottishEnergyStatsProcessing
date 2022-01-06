library(readxl)
library(plyr)
library(dplyr)
library(readr)
library("writexl")
library(lubridate)
library(reshape2)
library(tidyverse)

print("OperationalCorrectionsREPD")

### Open Excel File and Extract Relevant Data ###

## read_excel reads .xlsx files, read_csv reads .csv files. ##
## If using csv file directly from the website, include the skip argument to remove excess lines at the top. ##

CurrentData <- read_excel("Data Sources/REPD (Operational Corrections)/Source/Current.xlsx",
                          sheet = "REPD")

### Add in site count of 1 for each site, for aggregation later ###

CurrentData$Sites <- 1

CurrentData$`No. of Turbines`<- as.numeric(as.character(CurrentData$`No. of Turbines`))

CurrentCorrections <- read_excel("Data Sources/REPD (Operational Corrections)/Corrections/Corrections.xlsx",
                                 sheet = "REPD")

#CurrentCorrections$Sites <- 0

CurrentData <- rbind(CurrentData,CurrentCorrections)

### Read Source Data ###
#CurrentData <- read_csv("Data Sources/REPD/Current.csv", skip = 6)

### Create Scottish Subset ###
ScotlandCurrent <- subset(CurrentData, Country == "Scotland")

REPD <- ScotlandCurrent[c(2,5,6,9,15,19,27,21,23,47)]

REPD <- subset(REPD, `Technology Type` %in% c("Biomass (co-firing)", "EfW Incineration" ,"Biomass (dedicated)", "Advanced Conversion Technologies", "Anaerobic Digestion", "Large Hydro", "Small Hydro","Landfill Gas", "Solar Photovoltaics", "Sewage Sludge Digestion", "Tidal Barrage and Tidal Stream", "Shoreline Wave", "Wind Offshore", "Wind Onshore", "Hot Dry Rocks (HDR)"))

REPD <- REPD %>% 
  mutate(`Technology Type` = replace(`Technology Type`, `Technology Type` == "Tidal Barrage and Tidal Stream", "Shoreline wave / tidal")) %>% 
  mutate(`Technology Type` = replace(`Technology Type`, `Technology Type` == "Shoreline Wave", "Shoreline wave / tidal"))

REPD <- REPD[which(REPD$`Development Status (short)` %in% c("Operational", "Awaiting Construction", "Under Construction", "Application Submitted")),]

REPD <- REPD %>%  group_by(`Ref`,`Planning Authority`, `Technology Type`, `County`, `Development Status (short)`, `Operational`) %>% 
  summarise(`Installed Capacity (MWelec)` = sum(`Installed Capacity (MWelec)`, na.rm = TRUE),
            `No. of Turbines` = sum(as.numeric(as.character(`No. of Turbines`)), na.rm = TRUE))


PlanningAuthorityLookup <- read_excel("Data Sources/REPD (Operational Corrections)/PlanningAuthorityLookup.xlsx")

REPD <- merge(REPD, PlanningAuthorityLookup, all.x = TRUE)

CountyLookup <- read_excel("Data Sources/REPD (Operational Corrections)/CountyLookup.xlsx")


REPDCounty <-  REPD[which(is.na(REPD$LACode)),]

REPDCounty$LA <- NULL

REPDCounty$LACode <- NULL

REPDCounty <- merge(REPDCounty, CountyLookup, all.x = TRUE)

REPD <- rbind(REPDCounty, REPD)

REPD = REPD[!duplicated(REPD$`Ref`),]


RefIDLookup <- read_excel("Data Sources/REPD (Operational Corrections)/RefIDLALookup.xlsx")


REPDIDLookup <-  REPD[which(is.na(REPD$LACode)),]

REPDIDLookup$LA <- NULL

REPDIDLookup$LACode <- NULL

REPDIDLookup <- merge(REPDIDLookup, RefIDLookup, all.x = TRUE)

REPD <- rbind(REPDIDLookup, REPD)

REPD[which(is.na(REPD$LACode)),]$LA <- "Offshore"

REPD = REPD[!duplicated(REPD$`Ref`),]

write.csv(REPD, "Output/REPD (Operational Corrections)/REPD.csv")
