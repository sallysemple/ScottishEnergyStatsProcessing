library(opendatascot)
library(plyr)
library(dplyr)
library(tidyverse)
library(data.table)
library(reshape2)
library(magrittr)

GreenhouseGasSector<-ods_dataset("greenhouse-gas-emissions-by-national-communications-category")

GreenhouseGasSector <- dcast(GreenhouseGasSector, refPeriod + nationalCommunicationCategories ~ GreenhouseGasSector$pollutant, value.var = "value")

GreenhouseGasSector[is.na(GreenhouseGasSector)] <- 0

GreenhouseGasSector[c(1,3:9)] %<>% lapply(function(GreenhouseGasSector) as.numeric(as.character(GreenhouseGasSector)))

GreenhouseGasSector$Total <- GreenhouseGasSector$ch4 + GreenhouseGasSector$co2 + GreenhouseGasSector$hfcs + GreenhouseGasSector$n2o + GreenhouseGasSector$nf3 + GreenhouseGasSector$pfcs + GreenhouseGasSector$sf6

GreenhouseGasSector[3:9] <- NULL

GreenhouseGasSector <- dcast(GreenhouseGasSector, refPeriod  ~ nationalCommunicationCategories, value.var = "Total")

write.table(GreenhouseGasSector,
            "Output/Greenhouse Gas/SectorTimeSeries.csv",
            sep = "\t",
            row.names = FALSE)
