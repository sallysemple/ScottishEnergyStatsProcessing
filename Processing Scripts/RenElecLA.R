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
    RenewableElecLA <- read_excel("Data Sources/Renewable Generation/RenewableElecLA.xlsx", 
                                  sheet = paste0("LA - Generation, ", year), skip = 1)
    
    RenewableElecLA$Year <- year
    
    RenElecLAList[[year]] <- RenewableElecLA
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
}

RenewableElecLA <- bind_rows(RenElecLAList)

names(RenewableElecLA)[1] <- "LACode"

RenewableElecLA <- RenewableElecLA[which(substr(RenewableElecLA$LACode,1,2)== "S1"),]

RenewableElecLA[3:5] <- NULL

RenewableElecLA[3:15] %<>% lapply(function(x) as.numeric(as.character(x))/1000)

Unallocated <- RenewableElecLA %>% group_by(Year) %>% 
  summarise_at(c(3:15), funs(sum))

Unallocated$LACode <- " "
Unallocated$`Local Authority Name` <- "Unallocated"

RenewableElecLA <- rbind(RenewableElecLA, Unallocated)


RenewableElecLA$`Biomass and Energy from Waste` <- RenewableElecLA$`Anaerobic Digestion` + RenewableElecLA$`Sewage Gas` + RenewableElecLA$`Landfill Gas` + RenewableElecLA$`Municipal Solid Waste` + RenewableElecLA$`Animal Biomass` + RenewableElecLA$`Plant Biomass` + RenewableElecLA$Cofiring

names(RenewableElecLA) <- c("LACode", "LAName", "Solar photovoltaics", "Onshore Wind", "Hydro", "AD", "Offshore Wind", "Shoreline wave / tidal", "SG", "LG", "MSW", "AB", "PB", "Cofiring", "Total", "Year", "Biomass and Energy from Waste")



QTRGenScotland <- read_csv("Output/Renewable Generation/QTRGenScotland.csv")



QTRGenScotland$Year <- substr(QTRGenScotland$Quarter,1,4)

QTRGenScotland <- QTRGenScotland %>% group_by(Year) %>% 
  summarise_at(2:10,funs(sum))

QTRGenScotland <- QTRGenScotland[which(QTRGenScotland$Year %in% RenewableElecLA$Year),]

QTRGenScotland$`Biomass and Energy from Waste` <- QTRGenScotland$`Other Biomass` + QTRGenScotland$`Sewage sludge digestion` + QTRGenScotland$`Landfill gas`


QTRGenScotland$LACode <- "S92000003"

QTRGenScotland$LAName <- "Scotland"

RenewableElecLA <- rbind.fill(RenewableElecLA, QTRGenScotland)

RenewableElecLA <- RenewableElecLA[ , colSums(is.na(RenewableElecLA)) == 0]

RenewableElecLA <- RenewableElecLA[c(9,1,2,4,6,5,3,7,10,8)]

RenewableElecLA[which(RenewableElecLA$LAName == "Unallocated"),][4:10] <- RenewableElecLA[which(RenewableElecLA$LAName == "Scotland"),][4:10] - RenewableElecLA[which(RenewableElecLA$LAName == "Unallocated"),][4:10]

source("Processing Scripts/LACodeFunction.R")

RenewableElecLA <- LACodeUpdate(RenewableElecLA)

names(RenewableElecLA)[10] <- "Total Renewable"

write.table(RenewableElecLA,
            "Output/Renewable Generation/LARenGen.txt",
            sep = "\t",
            row.names = FALSE)