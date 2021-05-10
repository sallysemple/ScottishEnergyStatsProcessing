library(readxl)
library(plyr)
library(readr)
library("writexl")
library(lubridate)
library(reshape2)


print("TurbineAnalysis")
### Open Excel File and Extract Relevant Data ###

## read_excel reads .xlsx files, read_csv reads .csv files. ##
## If using csv file directly from the website, include the skip argument to remove excess lines at the top. ##

CurrentData <- read_excel("Data Sources/REPD (Turbines)/Source/Current.xlsx",
                          sheet = "REPD")



### Add in site count of 1 for each site, for aggregation later ###

CurrentData$Sites <- 1

CurrentCorrections <- read_excel("Data Sources/REPD (Turbines)/Corrections/CurrentCorrections.xlsx",
                                 sheet = "Database")

#CurrentCorrections$Sites <- 0

CurrentData <- rbind(CurrentData,CurrentCorrections)

### Read Source Data ###
#CurrentData <- read_csv("Data Sources/REPD/Current.csv", skip = 6)

### Create Scottish Subset ###
ScotlandCurrent <- subset(CurrentData, Country == "Scotland")

### Rename Variables ###
ScotlandCurrent <-
  plyr::rename(
    ScotlandCurrent,
    c(
      "Technology Type" = "TechType",
      "Development Status (short)" =
        "Status",
      "No. of Turbines" = "TurbineAmount",
      "Installed Capacity (MWelec)" =
        "Capacity"
    )
  )

unique(ScotlandCurrent$Status)

ScotlandCurrent$Capacity[is.na(ScotlandCurrent$Capacity)] <- 0


ScotlandCurrent <- ScotlandCurrent[which(ScotlandCurrent$TechType %in% c("Battery", "Pumped Storage Hydroelectricity")),]

ScotlandCurrent <- ScotlandCurrent[which(ScotlandCurrent$Status %in% c("Awaiting Construction", "Operational", "Application Submitted","Under Construction")),]

ScotlandCurrent <- ScotlandCurrent %>% group_by(TechType, Status) %>% summarise(Capacity = sum(Capacity)) %>% dcast(TechType ~ Status)

ScotlandCurrent$Pipeline <- rowSums(ScotlandCurrent[2:ncol(ScotlandCurrent)]) - ScotlandCurrent$Operational

ScotlandCurrent <- rbind(ScotlandCurrent, c("Total", colSums(ScotlandCurrent[2:ncol(ScotlandCurrent)])))

write.csv(
  ScotlandCurrent,
  "Output/Renewable Capacity/Storage.csv"
)
      