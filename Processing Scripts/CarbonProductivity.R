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

source("Processing Scripts/GreenhouseGas.R")

GreenhouseGasSector$Total <- rowSums(GreenhouseGasSector[2:11])

GreenhouseGasSector <- GreenhouseGasSector[c(1,12)]

names(GreenhouseGasSector) <- c("Year", "Emissions")

source("Processing Scripts/GVA.R")

CarbonProductivity <- merge(GDP, GreenhouseGasSector)

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
