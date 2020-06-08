library(readr)
library(plyr)
library(dplyr)
library(readxl)
library(tidyverse)

TotalFinalConsumption <- read_csv("Output/Consumption/TotalFinalConsumption.csv")
ElectricityConsumption <- read_csv("Output/Consumption/ElectricityConsumption.csv")
GasConsumption <- read_csv("Output/Consumption/GasConsumption.csv")

LAUpdatedConsumption <- merge(TotalFinalConsumption, ElectricityConsumption, by = c("LA Code", "Year"))


LAUpdatedConsumption <- merge(LAUpdatedConsumption, GasConsumption, by = c("LA Code", "Year"))

LAUpdatedConsumption[is.na(LAUpdatedConsumption)] <- 0

LAUpdatedConsumption$`Gas - Industrial & Commercial` <- LAUpdatedConsumption$`Sales (GWh) - Non-domestic consumption`

LAUpdatedConsumption$`Gas - Domestic` <- LAUpdatedConsumption$`Sales (GWh) - Domestic consumption`

LAUpdatedConsumption$`Gas - Total` <- LAUpdatedConsumption$`Gas - Industrial & Commercial` + LAUpdatedConsumption$`Gas - Domestic`


LAUpdatedConsumption$`Electricity - Industrial & Commercial` <- LAUpdatedConsumption$`Sales (GWh) - Non-domestic consumers - All non-domestic`

LAUpdatedConsumption$`Electricity - Domestic` <- LAUpdatedConsumption$`Sales (GWh) - Domestic consumers - All domestic`

LAUpdatedConsumption$`Electricity - Total` <- LAUpdatedConsumption$`Electricity - Industrial & Commercial` + LAUpdatedConsumption$`Electricity - Domestic`


LAUpdatedConsumption <- LAUpdatedConsumption[1:28]


LAUpdatedConsumption$`All fuels - Total` <- LAUpdatedConsumption$`Coal - Total` + LAUpdatedConsumption$`Manufactured fuels - Total` + LAUpdatedConsumption$`Petroleum products - Total` + LAUpdatedConsumption$`Gas - Total` + LAUpdatedConsumption$`Electricity - Total` + LAUpdatedConsumption$`Bioenergy & wastes - Total`


LAUpdatedConsumption$`Consuming Sector - Domestic` <- LAUpdatedConsumption$`Coal - Domestic`+LAUpdatedConsumption$`Manufactured fuels - Domestic` + LAUpdatedConsumption$`Petroleum products - Domestic`+LAUpdatedConsumption$`Gas - Domestic`+LAUpdatedConsumption$`Electricity - Domestic`

LAUpdatedConsumption$`Consuming Sector - Transport` <- LAUpdatedConsumption$`Coal - Rail` + LAUpdatedConsumption$`Petroleum products - Road transport` + LAUpdatedConsumption$`Petroleum products - Rail`

LAUpdatedConsumption$`Consuming Sector - Industry & Commercial` <- LAUpdatedConsumption$`All fuels - Total` - LAUpdatedConsumption$`Consuming Sector - Domestic` - LAUpdatedConsumption$`Consuming Sector - Transport`- LAUpdatedConsumption$`Bioenergy & wastes - Total`

write_csv(LAUpdatedConsumption, "Output/Consumption/CorrectedFinalConsumptionbyLA.csv")
