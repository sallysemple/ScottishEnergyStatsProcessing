### Ensure no excel files are open when running this script ###

### Load Required Packages ###
library(readxl)
library(readr)
library("writexl")
library(plyr)
library(dplyr)

print("Planning Table")

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Open Excel File and Extract Relevant Data ###

## read_excel reads .xlsx files, read_csv reads .csv files. ##
## If using csv file directly from the website, include the skip argument to remove excess lines at the top. ##

CurrentData <- read_excel("Data Sources/REPD/Current.xlsx", 
                          sheet = "Database", skip = 5)

CurrentData$Sites <- 1

Corrections <- read_excel("Data Sources/REPD/Corrections.xlsx", 
                          sheet = "Database", skip = 5)

CurrentData <- rbind(CurrentData, Corrections)

#CurrentData <- read_csv("Data Sources/REPD/Current.csv", skip = 6)

show(CurrentData)



### Rename Variables ###
CurrentData <-
  plyr::rename(
    CurrentData,
    c(
      "Technology Type" = "TechType",
      "Development Status (short)" =
        "Status",
      "No. of Turbines" = "TurbineAmount",
      "Installed Capacity (MWelec)" =
        "Capacity",
      "Old Ref ID" = "OldRef",
      "Ref ID" = "Ref",
      "Operator (or Applicant)" = "Operator",
      "Site Name" = "Site",
      "County" = "County",
      "Address" = "Address",
      "Post Code" = "PostCode",
      "Planning Authority" = "Authority"
    )
  )

### Create Scottish Subset ###
ScotlandCurrent <- subset(
  CurrentData,
  Country == "Scotland" & TechType != "Battery",
  select = c(
    "OldRef",
    "Ref",
    "TechType",
    "Status",
    "Capacity",
    "TurbineAmount",
    "Operator",
    "Site",
    "County",
    "Address",
    "PostCode",
    "Authority",
    "Country"
  )
)


### Generate LAs ###
ScotlandCurrent$LA <-        ifelse(ScotlandCurrent$Authority == "Aberdeen City Council", "Aberdeen City",
                             ifelse(ScotlandCurrent$Authority == "Aberdeenshire Council", "Aberdeenshire", 
                             ifelse(ScotlandCurrent$Authority == "Angus Council", "Angus",
                             ifelse(ScotlandCurrent$Authority == "Argyll and Bute Council", "Argyll and Bute",
                             ifelse(ScotlandCurrent$Authority == "Clackmannanshire Council", "Clackmannanshire", 
                             ifelse(ScotlandCurrent$Authority == "Comhairle nan Eilean Siar Council", "Na h-Eileanan an Iar/Western Isles",
                             ifelse(ScotlandCurrent$Authority == "Dumfries and Galloway Council", "Dumfries and Galloway", 
                             ifelse(ScotlandCurrent$Authority == "Dundee City Council", "Dundee City",
                             ifelse(ScotlandCurrent$Authority == "East Ayrshire Council", "East Ayrshire", 
                             ifelse(ScotlandCurrent$Authority == "East Lothian Council", "East Lothian",
                             ifelse(ScotlandCurrent$Authority == "East Renfrewshire Council", "East Renfrewshire", 
                             ifelse(ScotlandCurrent$Authority == "Edinburgh City Council", "Edinburgh City",
                             ifelse(ScotlandCurrent$Authority == "Falkirk Council", "Falkirk", 
                             ifelse(ScotlandCurrent$Authority == "Fife Council", "Fife",
                             ifelse(ScotlandCurrent$Authority == "Glasgow City Council", "Glasgow City", 
                             ifelse(ScotlandCurrent$Authority == "Highland Council", "Highland",
                             ifelse(ScotlandCurrent$Authority == "Inverclyde Council", "Inverclyde", 
                             ifelse(ScotlandCurrent$Authority == "Midlothian Council", "Midlothian",
                             ifelse(ScotlandCurrent$Authority == "Moray Council", "Moray", 
                             ifelse(ScotlandCurrent$Authority == "North Ayrshire Council", "North Ayrshire",
                             ifelse(ScotlandCurrent$Authority == "North Lanarkshire Council", "North Lanarkshire", 
                             ifelse(ScotlandCurrent$Authority == "Orkney Islands Council", "Orkney Islands",
                             ifelse(ScotlandCurrent$Authority == "Perth and Kinross Council", "Perth and Kinross", 
                             ifelse(ScotlandCurrent$Authority == "Renfrewshire Council", "Renfrewshire",
                             ifelse(ScotlandCurrent$Authority == "Scottish Borders Council", "Scottish Borders", 
                             ifelse(ScotlandCurrent$Authority == "Shetland Islands Council", "Shetland Islands",
                             ifelse(ScotlandCurrent$Authority == "South Ayrshire Council", "South Ayrshire", 
                             ifelse(ScotlandCurrent$Authority == "South Lanarkshire Council", "South Lanarkshire",
                             ifelse(ScotlandCurrent$Authority == "Stirling Council", "Stirling", 
                             ifelse(ScotlandCurrent$Authority == "West Dunbartonshire Council", "West Dunbartonshire",
                             ifelse(ScotlandCurrent$Authority == "West Lothian Council", "West Lothian", 
                                      NA)))))))))))))))))))))))))))))))

