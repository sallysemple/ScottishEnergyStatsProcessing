library(readr)
library(plyr)
library(dplyr)
library(readxl)
library(tidyverse)

print("HeatConsumptionLA")

source("Processing Scripts/HeatEndUse.R")

HeatWorking <- TotalFinalLAConsumption

HeatWorking <- HeatWorking %>%  select(names(HeatEndUseMultipliers))

HeatEndUseMultipliers <- merge(HeatEndUseMultipliers, HeatWorking[1:2], all = TRUE)


HeatEndUseMultipliers$Year <- as.numeric(as.character(HeatEndUseMultipliers$Year))

HeatEndUseMultipliers <- HeatEndUseMultipliers[order(HeatEndUseMultipliers$Year, HeatEndUseMultipliers$`Region`),]


HeatEndUseMultipliers <- HeatEndUseMultipliers %>%  fill(4:20)

HeatWorking <- HeatWorking[order(HeatWorking$Year, HeatWorking$`Region`),]

HeatWorking[4:20] <- HeatWorking[4:20] * HeatEndUseMultipliers[4:20]

HeatWorking$Total <- rowSums(HeatWorking[4:20])

write_csv(HeatWorking[which(substr(HeatWorking$`LA Code`,1,1)== "S"),], "Output/Consumption/HeatConsumptionbyLA.csv")

HeatWorking$Coal <- HeatWorking$`Coal - Industrial` + HeatWorking$`Coal - Commercial` + HeatWorking$`Coal - Domestic`+ HeatWorking$`Coal - Public Sector`

HeatWorking$`Manufactured fuels` <- HeatWorking$`Manufactured fuels - Industrial` + HeatWorking$`Manufactured fuels - Domestic`

HeatWorking$`Petroleum products` <- HeatWorking$`Petroleum products - Industrial` +
                                    HeatWorking$`Petroleum products - Commercial` +
                                    HeatWorking$`Petroleum products - Domestic` +
                                    HeatWorking$`Petroleum products - Public Sector` +
                                    HeatWorking$`Petroleum products - Agriculture`
  

HeatWorking$`Total Gas` <- HeatWorking$`Gas - Industrial`+HeatWorking$`Gas - Commercial`+HeatWorking$`Gas - Domestic`

HeatWorking$`Bioenergy & Wastes` <- HeatWorking$`Bioenergy & Wastes - Industrial`+HeatWorking$`Bioenergy & Wastes - Commercial`+HeatWorking$`Bioenergy & wastes - Domestic`

names(HeatWorking)[21] <- "Total - All Fuels"

HeatDetailed <- HeatWorking

HeatWorking[4:20] <- NULL

write_csv(HeatWorking[which(substr(HeatWorking$`LA Code`,1,1)== "S"),], "Output/Consumption/HeatConsumptionbyLAMap.csv")

