library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(data.table)

print("OilGasConsumption")

source("Processing Scripts/FinalConsumption.R")

###Remove Latest Year - Might be needed if provisional data is being rolled forward

RemoveLatestYear <- 1

if(RemoveLatestYear == 1){
TotalFinalLAConsumption <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$Year < max(TotalFinalLAConsumption$Year)),]
}

###Keep only latest year left
TotalFinalLAConsumption <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$Year == max(TotalFinalLAConsumption$Year)),]

#Scotland
ScotlandFinalConsumption <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$`LA Code` ==  'S92000003'),]

#UK

UKFinalConsumption <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$`LA Code` ==  'K03000001'),]

#There are two UK rows, one that includes unallocated consumption. This function keeps the values which are larger per column, which will be inclusive of unallocated consumption
UKFinalConsumption <- UKFinalConsumption %>% group_by(Year) %>% summarise_all(max)


source("Processing Scripts/HeatConsumptionLA.R")

Heat <- HeatDetailed[which(HeatDetailed$Year == ScotlandFinalConsumption$Year),]

ScotlandHeat <- Heat[which(Heat$`LA Code` == "S92000003"),]

UKHeat <- Heat[which(Heat$`LA Code` == "K03000001"),]

#There are two UK rows, one that includes unallocated consumption. This function keeps the values which are larger per column, which will be inclusive of unallocated consumption
UKHeat <- UKHeat %>% group_by(Year) %>% summarise_all(max)


### Create Scottish Table

ScotlandOilGasConsumption <- tibble(
  Sector = c("Overall", "Domestic", "Non-domestic", "Heat"),
  `Petroleum products` = c(ScotlandFinalConsumption$`Petroleum products - Total`,
                           ScotlandFinalConsumption$`Petroleum products - Domestic`,
                           ScotlandFinalConsumption$`Petroleum products - Industrial`+ScotlandFinalConsumption$`Petroleum products - Commercial` + ScotlandFinalConsumption$`Petroleum products - Public Sector` + ScotlandFinalConsumption$`Petroleum products - Agriculture`,
                           ScotlandHeat$`Petroleum products`),
  
  Gas = c(ScotlandFinalConsumption$`Gas - Total`,
          ScotlandFinalConsumption$`Gas - Domestic`,
          ScotlandFinalConsumption$`Gas - Industrial` + ScotlandFinalConsumption$`Gas - Commercial`,
          ScotlandHeat$`Total Gas`),
  
  `Other fuel` = c(ScotlandFinalConsumption$`All fuels - Total`, 
                   ScotlandFinalConsumption$`Consuming Sector - Domestic`,
                   ScotlandFinalConsumption$`Consuming Sector - Industry & Commercial`,
                   ScotlandHeat$`Total - All Fuels`)
)

ScotlandOilGasConsumption$`Other fuel` <- ScotlandOilGasConsumption$`Other fuel` - ScotlandOilGasConsumption$Gas - ScotlandOilGasConsumption$`Petroleum products`

ScotlandOilGasConsumption$Year <- ScotlandFinalConsumption$Year

ScotlandOilGasConsumption

write_csv(ScotlandOilGasConsumption, "Output/Consumption/ScotlandOilGasConsumption.csv")


### Create UK Table

UKOilGasConsumption <- tibble(
  Sector = c("Overall", "Domestic", "Non-domestic", "Heat"),
  `Petroleum products` = c(UKFinalConsumption$`Petroleum products - Total`,
                           UKFinalConsumption$`Petroleum products - Domestic`,
                           UKFinalConsumption$`Petroleum products - Industrial`+UKFinalConsumption$`Petroleum products - Commercial` + UKFinalConsumption$`Petroleum products - Public Sector` + UKFinalConsumption$`Petroleum products - Agriculture`,
                           UKHeat$`Petroleum products`),
  
  Gas = c(UKFinalConsumption$`Gas - Total`,
          UKFinalConsumption$`Gas - Domestic`,
          UKFinalConsumption$`Gas - Industrial` + UKFinalConsumption$`Gas - Commercial`,
          UKHeat$`Total Gas`),
  
  `Other fuel` = c(UKFinalConsumption$`All fuels - Total`, 
                   UKFinalConsumption$`Consuming Sector - Domestic`,
                   UKFinalConsumption$`Consuming Sector - Industry & Commercial`,
                   UKHeat$`Total - All Fuels`)
)

UKOilGasConsumption$`Other fuel` <- UKOilGasConsumption$`Other fuel` - UKOilGasConsumption$Gas - UKOilGasConsumption$`Petroleum products`

UKOilGasConsumption$Year <- UKFinalConsumption$Year

UKOilGasConsumption

write_csv(UKOilGasConsumption, "Output/Consumption/UKOilGasConsumption.csv")