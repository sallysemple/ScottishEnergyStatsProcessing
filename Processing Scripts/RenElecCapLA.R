library(readr)
library(readxl)
library(plyr)
library(dplyr)
library(magrittr)
library(tidyverse)


RenElecLAList <- list()

yearstart <- 2013

yearend <- format(Sys.Date(), "%Y")

for (year in yearstart:yearend) {
  
  tryCatch({
    RenewableElecCapLA <- read_excel("Data Sources/Renewable Generation/RenewableElecLA.xlsx", 
                                  sheet = paste0("LA - Capacity, ", year), skip = 3)
    
    RenewableElecCapLA$Year <- year
    
    RenElecLAList[[year]] <- RenewableElecCapLA
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
}

RenewableElecCapLA <-bind_rows(RenElecLAList)

names(RenewableElecCapLA)[1] <- "LACode"

RenewableElecCapLA <- RenewableElecCapLA[which(substr(RenewableElecCapLA$LACode,1,2)== "S1"),]

RenewableElecCapLA[3:5] <- NULL

RenewableElecCapLA[3:15] %<>% lapply(function(x) as.numeric(as.character(x)))

Unallocated <- RenewableElecCapLA %>% group_by(Year) %>% 
  summarise_at(c(3:15), list(sum))

Unallocated$LACode <- " "
Unallocated$`Local Authority Name  [note 5][note 6][note 7] [note 8][note 9]` <- "Unallocated"

RenewableElecCapLA <- rbind(RenewableElecCapLA, Unallocated)


RenewableElecCapLA$`Bioenergy and Waste` <- RenewableElecCapLA$`Anaerobic Digestion` + RenewableElecCapLA$`Sewage Gas` + RenewableElecCapLA$`Landfill Gas` + RenewableElecCapLA$`Municipal Solid Waste` + RenewableElecCapLA$`Animal Biomass` + RenewableElecCapLA$`Plant Biomass` + RenewableElecCapLA$Cofiring

names(RenewableElecCapLA) <- c("LACode", "LAName", "Solar photovoltaics", "Onshore Wind", "Hydro", "AD", "Offshore Wind", "Shoreline wave / tidal", "SG", "LG", "MSW", "AB", "PB", "Cofiring", "Total", "Year", "Bioenergy and Waste")


source("Processing Scripts/QtrRenCap.R")

QTRCapacityScotland <- read_delim("Output/Quarter Capacity/QTRCapacityScotland.txt", 
                             "\t", escape_double = FALSE, trim_ws = TRUE)

QTRCapacityScotland <- QTRCapacityScotland[which(substr(QTRCapacityScotland$Quarter,7,7)==4),]

QTRCapacityScotland$Year <- substr(QTRCapacityScotland$Quarter,1,4)

QTRCapacityScotland <- QTRCapacityScotland %>% group_by(Year) %>% 
  summarise_at(2:14,funs(sum))

QTRCapacityScotland <- QTRCapacityScotland[which(QTRCapacityScotland$Year %in% RenewableElecCapLA$Year),]

QTRCapacityScotland$`Bioenergy and Waste` <- QTRCapacityScotland$`Landfill gas` +
  QTRCapacityScotland$`Sewage sludge digestion`+
  QTRCapacityScotland$`Energy from Waste` +
  QTRCapacityScotland$`Animal Biomass` +
  QTRCapacityScotland$`Anaerobic Digestion`  +  
  QTRCapacityScotland$`Plant Biomass`

QTRCapacityScotland$Hydro <- QTRCapacityScotland$`Small scale Hydro` + QTRCapacityScotland$`Large scale Hydro`


QTRCapacityScotland$LACode <- "S92000003"

QTRCapacityScotland$LAName <- "Scotland"

RenewableElecCapLA <- rbind.fill(RenewableElecCapLA, QTRCapacityScotland)

RenewableElecCapLA <- RenewableElecCapLA[ , colSums(is.na(RenewableElecCapLA)) == 0]

RenewableElecCapLA <- RenewableElecCapLA[c(9,1,2,4,6,5,3,7,10,8)]

RenewableElecCapLA[which(RenewableElecCapLA$LAName == "Unallocated"),][4:10] <- RenewableElecCapLA[which(RenewableElecCapLA$LAName == "Scotland"),][4:10] - RenewableElecCapLA[which(RenewableElecCapLA$LAName == "Unallocated"),][4:10]

source("Processing Scripts/LACodeFunction.R")

RenewableElecCapLA <- LACodeUpdate(RenewableElecCapLA)

names(RenewableElecCapLA)[10] <- "Total Renewable"

write.table(RenewableElecCapLA,
            "Output/Renewable Capacity/LAOperationalRenCap.txt",
            sep = "\t",
            row.names = FALSE)
