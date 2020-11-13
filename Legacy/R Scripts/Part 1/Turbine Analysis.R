### Ensure that no excel files are open when running this script ###

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("Turbine Analysis")

### Load Required Packages ###
library(readxl)
library(plyr)
library(readr)
library("writexl")

### Open Excel File and Extract Relevant Data ###

## read_excel reads .xlsx files, read_csv reads .csv files. ##
## If using csv file directly from the website, include the skip argument to remove excess lines at the top. ##

CurrentData <- read_excel("Data Sources/REPD Turbine Analysis/Current.xlsx",
                          sheet = "Database",
                          skip = 5)

### Add in site count of 1 for each site, for aggregation later ###

CurrentData$Sites <- 1

CurrentCorrections <- read_excel("Data Sources/REPD Turbine Analysis/CurrentCorrections.xlsx",
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
  "R Data Output/CurrentOffshore.txt",
  sep = "\t",
  row.names = FALSE
)

write.table(
  CurrentOnshoreTable,
  "R Data Output/CurrentOnshore.txt",
  sep = "\t",
  row.names = FALSE
)



###### REPEAT FOR PREVIOUS MONTH's DATA ######



PreviousData <- read_excel("Data Sources/REPD Turbine Analysis/Previous.xlsx",
                             sheet = "Database", skip = 5)

PreviousData$Sites <- 1

PreviousCorrections <- read_excel("Data Sources/REPD Turbine Analysis/PreviousCorrections.xlsx",
                                 sheet = "Database",
                                 skip = 5)

#CurrentCorrections$Sites <- 0

PreviousData <- rbind(PreviousData, PreviousCorrections)


#PreviousData <- read_csv("Data Sources/REPD - Turbine Analysis/Previous.csv", skip = 6)

### Create Subsets ###

ScotlandPrevious <- subset(PreviousData, Country == "Scotland")
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

#ScotlandPrevious$Sites <- 1

ScotTurbinePrevious <-
  subset(ScotlandPrevious,
         TechType == "Wind Onshore" | TechType == "Wind Offshore")
ScotTurbinePrevious <- subset(
  ScotTurbinePrevious,
  Status == "Operational"
  | Status == "Awaiting Construction"
  | Status == "Under Construction"
  | Status == "Application Submitted",
  select = c(TechType, Status, Sites, TurbineAmount, Capacity)
)

### Convert to Number fields and set missing values to 0, for calculations ###

ScotTurbinePrevious$TurbineAmount <-
  as.numeric(ScotTurbinePrevious$TurbineAmount)

ScotTurbinePrevious$TurbineAmount[is.na(ScotTurbinePrevious$TurbineAmount)] <-
  0

ScotTurbinePrevious$Capacity <-
  as.numeric(ScotTurbinePrevious$Capacity)

ScotTurbinePrevious$Capacity[is.na(ScotTurbinePrevious$Capacity)] <-
  0

### Split and aggregate ###

OffshorePrevious <-
  subset(ScotTurbinePrevious, TechType == "Wind Offshore")
OnshorePrevious <-
  subset(ScotTurbinePrevious, TechType == "Wind Onshore")

PreviousOffshoreTable  <-
  ddply(OffshorePrevious, .(Status), numcolwise(sum))
PreviousOnshoreTable   <-
  ddply(OnshorePrevious, .(Status), numcolwise(sum))

### Export to Excel Files ###


write.table(
  PreviousOffshoreTable,
  "R Data Output/PreviousOffshore.txt",
  sep = "\t",
  row.names = FALSE
)
write.table(
  PreviousOnshoreTable,
  "R Data Output/PreviousOnshore.txt",
  sep = "\t",
  row.names = FALSE
)

###### Further Instructions ######

# Open up Current Tables and Graphs Excel File,
# Open the data tab at the top
# click refresh all
# (or use the keyboard shortcut ctrl+alt+f5 when the file is opened)

