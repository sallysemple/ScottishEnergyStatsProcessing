### Ensure no excel files are open when running this script ###

### Load Required Packages ###
library(readxl)
library(readr)
library("writexl")
library(plyr)
library(dplyr)

print("REPD")

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Open Excel File and Extract Relevant Data ###

## read_excel reads .xlsx files, read_csv reads .csv files. ##
## If using csv file directly from the website, include the skip argument to remove excess lines at the top. ##
CurrentData <- read_excel("Data Sources/REPD/Current.xlsx",
                          sheet = "Database",
                          skip = 5)

### Add in site count of 1 for each site, for aggregation later ###

CurrentData$Sites <- 1

CurrentCorrections <- read_excel("Data Sources/REPD/Corrections.xlsx",
                                 sheet = "Database",
                                 skip = 5)

#CurrentCorrections$Sites <- 0

CurrentData <- rbind(CurrentData,CurrentCorrections)



### Rename Variables ###
CurrentData <-
  plyr::rename(
    CurrentData,
    c(
      "Technology Type" = "TechType",
      "Storage Type" = "StorageType",
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
  Country == "Scotland",
  select = c(
    "OldRef",
    "Ref",
    "TechType",
    "StorageType",
    "Status",
    "Capacity",
    "TurbineAmount",
    "Operator",
    "Site",
    "County",
    "Address",
    "PostCode",
    "Authority",
    "Country",
    "Sites"
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
    "StorageType",
    "Status",
    "Capacity",
    "TurbineAmount",
    "Operator",
    "Site",
    "County",
    "Address",
    "PostCode",
    "Authority",
    "OldRef",
    "Sites"
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

DataTable <- DataTable %>% 
  group_by(Ref, Status) %>% 
  mutate(Capacity = sum(Capacity)) %>% 
  mutate(TurbineAmount = sum(as.numeric(TurbineAmount))) %>%  
  distinct()


### Order by LA

DataTable <- arrange(DataTable, LA, Site)

DataTable <- DataTable[which(DataTable$Capacity >0),]

### Export to CSV

write.table(
  DataTable,
  "R Data Output/DataTable.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

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

Merged$TurbineAmount <- as.numeric(Merged$TurbineAmount)
Merged$TurbineAmount[is.na(Merged$TurbineAmount)] <- 0
Merged$StorageType <- as.factor(Merged$StorageType)


ScotlandREPD <- Merged %>% dplyr::group_by(LA, TechType, Status) %>% dplyr::summarise(Capacity = sum(Capacity), TurbineAmount = sum(TurbineAmount), Sites = sum(Sites), StorageType = paste(StorageType, collapse = ","))

ScotlandREPD$Lookup <- paste0(ScotlandREPD$LA, ScotlandREPD$TechType, ScotlandREPD$Status) 

write.table(
  ScotlandREPD[c(1:3, 8, 4:7)],
  "R Data Output/ScotlandREPD.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


ScotlandNationalREPD <- Merged %>% dplyr::group_by(TechType, Status) %>% dplyr::summarise(Capacity = sum(Capacity), TurbineAmount = sum(TurbineAmount), Sites = sum(Sites), StorageType = paste(StorageType, collapse = ","))

ScotlandNationalREPD$Lookup <- paste0(ScotlandNationalREPD$TechType, ScotlandNationalREPD$Status)

write.table(
  ScotlandNationalREPD[c(1:2, 7, 3:6)],
  "R Data Output/ScotlandNationalREPD.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
