library(readxl)
library(plyr)
library(dplyr)
library(readr)
library("writexl")
library(lubridate)
library(reshape2)
library(tidyverse)

### ONLY RUN WHEN CAPACITY AND REPD ARE REFERRING TO THE SAME DATES (i.e. for the quarterly publication) ###

print("PipelineLA")

source("Processing Scripts/OperationalCorrectionsREPD.R")

REPD <- REPD %>% group_by(LA, LACode, `Development Status (short)`) %>% summarise(Capacity = sum(`Installed Capacity (MWelec)`)) %>% dcast(LA + LACode ~ `Development Status (short)`)


REPD[is.na(REPD)] <- 0

REPD[which(REPD$LA == "Offshore"),]$LACode <- NA
REPD[which(REPD$LA == "Offshore"),]$LA <- "ZZZ"

REPD <- REPD[order(REPD$LA),]

REPD[which(REPD$LA == "ZZZ"),]$LA <- "Offshore"


REPDTotal <- tibble(
  LA = "Scotland",
  LACode = "S92000003",
  `Application Submitted` = sum(REPD$`Application Submitted`),
  `Awaiting Construction` = sum(REPD$`Awaiting Construction`),
  `Operational` = sum(REPD$Operational), 
  `Under Construction` = sum(REPD$`Under Construction`)
)

REPD <- rbind(REPD, REPDTotal)

write.csv(REPD, "Output/REPD (Operational Corrections)/PipelineLA.csv", row.names = FALSE)
