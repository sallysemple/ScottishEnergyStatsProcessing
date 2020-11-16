library(readr)
library(readxl)
library(dplyr)
library(tidyr)

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("ElectricityBills")

### Read Source File ###
ElectricityBill <-
  read_excel(
    "Data Sources/Energy Bills/CurrentElectricity.xlsx",
    sheet = "Table 2.2.2 (St) 3,800 kWh",
    skip = 4
  )

### Remove Unneccessary Columns, by number ###
ElectricityBill[5:6] <- NULL
ElectricityBill[7:8] <- NULL
ElectricityBill[9] <- NULL

### Rename Columns ###
names(ElectricityBill) <-
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
ElectricityBill <- fill(ElectricityBill, Category)

### Change First and Second Columns to first 4 characters (cash/real for column 1, the year for column 2) ###
ElectricityBill[1] <- substring(ElectricityBill$Category, 1, 4)
ElectricityBill[2] <- substring(ElectricityBill$Year, 1, 4)

### Keep only Rows with 'real terms' numbers ###
ElectricityBill <- subset(ElectricityBill, Category == "Real")

### Remove First Column ###
ElectricityBill[1] <- NULL

### Remove First Row ###
ElectricityBill <- ElectricityBill[-1,]

### Export to CSV ###
write.table(
  ElectricityBill,
  "R Data Output/ElectricityBill.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)

### Regional Breakdown ###

CurrentElecRegion <- read_excel("Data Sources/Energy Bills/CurrentElecRegion.xlsx", 
                                sheet = "Table 2.2.3", skip = 5, n_max = 16)

CurrentElecRegion <- CurrentElecRegion[c(1,3,6,9,12)]

names(CurrentElecRegion) <- c("Region","Credit", "Direct Debit", "Prepayment", "Overall")

write.table(
  CurrentElecRegion,
  "R Data Output/ElectricityBillRegion.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)

### Electricity Unit Costs

library(readr)
library(readxl)
library(dplyr)
library(tidyr)

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

ElecUnitCosts <- read_excel("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/Data Sources/Energy Bills/CurrentElecUnit.xlsx", 
                            sheet = "2019 Standard Electricity", 
                            skip = 4)
ElecUnitCosts <- ElecUnitCosts[c(1,11,12)]

names(ElecUnitCosts) <- c("Region", "Unit Cost", "Fixed Cost")

ElecUnitCosts <- subset(ElecUnitCosts, ElecUnitCosts$Region == "North Scotland" | ElecUnitCosts$Region == "South Scotland")

ElecUnitCosts$Region <- substr(ElecUnitCosts$Region, 1,1)

write.table(
  ElecUnitCosts,
  "R Data Output/ElecUnitCosts.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
