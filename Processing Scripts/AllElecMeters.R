library(readr)
library(readxl)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(data.table)
library(lubridate)
library(plotly)
library("zoo")

print("AllElecMeters")

myFiles <- list.files(path="Data Sources/Electricity Meters/", pattern = "\\.csv$", recursive = TRUE, full.names = TRUE)

DatasetList <- lapply(myFiles, read.csv, header=TRUE)
names(DatasetList) <- myFiles
for(i in myFiles) {
  DatasetList[[i]]$Year = i
}

FullData <- do.call(bind_rows, DatasetList)

names(FullData) <- c("LAName", "LACode", "MSOAName", "MSOACode", "LSOAName", "LSOACode", "METERS", "KWH", "MEAN", "MEDIAN", "Year")

FullData$Year <- as.numeric(substr(FullData$Year, 43,46))

FullData <- FullData[which(substr(FullData$LACode,1,1)=="S"),]

source("Processing Scripts/LACodeFunction.R")

FullData <- LACodeUpdate(FullData)

LAZones <- read_excel("Data Sources/Electric Zones/LAZones.xlsx")

LAZones <- LACodeUpdate(LAZones)

FullData <- merge(LAZones, FullData, all = TRUE)

FullData <- FullData %>% group_by(Year, `Region`, LACode, LAName) %>%  summarise(METERS = sum(METERS))

LAMetersTimeSeries <- dcast(FullData, Region + LACode + LAName ~ Year)

write.table(LAMetersTimeSeries,
            "Output/Electricity Meters/MetersLATimeSeries.txt",
            sep = "\t",
            row.names = FALSE)

RegionLatestMeters <- FullData[which(FullData$Year == max(FullData$Year)),] %>%  group_by(Year, Region) %>%  summarise(METERS = sum(METERS))

write.table(RegionLatestMeters,
            "Output/Electricity Meters/RegionLatestMeters.txt",
            sep = "\t",
            row.names = FALSE)

Smart_Meters <- read_excel("Data Sources/MANUAL/Smart Meters.xlsx")

FullDataforSmart <- FullData %>% group_by(Year, Region) %>% summarise(METERS = sum(METERS))

FullDataforSmart  <- as_tibble(dcast(FullDataforSmart, Year ~ Region, value.var = "METERS"))

FullDataforSmart$Date <- ymd(paste0(FullDataforSmart$Year, "-01-01"))

SmartMeters <- merge(Smart_Meters, FullDataforSmart, all  = TRUE)

SmartMeters <- fill(SmartMeters, 6:7)

SmartMeters$Year <- NULL

SmartMeters <- SmartMeters[complete.cases(SmartMeters),]

SmartMeters$`All Scotland - Proportion` <- SmartMeters$`All Scotland - Installations` / (SmartMeters$North + SmartMeters$South)

SmartMeters$`North Scotland - Proportion` <- SmartMeters$`North Scotland - Installations` / (SmartMeters$North)

SmartMeters$`South Scotland - Proportion` <- SmartMeters$`South Scotland - Installations` / (SmartMeters$South)

SmartMeters <- SmartMeters[c(1,2,7,3,8,4,9)]

write.table(SmartMeters,
            "Output/Electricity Meters/SmartMeters.txt",
            sep = "\t",
            row.names = FALSE)
