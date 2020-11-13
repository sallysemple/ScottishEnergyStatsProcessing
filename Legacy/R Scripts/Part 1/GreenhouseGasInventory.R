### Load Packages ###
library(readr)
library(readxl)
library(dplyr)

print("GreenhouseGasInventory")

###### THIS SCRIPT REQUIRES A MANUAL ADJUSTMENT TO THE SOURCE FILE ######
### When the Source Data file is downloaded, open it and expand       ###
### Business and Industrial Process in the the table so that          ###
### 1A1ai_Public_Electricity&Heat_Production is visible, then save.   ###
#########################################################################

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source File ###
GasInventory <-
  read_excel("Data Sources/Greenhouse Gas Inventory/Current.xlsm",
             skip = 3)
### Subset Necessary Row ###
GasInventory <-
  subset(
    GasInventory,
    GasInventory$`Row Labels` == "1A1ai_Public_Electricity&Heat_Production"
  )

write.table(
  GasInventory,
  "R Data Output/ElectricityProductionEmissions.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)