ScotlandCurrent$LA <-        ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Angus", "Angus",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Argyll and Bute", "Argyll and Bute",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Borders", "Scottish Borders",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Clackmannanshire", "Clackmannanshire",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Comhairle nan Eilean Siar", "Na h-Eileanan an Iar/Western Isles",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Dumfries and Galloway", "Dumfries and Galloway",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Dundee", "Dundee City",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "East Ayrshire", "East Ayrshire",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "East Lothian", "East Lothian",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "East Renfrewshire", "East Renfrewshire",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Falkirk", "Falkirk",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Fife", "Fife",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Glasgow City", "Glasgow City",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Highland", "Highland",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Midlothian", "Midlothian",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Moray", "Moray",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "North Ayrshire", "North Ayrshire",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "North Lanarkshire", "North Lanarkshire",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Offshore", "Offshore",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Orkney", "Orkney Islands",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Orkney Islands", "Orkney Islands",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Perth and Kinross", "Perth and Kinross",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Perth and Kinross", "Perth and Kinross",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Renfrewshire", "Renfrewshire",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Scottish Borders", "Scottish Borders",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Shetland Islands", "Shetland Islands",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "South Ayrshire", "South Ayrshire",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "South Lanarkshire", "South Lanarkshire",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Stirling", "Stirling",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "West Lothian", "West Lothian",
                             ifelse(is.na(ScotlandCurrent$LA) & ScotlandCurrent$County == "Western Isles", "Na h-Eileanan an Iar/Western Isles",
                                      ScotlandCurrent$LA )))))))))))))))))))))))))))))))

### Add in Local Authority Data ###

LALookup <-
  read_excel("Releases and Publications/Planning Tables/LALookup.xlsx")
Merged <- merge(LALookup,
                ScotlandCurrent,
                by = c("Ref"),
                all = TRUE)

## Combine LA Columns ##

Merged$LA <- ifelse(is.na(Merged$LA.x), Merged$LA.y, Merged$LA.x)

Merged <- subset(
  Merged,
  Country == "Scotland",
  select = c(
    "Ref",
    "LA",
    "TechType",
    "Status",
    "Capacity",
    "TurbineAmount",
    "Operator",
    "Site",
    "County",
    "Address",
    "PostCode",
    "Authority",
    "OldRef"
  )
)
### Create Excel Sheet of Missing LA's

MissingValues <- subset(Merged, is.na(LA))
write_xlsx(MissingValues,
           "Releases and Publications/Planning Tables/MissingLA.xlsx")

###### If there are any entries in MissingLA.xlsx, source the correct Authority and add it to LALookup.xlsx, and rerun the code ######


###### Create the Scottish Data Table for publishing Online ######

DataTable <- Merged[, c("Ref", 
                        "LA",
                        "Site",
                        "TechType",
                        "Capacity",
                        "Status",
                        "TurbineAmount")]
### Order by LA

DataTable <- arrange(DataTable, LA, Site)

### Export to CSV

