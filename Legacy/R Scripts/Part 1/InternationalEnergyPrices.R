### Load Packages
library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)

print("InternationalEnergyPrices")

### Set the Working Directory for the Scripts ###

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

CurrentElectricity <-
  read_excel(
    "Data Sources/International Energy Prices/CurrentElectricity.xlsx",
    sheet = "Medium long term",
    skip = 2
  )

CurrentElectricity[c(2:22,ncol(CurrentElectricity))] <- NULL

CurrentElectricity <- CurrentElectricity[complete.cases(CurrentElectricity),]

CurrentElectricity[15, 1] <- "United Kingdom"

CurrentElectricity[2:(ncol(CurrentElectricity)-1)] <- NULL

write.table(
  CurrentElectricity,
  "R Data Output/InternationalElecBills.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

CurrentGas <-
  read_excel(
    "Data Sources/International Energy Prices/CurrentGas.xlsx",
    sheet = "Medium long term",
    skip = 4
  )

CurrentGas[c(2:22,ncol(CurrentGas))] <- NULL

CurrentGas <- CurrentGas[complete.cases(CurrentGas),]

CurrentGas[15, 1] <- "United Kingdom"

CurrentGas[2:(ncol(CurrentGas)-1)] <- NULL

write.table(
  CurrentGas,
  "R Data Output/InternationalGasBills.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


