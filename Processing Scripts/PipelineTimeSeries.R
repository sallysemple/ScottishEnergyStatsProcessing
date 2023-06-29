library(readxl)
library(plyr)
library(dplyr)
library(readr)
library("writexl")
library(lubridate)
library(reshape2)
library(tidyverse)

### ONLY RUN WHEN CAPACITY AND REPD ARE REFERRING TO THE SAME DATES (i.e. for the quarterly publication) ###

print("PipelineByTech")

source("Processing Scripts/PipelineCapbyTech.R")
source("Processing Scripts/QtrRenCap.R")


CurrentQuarter <- max(RenElecCap$Quarter)

PipelineTimeSeries <- tibble(
  Quarter = as.character(CurrentQuarter),
  `In Planning` = sum(REPD$`In Planning`),
  `Awaiting Construction` = sum(REPD$`Awaiting Construction`),
  `Under Construction` = sum(REPD$`Under Construction`),
  Total = sum(REPD$Total)
)

PreviousPipeline <- read_csv("Output/REPD (Operational Corrections)/PipelineTimeSeries.csv")

PipelineTimeSeries <- rbind(PipelineTimeSeries, PreviousPipeline)

PipelineTimeSeries <- PipelineTimeSeries[!duplicated(PipelineTimeSeries$Quarter),]


write.csv(PipelineTimeSeries, "Output/REPD (Operational Corrections)/PipelineTimeSeries.csv", row.names = FALSE)

