library(tidyverse)
library(plyr)
library(dplyr)
library(magrittr)
library(lubridate)
library(zoo)
library(readxl)

print("AnnualRenCap")

RenGenCap <- read_excel("Data Sources/Energy Trends/RenGenCap.xls", 
                        sheet = "Scotland - Qtr", col_names = FALSE, 
                        skip = 4, n_max = 16)

RenGenCap <- as.data.frame(t(RenGenCap))

names(RenGenCap) <- unlist(RenGenCap[1,])

names(RenGenCap)[1:2] <- c("Y", "Q")

RenGenCap$Quarter <- paste0(RenGenCap$Y, " Q", substr(RenGenCap$Q,1,1))

RenGenCap[4:16] %<>% lapply(function(x) as.numeric(as.character(x)))

RenGenCap <- as_tibble(RenGenCap[c(17,4:16)])

RenGenCap <- RenGenCap[complete.cases(RenGenCap),]

RenGenCap$Quarter <- as.yearqtr(RenGenCap$Quarter)

names(RenGenCap) <- c("Quarter", "Onshore Wind", "Offshore Wind", "Shoreline wave / tidal", "Solar photovoltaics", "Small scale Hydro", "Large scale Hydro", "Landfill gas", "Sewage sludge digestion", "Energy from waste", "Animal Biomass (non-AD)", "Anaerobic Digestion", "Plant Biomass", "Total")


RenGenCap <- RenGenCap[which(substr(RenGenCap$Quarter,7,7) == 4),]

RenGenCap$Quarter <- substr(RenGenCap$Quarter,1,4)

names(RenGenCap)[1] <- "Year"

write.table(RenGenCap,
            "Output/Renewable Capacity/AnnualCapacityScotland.txt",
            sep = "\t",
            row.names = FALSE)