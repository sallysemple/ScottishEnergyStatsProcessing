library(readxl)
library(readr)
library(plyr)
library(dplyr)
library(reshape2)

source("Processing Scripts/HeatConsumptionLA.R")


RenHeatGen <- read_excel("Data Sources/MANUAL/RenHeatGen.xlsx")


RenHeatTgt <- HeatWorking[which(HeatWorking$`LA Code` == "S92000003"),] %>% 
                select(Year, `Total - All Fuels`)
