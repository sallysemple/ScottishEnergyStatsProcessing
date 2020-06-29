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
                          sheet = "Database",
                          skip = 5)

### Add in site count of 1 for each site, for aggregation later ###

CurrentData$Sites <- 1

CurrentCorrections <- read_excel("Data Sources/REPD (Turbines)/Corrections/CurrentCorrections.xlsx",
                                 sheet = "Database",
                                 skip = 5)

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

### Create Subset of Turbines of the correct status.###
## Vertical Line is an OR operator ##

### Subset only Wind Tech ###
ScotTurbineCurrent <-
  subset(ScotlandCurrent,
         TechType == "Wind Onshore" | TechType == "Wind Offshore")

### Keep only required Status ###
ScotTurbineCurrent <- subset(
  ScotTurbineCurrent,
  Status == "Operational"
  | Status == "Awaiting Construction"
  | Status == "Under Construction"
  | Status == "Application Submitted"
  ,  select = c(TechType, Status, Sites, TurbineAmount, Capacity)
)

### Convert to Number fields and set missing values to 0, for calculations ###
ScotTurbineCurrent$TurbineAmount <-
  as.numeric(ScotTurbineCurrent$TurbineAmount)

### Change NA values to 0 ###
ScotTurbineCurrent$TurbineAmount[is.na(ScotTurbineCurrent$TurbineAmount)] <-
  0

### Make Capacity Column numeric ###
ScotTurbineCurrent$Capacity <-
  as.numeric(ScotTurbineCurrent$Capacity)

### Make NA Values 0 ###
ScotTurbineCurrent$Capacity[is.na(ScotTurbineCurrent$Capacity)] <- 0

### Split data into Onshore and Offshore ###

### Offshore Subset ###
OffshoreCurrent <-
  subset(ScotTurbineCurrent, TechType == "Wind Offshore")

### Onshore Subset ###
OnshoreCurrent <-
  subset(ScotTurbineCurrent, TechType == "Wind Onshore")

### Sum up Numerical Columns, to give totals ###

CurrentOffshoreTable  <-
  ddply(OffshoreCurrent, .(Status), numcolwise(sum))

CurrentOnshoreTable   <-
  ddply(OnshoreCurrent, .(Status), numcolwise(sum))

### Export to CSV Files ###


write.table(
  CurrentOffshoreTable,
  "Output/Turbine Analysis/Quarterly/CurrentOffshore.txt",
  sep = "\t",
  row.names = FALSE
)

write.table(
  CurrentOnshoreTable,
  "Output/Turbine Analysis/Quarterly/CurrentOnshore.txt",
  sep = "\t",
  row.names = FALSE
)

CurrentAllWindTable <-
  ddply(ScotTurbineCurrent, .(Status), numcolwise(sum))

write.table(
  CurrentAllWindTable,
  "Output/Turbine Analysis/Quarterly/CurrentAll.txt",
  sep = "\t",
  row.names = FALSE
)

Date <- as.character(CurrentData$`Record Last Updated (dd/mm/yyyy)`)

Date <- ymd(max(Date[which(substr(Date,6,7) %in% c("03", "06", "09", "12"))])) 


CurrentAllWindTable$Month <- format(Date, "%b-%y")


### Sites

TimeSeriesSites <- CurrentAllWindTable[c(5,1,2)]

TimeSeriesSites <- dcast(TimeSeriesSites, Month ~ Status, value.var = "Sites")

write.csv(TimeSeriesSites, paste0("Output/Turbine Analysis/Time Series/Sites/",format(Date, "%b-%y"),".csv"), row.names = FALSE)

### Turbines

TimeSeriesTurbines <- CurrentAllWindTable[c(5,1,3)]

TimeSeriesTurbines <- dcast(TimeSeriesTurbines, Month ~ Status, value.var = "TurbineAmount")

write.csv(TimeSeriesTurbines, paste0("Output/Turbine Analysis/Time Series/Turbines/",format(Date, "%b-%y"),".csv"), row.names = FALSE)


###Capacity

