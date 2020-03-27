library(readr)

TotalFinalConsumption <- read_csv("Output/Consumption/TotalFinalConsumption.csv")
ElectricityConsumption <- read_csv("Output/Consumption/ElectricityConsumption.csv")
GasConsumption <- read_csv("Output/Consumption/GasConsumption.csv")

LAUpdatedConsumption <- merge(TotalFinalConsumption, ElectricityConsumption, by = c("LA Code", "Year"))

LAUpdatedConsumption <- merge(LAUpdatedConsumption, GasConsumption, by = c("LA Code", "Year"))

write_csv(LAUpdatedConsumption, "Output/Consumption/Test.csv")
