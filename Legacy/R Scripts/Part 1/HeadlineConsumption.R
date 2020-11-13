### Load Packages
library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)

print("Headline Consumption")

### Set Working Directory
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

###### Read Source Data ######

ScotHeadlineElecConsumption <-
  read_excel(
    "Data Sources/NEED Consumption Headlines/ScotCurrent.xls",
    sheet = "Table 2",
    skip = 5
  )

ScotHeadlineGasConsumption <-
  read_excel(
    "Data Sources/NEED Consumption Headlines/ScotCurrent.xls",
    sheet = "Table 1",
    skip = 5
  )

EWHeadlineElecConsumption <-
  read_excel(
    "Data Sources/NEED Consumption Headlines/EWCurrent.xls",
    sheet = "Table 2",
    skip = 5
  )

EWHeadlineGasConsumption <-
  read_excel(
    "Data Sources/NEED Consumption Headlines/EWCurrent.xls",
    sheet = "Table 1",
    skip = 5
  )

### Remove NA rows ###

ScotHeadlineElecConsumption <-
  ScotHeadlineElecConsumption[rowSums(is.na(ScotHeadlineElecConsumption)) != ncol(ScotHeadlineElecConsumption),]

ScotHeadlineGasConsumption <-
  ScotHeadlineGasConsumption[rowSums(is.na(ScotHeadlineGasConsumption)) != ncol(ScotHeadlineGasConsumption),]

EWHeadlineElecConsumption <-
  EWHeadlineElecConsumption[rowSums(is.na(EWHeadlineElecConsumption)) != ncol(EWHeadlineElecConsumption),]

EWHeadlineGasConsumption <-
  EWHeadlineGasConsumption[rowSums(is.na(EWHeadlineGasConsumption)) != ncol(EWHeadlineGasConsumption),]

### Write Tables ###

write.table(
  ScotHeadlineElecConsumption,
  "R Data Output/ScotHeadlineElecConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

write.table(
  ScotHeadlineGasConsumption,
  "R Data Output/ScotHeadlineGasConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

write.table(
  EWHeadlineElecConsumption,
  "R Data Output/EWHeadlineElecConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

write.table(
  EWHeadlineGasConsumption,
  "R Data Output/EWHeadlineGasConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)