TimeSeriesCapacity <- CurrentAllWindTable[c(5,1,4)]

TimeSeriesCapacity <- dcast(TimeSeriesCapacity, Month ~ Status, value.var = "Capacity")

write.csv(TimeSeriesCapacity, paste0("Output/Turbine Analysis/Time Series/Capacity/",format(Date, "%b-%y"),".csv"), row.names = FALSE)




############



PreviousData <- read_excel("Data Sources/REPD (Turbines)/Source/Previous.xlsx",
                          sheet = "Database",
                          skip = 5)

### Add in site count of 1 for each site, for aggregation later ###

PreviousData$Sites <- 1

PreviousCorrections <- read_excel("Data Sources/REPD (Turbines)/Corrections/PreviousCorrections.xlsx",
                                 sheet = "Database",
                                 skip = 5)

#PreviousCorrections$Sites <- 0

PreviousData <- rbind(PreviousData,PreviousCorrections)

### Read Source Data ###
#PreviousData <- read_csv("Data Sources/REPD/Previous.csv", skip = 6)

### Create Scottish Subset ###
ScotlandPrevious <- subset(PreviousData, Country == "Scotland")

### Rename Variables ###
ScotlandPrevious <-
  plyr::rename(
    ScotlandPrevious,
    c(
      "Technology Type" = "TechType",
      "Development Status (short)" =
        "Status",
      "No. of Turbines" = "TurbineAmount",
      "Installed Capacity (MWelec)" =
        "Capacity"
    )
  )

### Create Subset of Turbines of the correct status.###
## Vertical Line is an OR operator ##

### Subset only Wind Tech ###
ScotTurbinePrevious <-
  subset(ScotlandPrevious,
         TechType == "Wind Onshore" | TechType == "Wind Offshore")

### Keep only required Status ###
ScotTurbinePrevious <- subset(
  ScotTurbinePrevious,
  Status == "Operational"
  | Status == "Awaiting Construction"
  | Status == "Under Construction"
  | Status == "Application Submitted"
  ,  select = c(TechType, Status, Sites, TurbineAmount, Capacity)
)

### Convert to Number fields and set missing values to 0, for calculations ###
ScotTurbinePrevious$TurbineAmount <-
  as.numeric(ScotTurbinePrevious$TurbineAmount)

### Change NA values to 0 ###
ScotTurbinePrevious$TurbineAmount[is.na(ScotTurbinePrevious$TurbineAmount)] <-
  0

### Make Capacity Column numeric ###
ScotTurbinePrevious$Capacity <-
  as.numeric(ScotTurbinePrevious$Capacity)

### Make NA Values 0 ###
ScotTurbinePrevious$Capacity[is.na(ScotTurbinePrevious$Capacity)] <- 0

### Split data into Onshore and Offshore ###

### Offshore Subset ###
OffshorePrevious <-
  subset(ScotTurbinePrevious, TechType == "Wind Offshore")

### Onshore Subset ###
OnshorePrevious <-
  subset(ScotTurbinePrevious, TechType == "Wind Onshore")

### Sum up Numerical Columns, to give totals ###

PreviousOffshoreTable  <-
  ddply(OffshorePrevious, .(Status), numcolwise(sum))

PreviousOnshoreTable   <-
  ddply(OnshorePrevious, .(Status), numcolwise(sum))

### Export to CSV Files ###


write.table(
  PreviousOffshoreTable,
  "Output/Turbine Analysis/Quarterly/PreviousOffshore.txt",
  sep = "\t",
  row.names = FALSE
)

write.table(
  PreviousOnshoreTable,
  "Output/Turbine Analysis/Quarterly/PreviousOnshore.txt",
  sep = "\t",
  row.names = FALSE
)

PreviousAllWindTable <-
  ddply(ScotTurbinePrevious, .(Status), numcolwise(sum))

write.table(
  PreviousOnshoreTable,
  "Output/Turbine Analysis/Quarterly/PreviousAll.txt",
  sep = "\t",
  row.names = FALSE
)
