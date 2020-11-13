library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(zoo)

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("ElectricityBillsPaymentMethods")

### Read Source File ###
ElectricityBillPaymentMethods <-
  read_excel(
    "Data Sources/Energy Bills Payment Methods/CurrentElectricity.xlsx",
    sheet = "Quarterly Database Main Table",
    skip = 2
  ) %>% subset(`PES region` == "Scotland")

ElectricityBillPaymentMethods$Quarter <- as.yearqtr(ElectricityBillPaymentMethods$Quarter, "%Y-%m-%d")


### Export to CSV ###
write.table(
  ElectricityBillPaymentMethods,
  "R Data Output/ElectricityBillPaymentMethods.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