write.table(
  DataTable,
  "R Data Output/DataTable.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### Add in site count of 1 for each site, for aggregation later ###

Merged$Sites <- 1

### Ensure Number fields are correctly assigned, and change missing Capacity values to 0, for later aggregation ###

Merged$Capacity <- as.numeric(Merged$Capacity)

Merged$Capacity[is.na(Merged$Capacity)] <- 0

### Create Subset using only the Data and Cases required ###

ScotlandInProgress <-
  subset(
    Merged,
    Status == "Awaiting Construction" |
      Status == "Under Construction" |
      Status == "Application Submitted",
    select = c(LA, TechType, Status, Sites, Capacity)
  )
write.table(
  ScotlandInProgress,
  "R Data Output/ScotlandCurrent.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

ScotlandTotal <- subset(Merged,
                        Status == "Operational",
                        select = c(LA, TechType, Status, Sites, Capacity))
write.table(
  ScotlandTotal,
  "R Data Output/ScotlandTotal.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Subset into Each Technology and Each Status,and aggregate to give Local Authority area totals ######

TotalIPbyLA <- subset(ScotlandInProgress, 
                      Status == "Application Submitted", 
                      select = c(LA, Sites, Capacity))
TotalIPbyLA <- ddply(TotalIPbyLA, .(LA), numcolwise(sum))
TotalIPbyLA <- plyr::rename(TotalIPbyLA, c("Sites"="Total_IP_Sites", "Capacity"="Total_IP_Capacity"))

TotalACbyLA <- subset(ScotlandInProgress, 
                      Status == "Awaiting Construction", 
                      select = c(LA, Sites, Capacity))
TotalACbyLA <- ddply(TotalACbyLA, .(LA), numcolwise(sum))
TotalACbyLA <- plyr::rename(TotalACbyLA, c("Sites"="Total_AC_Sites", "Capacity"="Total_AC_Capacity"))

TotalUCbyLA <- subset(ScotlandInProgress, 
                      Status == "Under Construction", 
                      select = c(LA, Sites, Capacity))
TotalUCbyLA <- ddply(TotalUCbyLA, .(LA), numcolwise(sum))
TotalUCbyLA <- plyr::rename(TotalUCbyLA, c("Sites"="Total_UC_Sites", "Capacity"="Total_UC_Capacity"))

### Advanced Conversion Technologues ###

ACTIPbyLA <- subset(ScotlandInProgress, 
                    Status == "Application Submitted" & TechType == "Advanced Conversion Technologies", 
                    select = c(LA, Sites, Capacity))
ACTIPbyLA <- ddply(ACTIPbyLA, .(LA), numcolwise(sum))
ACTIPbyLA <- plyr::rename(ACTIPbyLA, c("Sites"="ACT_IP_Sites", "Capacity"="ACT_IP_Capacity"))

ACTACbyLA <- subset(ScotlandInProgress, 
                    Status == "Awaiting Construction" & TechType == "Advanced Conversion Technologies", 
                    select = c(LA, Sites, Capacity))
ACTACbyLA <- ddply(ACTACbyLA, .(LA), numcolwise(sum))
ACTACbyLA <- plyr::rename(ACTACbyLA, c("Sites"="ACT_AC_Sites", "Capacity"="ACT_AC_Capacity"))

ACTUCbyLA <- subset(ScotlandInProgress, 
                    Status == "Under Construction" & TechType == "Advanced Conversion Technologies",
                    select = c(LA, Sites, Capacity))
ACTUCbyLA <- ddply(ACTUCbyLA, .(LA), numcolwise(sum))
ACTUCbyLA <- plyr::rename(ACTUCbyLA, c("Sites"="ACT_UC_Sites", "Capacity"="ACT_UC_Capacity"))

### Anaerobic Digestion ###

ADIPbyLA <- subset(ScotlandInProgress, 
                   Status == "Application Submitted" & TechType == "Anaerobic Digestion", 
                   select = c(LA, Sites, Capacity))
ADIPbyLA <- ddply(ADIPbyLA, .(LA), numcolwise(sum))
ADIPbyLA <- plyr::rename(ADIPbyLA, c("Sites"="AD_IP_Sites", "Capacity"="AD_IP_Capacity"))

ADACbyLA <- subset(ScotlandInProgress, 
                   Status == "Awaiting Construction" & TechType == "Anaerobic Digestion", 
                   select = c(LA, Sites, Capacity))
ADACbyLA <- ddply(ADACbyLA, .(LA), numcolwise(sum))
ADACbyLA <- plyr::rename(ADACbyLA, c("Sites"="AD_AC_Sites", "Capacity"="AD_AC_Capacity"))

ADUCbyLA <- subset(ScotlandInProgress, 
                   Status == "Under Construction" & TechType == "Anaerobic Digestion",
                   select = c(LA, Sites, Capacity))
ADUCbyLA <- ddply(ADUCbyLA, .(LA), numcolwise(sum))
ADUCbyLA <- plyr::rename(ADUCbyLA, c("Sites"="AD_UC_Sites", "Capacity"="AD_UC_Capacity"))

### Biomass (co-firing) ###

BcIPbyLA <- subset(ScotlandInProgress, 
                   Status == "Application Submitted" & TechType == "Biomass (co-firing)", 
                   select = c(LA, Sites, Capacity))
BcIPbyLA <- ddply(BcIPbyLA, .(LA), numcolwise(sum))
BcIPbyLA <- plyr::rename(BcIPbyLA, c("Sites"="Bc_IP_Sites", "Capacity"="Bc_IP_Capacity"))

BcACbyLA <- subset(ScotlandInProgress, 
                   Status == "Awaiting Construction" & TechType == "Biomass (co-firing)", 
                   select = c(LA, Sites, Capacity))
BcACbyLA <- ddply(BcACbyLA, .(LA), numcolwise(sum))
BcACbyLA <- plyr::rename(BcACbyLA, c("Sites"="Bc_AC_Sites", "Capacity"="Bc_AC_Capacity"))

BcUCbyLA <- subset(ScotlandInProgress, 
                   Status == "Under Construction" & TechType == "Biomass (co-firing)",
                   select = c(LA, Sites, Capacity))
BcUCbyLA <- ddply(BcUCbyLA, .(LA), numcolwise(sum))
BcUCbyLA <- plyr::rename(BcUCbyLA, c("Sites"="Bc_UC_Sites", "Capacity"="Bc_UC_Capacity"))

### Biomass (dedicated) ###

BdIPbyLA <- subset(ScotlandInProgress, 
                   Status == "Application Submitted" & TechType == "Biomass (dedicated)", 
                   select = c(LA, Sites, Capacity))
BdIPbyLA <- ddply(BdIPbyLA, .(LA), numcolwise(sum))
BdIPbyLA <- plyr::rename(BdIPbyLA, c("Sites"="Bd_IP_Sites", "Capacity"="Bd_IP_Capacity"))

BdACbyLA <- subset(ScotlandInProgress, 
                   Status == "Awaiting Construction" & TechType == "Biomass (dedicated)", 
                   select = c(LA, Sites, Capacity))
BdACbyLA <- ddply(BdACbyLA, .(LA), numcolwise(sum))
BdACbyLA <- plyr::rename(BdACbyLA, c("Sites"="Bd_AC_Sites", "Capacity"="Bd_AC_Capacity"))

BdUCbyLA <- subset(ScotlandInProgress, 
                   Status == "Under Construction" & TechType == "Biomass (dedicated)",
                   select = c(LA, Sites, Capacity))
BdUCbyLA <- ddply(BdUCbyLA, .(LA), numcolwise(sum))
BdUCbyLA <- plyr::rename(BdUCbyLA, c("Sites"="Bd_UC_Sites", "Capacity"="Bd_UC_Capacity"))

### EfW Incineration ###

EfWIPbyLA <- subset(ScotlandInProgress, 
                    Status == "Application Submitted" & TechType == "EfW Incineration", 
                    select = c(LA, Sites, Capacity))
EfWIPbyLA <- ddply(EfWIPbyLA, .(LA), numcolwise(sum))
EfWIPbyLA <- plyr::rename(EfWIPbyLA, c("Sites"="EfW_IP_Sites", "Capacity"="EfW_IP_Capacity"))

EfWACbyLA <- subset(ScotlandInProgress, 
                    Status == "Awaiting Construction" & TechType == "EfW Incineration", 
                    select = c(LA, Sites, Capacity))
EfWACbyLA <- ddply(EfWACbyLA, .(LA), numcolwise(sum))
EfWACbyLA <- plyr::rename(EfWACbyLA, c("Sites"="EfW_AC_Sites", "Capacity"="EfW_AC_Capacity"))

EfWUCbyLA <- subset(ScotlandInProgress, 
                    Status == "Under Construction" & TechType == "EfW Incineration",
                    select = c(LA, Sites, Capacity))
EfWUCbyLA <- ddply(EfWUCbyLA, .(LA), numcolwise(sum))
EfWUCbyLA <- plyr::rename(EfWUCbyLA, c("Sites"="EfW_UC_Sites", "Capacity"="EfW_UC_Capacity"))

### Landfill Gas ###

LGIPbyLA <- subset(ScotlandInProgress, 
                   Status == "Application Submitted" & TechType == "Landfill Gas", 
                   select = c(LA, Sites, Capacity))
LGIPbyLA <- ddply(LGIPbyLA, .(LA), numcolwise(sum))
LGIPbyLA <- plyr::rename(LGIPbyLA, c("Sites"="LG_IP_Sites", "Capacity"="LG_IP_Capacity"))

LGACbyLA <- subset(ScotlandInProgress, 
                   Status == "Awaiting Construction" & TechType == "Landfill Gas", 
                   select = c(LA, Sites, Capacity))
LGACbyLA <- ddply(LGACbyLA, .(LA), numcolwise(sum))
LGACbyLA <- plyr::rename(LGACbyLA, c("Sites"="LG_AC_Sites", "Capacity"="LG_AC_Capacity"))

LGUCbyLA <- subset(ScotlandInProgress, 
                   Status == "Under Construction" & TechType == "Landfill Gas",
                   select = c(LA, Sites, Capacity))
LGUCbyLA <- ddply(LGUCbyLA, .(LA), numcolwise(sum))
LGUCbyLA <- plyr::rename(LGUCbyLA, c("Sites"="LG_UC_Sites", "Capacity"="LG_UC_Capacity"))

### Large Hydro ###

LHIPbyLA <- subset(ScotlandInProgress, 
                   Status == "Application Submitted" & TechType == "Large Hydro", 
                   select = c(LA, Sites, Capacity))
LHIPbyLA <- ddply(LHIPbyLA, .(LA), numcolwise(sum))
LHIPbyLA <- plyr::rename(LHIPbyLA, c("Sites"="LH_IP_Sites", "Capacity"="LH_IP_Capacity"))

LHACbyLA <- subset(ScotlandInProgress, 
                   Status == "Awaiting Construction" & TechType == "Large Hydro", 
                   select = c(LA, Sites, Capacity))
LHACbyLA <- ddply(LHACbyLA, .(LA), numcolwise(sum))
LHACbyLA <- plyr::rename(LHACbyLA, c("Sites"="LH_AC_Sites", "Capacity"="LH_AC_Capacity"))

LHUCbyLA <- subset(ScotlandInProgress, 
                   Status == "Under Construction" & TechType == "Large Hydro",
                   select = c(LA, Sites, Capacity))
LHUCbyLA <- ddply(LHUCbyLA, .(LA), numcolwise(sum))
LHUCbyLA <- plyr::rename(LHUCbyLA, c("Sites"="LH_UC_Sites", "Capacity"="LH_UC_Capacity"))

### Shoreline Wave ###

SWIPbyLA <- subset(ScotlandInProgress, 
                   Status == "Application Submitted" & TechType == "Shoreline Wave", 
                   select = c(LA, Sites, Capacity))
SWIPbyLA <- ddply(SWIPbyLA, .(LA), numcolwise(sum))
SWIPbyLA <- plyr::rename(SWIPbyLA, c("Sites"="SW_IP_Sites", "Capacity"="SW_IP_Capacity"))

SWACbyLA <- subset(ScotlandInProgress, 
                   Status == "Awaiting Construction" & TechType == "Shoreline Wave", 
                   select = c(LA, Sites, Capacity))
SWACbyLA <- ddply(SWACbyLA, .(LA), numcolwise(sum))
SWACbyLA <- plyr::rename(SWACbyLA, c("Sites"="SW_AC_Sites", "Capacity"="SW_AC_Capacity"))

SWUCbyLA <- subset(ScotlandInProgress, 
                   Status == "Under Construction" & TechType == "Shoreline Wave",
                   select = c(LA, Sites, Capacity))
SWUCbyLA <- ddply(SWUCbyLA, .(LA), numcolwise(sum))
SWUCbyLA <- plyr::rename(SWUCbyLA, c("Sites"="SW_UC_Sites", "Capacity"="SW_UC_Capacity"))

### Small Hydro ###

SHIPbyLA <- subset(ScotlandInProgress, 
                   Status == "Application Submitted" & TechType == "Small Hydro", 
                   select = c(LA, Sites, Capacity))
SHIPbyLA <- ddply(SHIPbyLA, .(LA), numcolwise(sum))
SHIPbyLA <- plyr::rename(SHIPbyLA, c("Sites"="SH_IP_Sites", "Capacity"="SH_IP_Capacity"))

SHACbyLA <- subset(ScotlandInProgress, 
                   Status == "Awaiting Construction" & TechType == "Small Hydro", 
                   select = c(LA, Sites, Capacity))
SHACbyLA <- ddply(SHACbyLA, .(LA), numcolwise(sum))
SHACbyLA <- plyr::rename(SHACbyLA, c("Sites"="SH_AC_Sites", "Capacity"="SH_AC_Capacity"))

SHUCbyLA <- subset(ScotlandInProgress, 
                   Status == "Under Construction" & TechType == "Small Hydro",
                   select = c(LA, Sites, Capacity))
SHUCbyLA <- ddply(SHUCbyLA, .(LA), numcolwise(sum))
SHUCbyLA <- plyr::rename(SHUCbyLA, c("Sites"="SH_UC_Sites", "Capacity"="SH_UC_Capacity"))

### Solar Photovoltaics ###

SPIPbyLA <- subset(ScotlandInProgress, 
                   Status == "Application Submitted" & TechType == "Solar Photovoltaics", 
                   select = c(LA, Sites, Capacity))
SPIPbyLA <- ddply(SPIPbyLA, .(LA), numcolwise(sum))
SPIPbyLA <- plyr::rename(SPIPbyLA, c("Sites"="SP_IP_Sites", "Capacity"="SP_IP_Capacity"))

SPACbyLA <- subset(ScotlandInProgress, 
                   Status == "Awaiting Construction" & TechType == "Solar Photovoltaics", 
                   select = c(LA, Sites, Capacity))
SPACbyLA <- ddply(SPACbyLA, .(LA), numcolwise(sum))
SPACbyLA <- plyr::rename(SPACbyLA, c("Sites"="SP_AC_Sites", "Capacity"="SP_AC_Capacity"))

SPUCbyLA <- subset(ScotlandInProgress, 
                   Status == "Under Construction" & TechType == "Solar Photovoltaics",
                   select = c(LA, Sites, Capacity))
SPUCbyLA <- ddply(SPUCbyLA, .(LA), numcolwise(sum))
SPUCbyLA <- plyr::rename(SPUCbyLA, c("Sites"="SP_UC_Sites", "Capacity"="SP_UC_Capacity"))


### Tidal Barrage and Tidal Stream ###

TidalIPbyLA <- subset(ScotlandInProgress, 
                    Status == "Application Submitted" & TechType == "Tidal Barrage and Tidal Stream", 
                    select = c(LA, Sites, Capacity))
TidalIPbyLA <- ddply(TidalIPbyLA, .(LA), numcolwise(sum))
TidalIPbyLA <- plyr::rename(TidalIPbyLA, c("Sites"="Tidal_IP_Sites", "Capacity"="Tidal_IP_Capacity"))

TidalACbyLA <- subset(ScotlandInProgress, 
                    Status == "Awaiting Construction" & TechType == "Tidal Barrage and Tidal Stream", 
                    select = c(LA, Sites, Capacity))
TidalACbyLA <- ddply(TidalACbyLA, .(LA), numcolwise(sum))
TidalACbyLA <- plyr::rename(TidalACbyLA, c("Sites"="Tidal_AC_Sites", "Capacity"="Tidal_AC_Capacity"))

TidalUCbyLA <- subset(ScotlandInProgress, 
                    Status == "Under Construction" & TechType == "Tidal Barrage and Tidal Stream",
                    select = c(LA, Sites, Capacity))
TidalUCbyLA <- ddply(TidalUCbyLA, .(LA), numcolwise(sum))
TidalUCbyLA <- plyr::rename(TidalUCbyLA, c("Sites"="Tidal_UC_Sites", "Capacity"="Tidal_UC_Capacity"))

### Wind Offshore ###

WoffIPbyLA <- subset(ScotlandInProgress, 
                     Status == "Application Submitted" & TechType == "Wind Offshore", 
                     select = c(LA, Sites, Capacity))
WoffIPbyLA <- ddply(WoffIPbyLA, .(LA), numcolwise(sum))
WoffIPbyLA <- plyr::rename(WoffIPbyLA, c("Sites"="Woff_IP_Sites", "Capacity"="Woff_IP_Capacity"))

WoffACbyLA <- subset(ScotlandInProgress, 
                     Status == "Awaiting Construction" & TechType == "Wind Offshore", 
                     select = c(LA, Sites, Capacity))
WoffACbyLA <- ddply(WoffACbyLA, .(LA), numcolwise(sum))
WoffACbyLA <- plyr::rename(WoffACbyLA, c("Sites"="Woff_AC_Sites", "Capacity"="Woff_AC_Capacity"))

WoffUCbyLA <- subset(ScotlandInProgress, 
                     Status == "Under Construction" & TechType == "Wind Offshore",
                     select = c(LA, Sites, Capacity))
WoffUCbyLA <- ddply(WoffUCbyLA, .(LA), numcolwise(sum))
WoffUCbyLA <- plyr::rename(WoffUCbyLA, c("Sites"="Woff_UC_Sites", "Capacity"="Woff_UC_Capacity"))

### Wind Onshore ###

WonIPbyLA <- subset(ScotlandInProgress, 
                    Status == "Application Submitted" & TechType == "Wind Onshore", 
                    select = c(LA, Sites, Capacity))
WonIPbyLA <- ddply(WonIPbyLA, .(LA), numcolwise(sum))
WonIPbyLA <- plyr::rename(WonIPbyLA, c("Sites"="Won_IP_Sites", "Capacity"="Won_IP_Capacity"))

WonACbyLA <- subset(ScotlandInProgress, 
                    Status == "Awaiting Construction" & TechType == "Wind Onshore", 
                    select = c(LA, Sites, Capacity))
WonACbyLA <- ddply(WonACbyLA, .(LA), numcolwise(sum))
WonACbyLA <- plyr::rename(WonACbyLA, c("Sites"="Won_AC_Sites", "Capacity"="Won_AC_Capacity"))

WonUCbyLA <- subset(ScotlandInProgress, 
                    Status == "Under Construction" & TechType == "Wind Onshore",
                    select = c(LA, Sites, Capacity))
WonUCbyLA <- ddply(WonUCbyLA, .(LA), numcolwise(sum))
WonUCbyLA <- plyr::rename(WonUCbyLA, c("Sites"="Won_UC_Sites", "Capacity"="Won_UC_Capacity"))

########################################################################################

### Recombine into dataset for use by excel, attaching to a master list of all Scottish Local Authorities, plus Scotland ###
## This list ensures that Offshore is at the bottom, and any LA with 0 projects at any stage is still included in the output ##
MasterLA <- read_csv("Data Sources/Additional R Files/MasterLA.csv")

FinalOutput <- join_all(list(MasterLA,
                             TotalIPbyLA, TotalACbyLA, TotalUCbyLA, #Total
                             ACTIPbyLA, ACTACbyLA, ACTUCbyLA, #Advanced Conversion Technologies
                             ADIPbyLA, ADACbyLA, ADUCbyLA, #Anaerobic Digestion
                             BcIPbyLA, BcACbyLA, BcUCbyLA, #Biomass (Co-firing)
                             BdIPbyLA, BdACbyLA, BdUCbyLA, #Biomass (dedicated)
                             EfWIPbyLA, EfWACbyLA, EfWUCbyLA, #EfW Incineration
                             LGIPbyLA, LGACbyLA, LGUCbyLA, #Landfill Gas 
                             LHIPbyLA, LHACbyLA, LHUCbyLA, #Large Hydro
                             SWIPbyLA, SWACbyLA, SWUCbyLA, #Shoreline Wave
                             SHIPbyLA, SHACbyLA, SHUCbyLA, #Small Hydro
                             SPIPbyLA, SPACbyLA, SPUCbyLA, #Solar Photovoltaics
                             TidalIPbyLA, TidalACbyLA, TidalUCbyLA, #Tidal Barrage and Tidal Stream
                             WoffIPbyLA, WoffACbyLA, WoffUCbyLA, #Wind Offshore
                             WonIPbyLA, WonACbyLA, WonUCbyLA), #Wind Onshore 
                                by="LA", type='left')

FinalOutput <- arrange(FinalOutput, Posistion)

### Export for use by Excel. Update Data Connections when this script is complete. ###
write.table(FinalOutput,"R Data Output/FinalOutput.txt", sep="\t", na="0", row.names = FALSE)

