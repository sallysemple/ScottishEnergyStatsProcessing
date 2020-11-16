library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(lubridate)
library(zoo)

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("GasBillsPaymentMethods")

### Read Source File ###
GasBillPaymentMethods <-
  read_excel(
    "Data Sources/Energy Bills Payment Methods/CurrentGas.xlsx",
    sheet = "Quarterly",
    skip = 3
  ) %>% subset(`Region` == "Scotland")

GasBillPaymentMethods$Quarter <- as.Date(as.numeric(GasBillPaymentMethods$Quarter), origin = "1899-12-30")

GasBillPaymentMethods$Quarter <- as.yearqtr(GasBillPaymentMethods$Quarter, "%d-%m-%Y")


GasBillPaymentMethods <- GasBillPaymentMethods[!duplicated(GasBillPaymentMethods$Quarter),]

### Export to CSV ###
write.table(
  GasBillPaymentMethods[2:6],
  "R Data Output/GasBillPaymentMethods.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
