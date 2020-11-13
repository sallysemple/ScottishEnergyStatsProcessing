library(readr)
library(readxl)
library(dplyr)

print("ScottishOIlShare")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source Data ###
ScotOilShare <-
  read_excel("Data Sources/ScottishOilGas/Current.xlsx",
             sheet = "Table 1.1",
             skip = 3)

### Keep only Rows which deal with calendar years, as they have nothing in column 2 ###
ScotOilShare <- subset(ScotOilShare, is.na(ScotOilShare[2]))

### Remove Unneccesary Columns ###
ScotOilShare[2:3]     <- NULL
ScotOilShare[7]       <- NULL
ScotOilShare[4:5]     <- NULL
ScotOilShare[7:8]     <- NULL

### Remove first row ###
ScotOilShare          <- ScotOilShare[-1,]

### Rename Columns ###
names(ScotOilShare) <-
  c("Year",
    "Total",
    "Crude Oil and NGL",
    "Natural Gas",
    "Total %",
    "Crude Oil %",
    "Gas %")

### Subset of rows where the year column is 4 characters long. This keeps only those rows dealing with years ###
ScotOilShare          <-
  subset(ScotOilShare, nchar(ScotOilShare$Year) == 4)

### Export to CSV ###
write.table(
  ScotOilShare,
  "R Data Output/ScotOilShare.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)