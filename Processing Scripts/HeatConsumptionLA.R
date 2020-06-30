library(readr)
library(plyr)
library(dplyr)
library(readxl)
library(tidyverse)

print("HeatConsumptionLA")

TotalFinalConsumption <- read_csv("Output/Consumption/TotalFinalConsumption.csv")
ElectricityConsumption <- read_csv("Output/Consumption/ElectricityConsumption.csv")
GasConsumption <- read_csv("Output/Consumption/GasConsumption.csv")

LAUpdatedConsumption <- merge(TotalFinalConsumption, ElectricityConsumption, by = c("LA Code", "Year"))

LAUpdatedConsumption <- merge(LAUpdatedConsumption, GasConsumption, by = c("LA Code", "Year"))

HeatWorking <- LAUpdatedConsumption %>%  select("LA Code", Year, "Coal - Industrial & Commercial", "Coal - Domestic", "Coal - Industrial & Commercial", "Coal - Domestic", "Manufactured fuels - Industrial", "Manufactured fuels - Domestic", "Petroleum products - Industrial & Commercial", "Petroleum products - Domestic", "Petroleum products - Public Sector", "Petroleum products - Agriculture", "Sales (GWh) - Non-domestic consumption", "Sales (GWh) - Domestic consumption", "Bioenergy & wastes - Total")

HeatWorking$`Bioenergy NonDom Split` <- 1
HeatWorking$`Bioenergy Domestic Split` <- 1

HeatEndUseMultipliers <- read_excel("Data Sources/Subnational Consumption/HeatEndUseMultipliers.xlsx")

HeatEndUseMultipliers <- merge(HeatEndUseMultipliers, HeatWorking[1:2], all = TRUE)

HeatEndUseMultipliers <- HeatEndUseMultipliers[order(HeatEndUseMultipliers$Year, rev(HeatEndUseMultipliers$`LA Code`)),]

HeatEndUseMultipliers <- fill(HeatEndUseMultipliers, 2:15,.direction = "down")

HeatWorking <- HeatWorking[order(HeatWorking$Year, rev(HeatWorking$`LA Code`)),]

HeatWorking[3:15] <- HeatWorking[3:15] * HeatEndUseMultipliers[3:15]

HeatWorking$`Bioenergy NonDom Split` <- HeatWorking$`Bioenergy NonDom Split`* HeatWorking$`Bioenergy & wastes - Total`
HeatWorking$`Bioenergy Domestic Split` <- HeatWorking$`Bioenergy Domestic Split`* HeatWorking$`Bioenergy & wastes - Total`

HeatWorking <- HeatWorking %>% mutate(Total = select(.,3:13) %>% rowSums(na.rm = TRUE))

write_csv(HeatWorking, "Output/Consumption/HeatConsumptionbyLA.csv")
