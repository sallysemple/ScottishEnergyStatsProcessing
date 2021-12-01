library(plyr)
library(dplyr)
library(readr)
library(readxl)
library(tidyverse)
library(reshape2)
library(readr)
library(lubridate)
library(zoo)
library(magrittr)

print("ProvisionalElecGen")

ProvisionalElecGen <- read_excel("Offline Data Sources/ProvisionalElecGen.xlsx")

ProvisionalElecGen <- as_tibble(t(ProvisionalElecGen))

ProvisionalElecGen <- ProvisionalElecGen[-1,c(4,5, 73:83)]

names(ProvisionalElecGen) <- c("Year",  
                               "Quarter", 
                               "Coal",  
                               "Oil",   
                               "Gas",   
                               "Nuclear", 
                               "Hydro", 
                               "Wind and Solar", 
                               "Offshore Wind", 
                               "Bioenergy", 
                               "Other fuels", 
                               "Pumped Storage", 
                               "Total")

maxyear <- max(as.numeric(
  ProvisionalElecGen[which(ProvisionalElecGen$Quarter == "Q4"),]$Year
))

ProvisionalElecGen <- ProvisionalElecGen[which(ProvisionalElecGen$Year <= maxyear),]

ProvisionalElecGen$Quarter <- paste(ProvisionalElecGen$Year, ProvisionalElecGen$Quarter)

ProvisionalElecGen[3:13] %<>% lapply(function(x) as.numeric(as.character(x))*1000)


ProvisionalElecGen$Renewable <- ProvisionalElecGen$Hydro + ProvisionalElecGen$`Wind and Solar`+ProvisionalElecGen$Bioenergy
ProvisionalElecGen$Fossil <- ProvisionalElecGen$Total - ProvisionalElecGen$Renewable

source("Processing Scripts/ElecImportExport.R")

ImportExport <- ImportExport %>% select(Quarter, `Net transfers (Scotland to England)`, `Net transfers (Scotland to NI)`)

ProvisionalElecGen <- merge(ProvisionalElecGen, ImportExport)

ProvisionalElecGen$`Gross Electricity Consumption` <- ProvisionalElecGen$Total - ProvisionalElecGen$`Net transfers (Scotland to England)`- ProvisionalElecGen$`Net transfers (Scotland to NI)`

ProvisionalElecGen <- ProvisionalElecGen[2:18] %>% group_by(Year) %>% summarise_all(sum)

ProvisionalElecGen <- ProvisionalElecGen %>% select(Year, Renewable, `Gross Electricity Consumption`)


write.csv(ProvisionalElecGen, "Output/Consumption/ProvisionalGrossElecConsumption.csv")
