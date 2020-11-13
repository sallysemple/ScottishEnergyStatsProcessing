library(readODS)
library(readxl)
library(dplyr)

print("Domestic Energy Customers")

yearstart <- 2015

yearend <- format(Sys.Date(), "%Y")

### Set the Working Directory for the Scripts ###

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

DomesticElecCustomers <- read_excel("Data Sources/Domestic Energy Customers/CurrentElectricity.xlsx", 
                                      sheet = "Quarterly Database", skip = 2)
DomesticElecCustomers          <-
  subset(DomesticElecCustomers, nchar(DomesticElecCustomers$Quarter) != 9)

NorthScotElec <- subset(DomesticElecCustomers, Region == "North Scotland")

NorthScotElec[2] <- NULL

write.table(
  NorthScotElec,
  "R Data Output/NorthScotElec.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

SouthScotElec <- subset(DomesticElecCustomers, Region == "South Scotland")

SouthScotElec[2] <- NULL

write.table(
  SouthScotElec,
  "R Data Output/SouthScotElec.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

GBElec <- subset(DomesticElecCustomers, Region == "Great Britain")

GBElec[2] <- NULL

write.table(
  GBElec,
  "R Data Output/GBElec.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)





DomesticGasCustomers <- read_excel("Data Sources/Domestic Energy Customers/CurrentGas.xlsx", 
                                    sheet = "Quarterly Database", skip = 2)

DomesticGasCustomers          <-
  subset(DomesticGasCustomers, nchar(DomesticGasCustomers$Quarter) != 9)

DomesticGasCustomers$Quarter <- substring(DomesticGasCustomers$Quarter, 1, 8)

NorthScotGas <- subset(DomesticGasCustomers, `LDZ Region` == "North Scotland")

NorthScotGas[2] <- NULL

write.table(
  NorthScotGas,
  "R Data Output/NorthScotGas.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

SouthScotGas <- subset(DomesticGasCustomers, `LDZ Region` == "South Scotland")

SouthScotGas[2] <- NULL

write.table(
  SouthScotGas,
  "R Data Output/SouthScotGas.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

GBGas <- subset(DomesticGasCustomers, `LDZ Region` == "Great Britain")

GBGas[2] <- NULL

write.table(
  GBGas,
  "R Data Output/GBGas.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
