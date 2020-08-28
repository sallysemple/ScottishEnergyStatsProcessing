library(readxl)
library(opendatascot)
library(plyr)
library(dplyr)
library(tidyverse)
library(data.table)
library(reshape2)
library(magrittr)
library(readxl)

print("Carbon productivity")

GreenhouseGas<-ods_dataset("greenhouse-gas")[c(2,4)]

names(GreenhouseGas) <- c("Year", "Emissions")


GDP <-
  read_excel(
    "Data Sources/QNAS/QNAS.xlsx",
    sheet = "Table A",
    skip = 4
  )
### Create Subset with only relevant data ###
# is.na(GDP$Quarter2) means that only the rows where there is nothing in that column are extracted.
# This corresponds to GDP in Calendar years.
GDP <-
  subset(
    GDP,
    is.na(GDP$Quarter)
  )

### Remove excess rows from the bottom ###
GDP <- head(GDP[c(1,3,9)],-10)


names(GDP) <- c("Year", "GVA", "GDP at Market Prices")

CarbonProductivity <- merge(GDP, GreenhouseGas)

CarbonProductivity  %<>% lapply(function(x) as.numeric(as.character(x)))

CarbonProductivity <- as_tibble(CarbonProductivity)

CarbonProductivity$CarbonProductivity <- CarbonProductivity$GVA / CarbonProductivity$Emissions

CarbonProductivity$Change2000 <- (CarbonProductivity$CarbonProductivity / CarbonProductivity[which(CarbonProductivity$Year == 2000),]$CarbonProductivity) -1

CarbonProductivity$Change2010 <- (CarbonProductivity$CarbonProductivity / CarbonProductivity[which(CarbonProductivity$Year == 2010),]$CarbonProductivity) -1

CarbonProductivity[which(CarbonProductivity$Year < 2000),]$Change2000 <- NA

CarbonProductivity[which(CarbonProductivity$Year < 2010),]$Change2010 <- NA

CarbonProductivity$`GDP at Market Prices` <- NULL

write.table(
  CarbonProductivity,
  "Output/Carbon Productivity/Carbon Productivity.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
