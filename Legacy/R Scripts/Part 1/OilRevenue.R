library(readr)
library(readxl)
library(dplyr)

print("OilRevenue")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source Data ###
ScotOilRevenue <-
  read_excel("Data Sources/ScottishOilGas/Current.xlsx",
             sheet = "Table 2.1",
             skip = 4)

### Create Subset of only Calendar year data ###
ScotOilRevenue <- subset(ScotOilRevenue, is.na(ScotOilRevenue[2]))

### Remove excess columns ###
ScotOilRevenue[2:3]     <- NULL
ScotOilRevenue[3:4]     <- NULL
ScotOilRevenue[6:12]    <- NULL

### Remove first row ###
ScotOilRevenue          <- ScotOilRevenue[-1,]

### Rename Columns ###
names(ScotOilRevenue)   <-
  c("Year",
    "Total Oil Gas",
    "Other Income",
    "Operating Expenditure",
    "Capital Expenditure")

### Subset where Year is 4 characters long, which corresponds to rows with Calendar year info ###
ScotOilRevenue          <-
  subset(ScotOilRevenue, nchar(ScotOilRevenue$Year) == 4)

### Export to CSV ###
write.table(
  ScotOilRevenue,
  "R Data Output/ScotOilRevenue.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)