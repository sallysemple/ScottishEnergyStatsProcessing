library(readr)
library(readxl)
library(dplyr)
library(tidyr)

print("GasBills")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source File ###
GasBill <- read_excel("Data Sources/Energy Bills/CurrentGas.xlsx",
                      sheet = "Calculations",
                      skip = 4)

### Remove Excess Columns ###
GasBill[c(3,6,9,12,13,14,15)] <- NULL


### Rename Columns ###
names(GasBill) <-
  c(
    "Category",
    "Year",
    "Credit - E&W",
    "Credit - Scot",
    "DD - E&W",
    "DD - Scot",
    "Pre - E&W",
    "Pre - Scot"
  )

### Fill empty cells in the Category Column with the value of the cell above ###
GasBill <- fill(GasBill, Category)

### Change First and Second Columns to first 4 characters (cash/real for column 1, the year for column 2)
GasBill[1] <- substring(GasBill$Category, 1, 4)
GasBill[2] <- substring(GasBill$Year, 1, 4)

### Keep only Rows with 'real terms' numbers ###
GasBill <- subset(GasBill, Category == "Real")

### Remove First Column ###
GasBill[1] <- NULL

### Remove First Row ###
GasBill <- GasBill[-1, ]

### Export to CSV ###
write.table(
  GasBill,
  "R Data Output/GasBill.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)

### Regional Breakdown ###

CurrentGasRegion <- read_excel("Data Sources/Energy Bills/CurrentGasRegion.xlsx", 
                                sheet = "Table 2.3.3", skip = 4, n_max = 16)

CurrentGasRegion <- CurrentGasRegion[c(1,3,6,9,12)]

names(CurrentGasRegion) <- c("Region","Credit", "Direct Debit", "Prepayment", "Overall")

write.table(
  CurrentGasRegion,
  "R Data Output/GasBillRegion.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)

### GasUnitCosts

library(readr)
library(readxl)
library(dplyr)
library(tidyr)

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

GasUnitCosts <- read_excel("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/Data Sources/Energy Bills/CurrentGasUnit.xlsx", 
                           sheet = "2019 Gas", 
                           skip = 4)
GasUnitCosts <- GasUnitCosts[c(1,11,12)]

names(GasUnitCosts) <- c("Region", "Unit Cost", "Fixed Cost")

GasUnitCosts <- subset(GasUnitCosts, GasUnitCosts$Region == "North Scotland" | GasUnitCosts$Region == "South Scotland")

GasUnitCosts$Region <- substr(GasUnitCosts$Region, 1,1)

write.table(
  GasUnitCosts,
  "R Data Output/GasUnitCosts.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
