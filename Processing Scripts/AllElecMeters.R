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

myFiles <- list.files(path="Data Sources/Electricity Meters/", pattern = "\\.csv$", recursive = TRUE, full.names = TRUE)

DatasetList <- lapply(myFiles, read.csv, header=TRUE)
names(DatasetList) <- myFiles
for(i in myFiles) {
  DatasetList[[i]]$Year = i
}

FullData <- do.call(bind_rows, DatasetList)

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
