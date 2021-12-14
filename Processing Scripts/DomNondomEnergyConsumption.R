library(readxl)
library(readr)
library(plyr)
library(dplyr)
library(reshape2)

source("Processing Scripts/FinalConsumption.R")
source("Processing Scripts/HeatConsumptionLA.R")


ElecConsumption <- TotalFinalLAConsumption %>% select(Year, `LA Code`, `Electricity - Domestic`, `Electricity - Industrial & Commercial`)

HeatConsumption <- HeatDetailed

HeatConsumption$Domestic <- HeatConsumption$`Coal - Domestic` + HeatConsumption$`Manufactured fuels - Domestic` + HeatConsumption$`Petroleum products - Domestic`+ HeatConsumption$`Gas - Domestic` + HeatConsumption$`Bioenergy & wastes - Domestic`

HeatConsumption$NonDomestic <- HeatConsumption$`Total - All Fuels` - HeatConsumption$Domestic

