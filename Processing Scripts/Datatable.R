library(readxl)
library(plyr)
library(readr)
library("writexl")
library(lubridate)
library(reshape2)
library(magrittr)
library(tidyverse)
library(data.table)
library(dplyr)

print("OperationalCorrectionsREPD")

### Open Excel File and Extract Relevant Data ###

## read_excel reads .xlsx files, read_csv reads .csv files. ##
## If using csv file directly from the website, include the skip argument to remove excess lines at the top. ##

CurrentData <- read_excel("Data Sources/REPD (Operational Corrections)/Source/Current.xlsx",
                          sheet = "REPD")

### Add in site count of 1 for each site, for aggregation later ###

CurrentData$Sites <- 1

CurrentCorrections <- read_excel("Data Sources/REPD (Operational Corrections)/Corrections/Corrections.xlsx",
                                 sheet = "REPD")

#CurrentCorrections$Sites <- 0

CurrentData <- rbind(CurrentData,CurrentCorrections)

### Read Source Data ###
#CurrentData <- read_csv("Data Sources/REPD/Current.csv", skip = 6)

### Create Scottish Subset ###
REPD <- subset(CurrentData, Country == "Scotland")

REPD <- REPD[which(REPD$`Development Status (short)` %in% c("Under Construction", "Awaiting Construction", "Application Submitted" )),]

PlanningAuthorityLookup <- read_excel("Data Sources/REPD (Operational Corrections)/PlanningAuthorityLookup.xlsx")

REPD <- merge(REPD, PlanningAuthorityLookup, all.x = TRUE)

CountyLookup <- read_excel("Data Sources/REPD (Operational Corrections)/CountyLookup.xlsx")


REPDCounty <-  REPD[which(is.na(REPD$LACode)),]

REPDCounty$LA <- NULL

REPDCounty$LACode <- NULL

REPDCounty <- merge(REPDCounty, CountyLookup, all.x = TRUE)

REPD <- rbind(REPDCounty, REPD)

RefIDLookup <- read_excel("Data Sources/REPD (Operational Corrections)/RefIDLALookup.xlsx")


REPDIDLookup <-  REPD[which(is.na(REPD$LACode)),]

REPDIDLookup$LA <- NULL

REPDIDLookup$LACode <- NULL

REPDIDLookup <- merge(REPDIDLookup, RefIDLookup, all.x = TRUE)

REPD <- rbind(REPDIDLookup, REPD)

source("Processing Scripts/LACodeFunction.R")

REPD$LACode <- LACodeUpdate(REPD$LACode)

REPD <- REPD[c(1,7,8,11,21,50,51)]

REPD <- REPD[-which(is.na(REPD$LA)),]

REPD <- REPD[!duplicated(REPD),]

REPD <- REPD[which(REPD$`Technology Type` != "Battery"),]

REPD <- REPD[which(REPD$`Technology Type` != "Pumped Storage Hydroelectricity"),]

REPD <- REPD %>%  group_by(`Ref`,`Development Status (short)`) %>% 
  summarise(`Site Name` = first(`Site Name`), `Technology Type` = first (`Technology Type`), `Installed Capacity (MWelec)` = sum(`Installed Capacity (MWelec)`), LA = first(LA), LACode = first(LACode))

REPD[which(is.na(REPD$LACode)),]$LACode <- " "

names(REPD) <- c("REPD Ref", "Status", "Site Name", "Technology", "Capacity (MW)", "Local Authority", "LA Code")

write.csv(REPD, "Output/REPD (Operational Corrections)/PipelineDataTable.csv", row.names = FALSE)

# 
# REPDSummary <- REPD %>% group_by(`Technology Type`, `Development Status (short)`) %>% 
#   summarise(`Installed Capacity (MWelec)` = sum(`Installed Capacity (MWelec)`))
# 
# REPDSummary <- dcast(REPDSummary, `Technology Type` ~ `Development Status (short)`)
# 
# write.csv(REPDSummary, "Output/REPD (Operational Corrections)/DataTableSummary.csv", row.names = FALSE)


RESTATS <- read_excel("Offline Data Sources/Restats/Restats.xlsx",
              sheet = "Query13")


if ("Q4" %in% colnames(RESTATS)) # Checks if there is a Q4 column in the data
{
  if (sum(as.numeric(RESTATS$`Q4`), na.rm = TRUE) > 0) # Checks if the sum of that column is more than 0
  {
    RESTATS$Capacity <- RESTATS$`Q4` # Uses Q4 as the Capacity Column
    RESTATS$'Q4' <- NULL # Removes other Columns
    RESTATS$'Q3' <- NULL
    RESTATS$'Q2' <- NULL
    RESTATS$'Q1' <- NULL

  } else {
    RESTATS$'Q4' <- NULL # If Column exists but is 0, then removes column and checks Column 3.
  }
}

if ("Q3" %in% colnames(RESTATS))
{
  if (sum(as.numeric(RESTATS$`Q3`), na.rm = TRUE) > 0)
  {
    RESTATS$Capacity <- RESTATS$`Q3`
    RESTATS$'Q3' <- NULL
    RESTATS$'Q2' <- NULL
    RESTATS$'Q1' <- NULL

  } else {
    RESTATS$'Q3' <- NULL
  }
}

if ("Q2" %in% colnames(RESTATS))
{
  if (sum(as.numeric(RESTATS$`Q2`), na.rm = TRUE) > 0)
  {
    RESTATS$Capacity <- RESTATS$`Q2`
    RESTATS$'Q2' <- NULL
    RESTATS$'Q1' <- NULL

  } else {
    RESTATS$'Q2' <- NULL
  }
}

if ("Q1" %in% colnames(RESTATS))
{
  if (sum(as.numeric(RESTATS$`Q1`), na.rm = TRUE) > 0)
  {
    RESTATS$Capacity <- RESTATS$`Q1`

    RESTATS$'Q1' <- NULL

  } else {
    RESTATS$'Q1' <- NULL
  }
}

RESTATS <- RESTATS[which(RESTATS$Country == "Scotland"),]

RESTATS <- RESTATS[c(2,5,6,67)]

RESTATS <- RESTATS[which(RESTATS$Capacity > 0),]

sum(RESTATS$Capacity)

RESTATS <- RESTATS[order(RESTATS$RenewableArea, RESTATS$ProjectName, RESTATS$SiteName),]

names(RESTATS) <- c("Technology", "Project Name", "Site Name", "Operational Capacity (MW)")

write.csv(RESTATS, "Output/REPD (Operational Corrections)/OperationalDataTable.csv", row.names = FALSE)
