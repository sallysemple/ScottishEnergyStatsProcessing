library(readxl)
library(plyr)
library(readr)
library("writexl")
library(lubridate)
library(reshape2)

### Open Excel File and Extract Relevant Data ###

## read_excel reads .xlsx files, read_csv reads .csv files. ##
## If using csv file directly from the website, include the skip argument to remove excess lines at the top. ##

CurrentData <- read_excel("Data Sources/REPD (Operational Corrections)/Source/Current.xlsx",
                          sheet = "Database",
                          skip = 5)

### Add in site count of 1 for each site, for aggregation later ###

CurrentData$Sites <- 1

CurrentCorrections <- read_excel("Data Sources/REPD (Operational Corrections)/Corrections/Corrections.xlsx",
                                 sheet = "Database",
                                 skip = 5)

#CurrentCorrections$Sites <- 0

CurrentData <- rbind(CurrentData,CurrentCorrections)

### Read Source Data ###
#CurrentData <- read_csv("Data Sources/REPD/Current.csv", skip = 6)

### Create Scottish Subset ###
ScotlandCurrent <- subset(CurrentData, Country == "Scotland")


write.table(ScotlandCurrent,
            "Output/REPD (Operational Corrections)/REPD.txt",
            sep = "\t",
            row.names = FALSE)
