library(readxl)

print("OilGasGDP")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Load Accounts Data ###
OilGasGDP <-
  read_excel(
    "Data Sources/Quarterly National Accounts/Current.xlsx",
    sheet = "Table B",
    skip = 5
  )
### Create Subset with only relevant data ###
# is.na(GDP$Quarter2) means that only the rows where there is nothing in that column are extracted.
# This corresponds to GDP in Calendar years.
OilGasGDP <- subset(OilGasGDP, is.na(OilGasGDP[2]))

### Remove excess rows from the bottom ###
#OilGasGDP <- head(OilGasGDP,-16)

### Remove Excess Columns ###
OilGasGDP[2] <- NULL
OilGasGDP[3] <- NULL
OilGasGDP[4:7] <- NULL

### Rename Columns ###
names(OilGasGDP) <-
  c("Year", "ScotlandGDP", "ScotlandIncludingExtraGDP")

### Export to CSV ###
write.table(
  OilGasGDP,
  "R Data Output/OilGasGDP.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
