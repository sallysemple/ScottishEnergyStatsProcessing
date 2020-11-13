library(readODS)
library(readxl)
library(dplyr)

print("Domestic Energy Customers")

yearstart <- 2015

yearend <- format(Sys.Date(), "%Y")

### Set the Working Directory for the Scripts ###

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

DomesticElecCustomers <- read_excel("Data Sources/Domestic Energy Customers/CurrentElectricity.xlsx", 
                                      sheet = "Quarterly", skip = 3)
DomesticElecCustomers          <-
  subset(DomesticElecCustomers, nchar(DomesticElecCustomers$Quarter) != 9)

names(DomesticElecCustomers)[3] <- "Region"

NorthScotElec <- subset(DomesticElecCustomers, Region == "North Scotland")

NorthScotElec[c(1,3,8)] <- NULL

write.table(
  NorthScotElec,
  "R Data Output/NorthScotElec.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

SouthScotElec <- subset(DomesticElecCustomers, Region == "South Scotland")

SouthScotElec[c(1,3,8)] <- NULL

write.table(
  SouthScotElec,
  "R Data Output/SouthScotElec.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

GBElec <- subset(DomesticElecCustomers, Region == "Great Britain")

GBElec[c(1,3,8)] <- NULL

write.table(
  GBElec,
  "R Data Output/GBElec.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)





DomesticGasCustomers <- read_excel("Data Sources/Domestic Energy Customers/CurrentGas.xlsx", 
                                    sheet = "Quarterly", skip = 3)

DomesticGasCustomers          <-
  subset(DomesticGasCustomers, nchar(DomesticGasCustomers$Quarter) != 9)

DomesticGasCustomers$Quarter <- substring(DomesticGasCustomers$Quarter, 1, 8)

names(DomesticGasCustomers)[3] <- "Region"

NorthScotGas <- subset(DomesticGasCustomers, `Region` == "North Scotland")

NorthScotGas[c(1,3,8)] <- NULL

write.table(
  NorthScotGas,
  "R Data Output/NorthScotGas.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

SouthScotGas <- subset(DomesticGasCustomers, `Region` == "South Scotland")

SouthScotGas[c(1,3,8)] <- NULL

write.table(
  SouthScotGas,
  "R Data Output/SouthScotGas.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

GBGas <- subset(DomesticGasCustomers, `Region` == "Great Britain")

GBGas[c(1,3,8)] <- NULL

write.table(
  GBGas,
  "R Data Output/GBGas.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
