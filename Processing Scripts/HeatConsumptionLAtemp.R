library(readr)
library(plyr)
library(dplyr)
library(readxl)
library(tidyverse)

print("HeatConsumptionLA")

# HeatWorking <- read_excel("Data Sources/Subnational Consumption/Scotland_Total_Final_Energy_Consumption.xlsx") 
# 
# HeatWorking <- HeatWorking[which(HeatWorking$UNIT == "GWh"),]
# 
# HeatWorking <- HeatWorking %>%  select("LAUA", YEAR, "Coal_Industrial", "Coal_Commercial", "Coal_Domestic", "Manufactured_Industrial", "Manufactured_Domestic", "Petroleum_Industrial", "Petroleum_Commercial", "Petroleum_Domestic", "Petroleum_Public", "Petroleum_Agriculture", "Gas_Commercial", "Gas_Domestic", "Bioenergy_Commercial", "Bioenergy_Domestic")

HeatWorking <- read_csv("Output/Consumption/TotalFinalConsumption.csv")

HeatEndUseMultipliers <- read_excel("Data Sources/Subnational Consumption/HeatEndUseMultipliers2.xlsx")

HeatWorking <- HeatWorking %>%  select(names(HeatEndUseMultipliers))

HeatEndUseMultipliers <- merge(HeatEndUseMultipliers, HeatWorking[1:2], all = TRUE)

HeatEndUseMultipliers <- HeatEndUseMultipliers[order(HeatEndUseMultipliers$Year, rev(HeatEndUseMultipliers$`LA Code`)),]


HeatEndUseMultipliers <- HeatEndUseMultipliers %>%  fill(4:20)

HeatWorking[4:20] <- HeatWorking[4:20] * HeatEndUseMultipliers[4:20]

HeatWorking$Total <- rowSums(HeatWorking[4:20])

write_csv(HeatWorking, "Output/Consumption/HeatConsumptionbyLA.csv")
