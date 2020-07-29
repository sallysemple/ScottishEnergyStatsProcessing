library(tidyverse)
library(plyr)
library(dplyr)
library(magrittr)
library(lubridate)
library(zoo)

print("QTRRenCap")

RenGenCap <- read_excel("Data Sources/Energy Trends/RenGenCap.xls", 
                        sheet = "Scotland - Qtr", col_names = FALSE, 
                        skip = 4, n_max = 27)

RenGenCap <- as.data.frame(t(RenGenCap))

names(RenGenCap) <- unlist(RenGenCap[1,])

names(RenGenCap)[1:2] <- c("Y", "Q")

RenGenCap$Quarter <- paste0(RenGenCap$Y, " Q", substr(RenGenCap$Q,1,1))

RenGenCap[4:27] %<>% lapply(function(x) as.numeric(as.character(x)))

RenGenCap <- as_tibble(RenGenCap[c(28,19:27)])

RenGenCap <- RenGenCap[complete.cases(RenGenCap),]

RenGenCap$Quarter <- as.yearqtr(RenGenCap$Quarter)

names(RenGenCap) <- c("Quarter", "Onshore Wind", "Offshore Wind", "Shoreline wave / tidal", "Solar photovoltaics", "Hydro", "Landfill gas", "Sewage sludge digestion", "Other Biomass", "Total")

write.table(RenGenCap,
            "Output/Renewable Generation/QTRGenScotland.txt",
            sep = "\t",
            row.names = FALSE)