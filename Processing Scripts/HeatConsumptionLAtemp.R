library(readr)
library(plyr)
library(dplyr)
library(readxl)
library(tidyverse)

print("HeatConsumptionLA")

HeatWorking <- read_excel("Data Sources/Subnational Consumption/Scotland_Total_Final_Energy_Consumption.xlsx") 

HeatWorking <- HeatWorking[which(HeatWorking$UNIT == "GWh"),]

HeatWorking <- HeatWorking %>%  select("LAUA", YEAR, "Coal_Industrial", "Coal_Commercial", "Coal_Domestic", "Manufactured_Industrial", "Manufactured_Domestic", "Petroleum_Industrial", "Petroleum_Commercial", "Petroleum_Domestic", "Petroleum_Public", "Petroleum_Agriculture", "Gas_Commercial", "Gas_Domestic", "Bioenergy_Commercial", "Bioenergy_Domestic")

HeatEndUseMultipliers <- read_excel("Data Sources/Subnational Consumption/HeatEndUseMultipliers2.xlsx")

names(HeatEndUseMultipliers) <- names(HeatWorking)

HeatEndUseMultipliers <- merge(HeatEndUseMultipliers, HeatWorking[1:2], all = TRUE)

HeatEndUseMultipliers <- HeatEndUseMultipliers[order(HeatEndUseMultipliers$YEAR, rev(HeatEndUseMultipliers$`LAUA`)),]

HeatEndUseMultipliers <- fill(HeatEndUseMultipliers, 2:16,.direction = "down")

HeatWorking <- HeatWorking[order(HeatWorking$YEAR, rev(HeatWorking$`LAUA`)),]

HeatWorking[3:16] <- HeatWorking[3:16] * HeatEndUseMultipliers[3:16]

HeatWorking <- HeatWorking %>% mutate(Total = select(.,3:16) %>% rowSums(na.rm = TRUE))

LANames <- read_excel("Data Sources/Subnational Consumption/Scotland_Total_Final_Energy_Consumption.xlsx")[1:2]

LANames <-  unique( LANames )

HeatWorking <- merge(HeatWorking,LANames)

HeatWorking <- HeatWorking[c(2,1,18,3:17)]

HeatWorking<- HeatWorking[order(HeatWorking$YEAR),]

write_csv(HeatWorking, "Output/Consumption/HeatConsumptionbyLA.csv")
