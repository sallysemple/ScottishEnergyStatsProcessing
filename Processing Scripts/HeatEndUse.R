library(readODS)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

### This script calculates the heat end use for each sector and fuel, for each year there is data###


# Load Script
source("Processing Scripts/FinalConsumption.R")

# Start Dataframe using years from the End Use Table
HeatEndUseMultipliers <- data.frame(Year = rev(unique(End_Use_Table$Year)))

End_Use_Table <- End_Use_Table[which(End_Use_Table$`End use` %in% c("Heat total", "Overall total")),]

End_Use_Table$Lookup <- paste0(End_Use_Table$variable,End_Use_Table$Sector,End_Use_Table$`End use`)

End_Use_Table <- dcast(End_Use_Table, Year ~ Lookup)


HeatEndUseMultipliers$`Coal - Industrial`	<- End_Use_Table$`Solid fuelIndustryHeat total` / End_Use_Table$`Solid fuelIndustryOverall total`

HeatEndUseMultipliers$`Coal - Commercial`	<- HeatEndUseMultipliers$`Coal - Industrial`

HeatEndUseMultipliers$`Coal - Domestic` <- 1

HeatEndUseMultipliers$`Coal - Public Sector` <- HeatEndUseMultipliers$`Coal - Commercial`

HeatEndUseMultipliers$`Manufactured fuels - Industrial` <- End_Use_Table$`Solid fuelIndustryHeat total` / End_Use_Table$`Solid fuelIndustryOverall total`

HeatEndUseMultipliers$`Manufactured fuels - Domestic`	<- 1

HeatEndUseMultipliers$`Petroleum products - Industrial`	<- End_Use_Table$`OilIndustryHeat total` / End_Use_Table$`OilIndustryOverall total`

HeatEndUseMultipliers$`Petroleum products - Commercial`	<- End_Use_Table$`OilServiceHeat total` / End_Use_Table$`OilServiceOverall total`

HeatEndUseMultipliers$`Petroleum products - Domestic`	<- End_Use_Table$`OilDomesticHeat total` / End_Use_Table$`OilDomesticOverall total`

HeatEndUseMultipliers$`Petroleum products - Public Sector`	<- HeatEndUseMultipliers$`Petroleum products - Commercial`

HeatEndUseMultipliers$`Petroleum products - Agriculture`	<- HeatEndUseMultipliers$`Petroleum products - Domestic`

HeatEndUseMultipliers$`Gas - Industrial`	<- End_Use_Table$`GasIndustryHeat total`/ End_Use_Table$`GasIndustryOverall total`

HeatEndUseMultipliers$`Gas - Commercial`	<- End_Use_Table$`GasServiceHeat total`/ End_Use_Table$`GasServiceOverall total`

HeatEndUseMultipliers$`Gas - Domestic`	<- 1

HeatEndUseMultipliers$`Bioenergy & Wastes - Industrial`	<- End_Use_Table$`Bioenergy & WasteIndustryHeat total`/End_Use_Table$`Bioenergy & WasteIndustryOverall total`

HeatEndUseMultipliers$`Bioenergy & Wastes - Commercial`	<- End_Use_Table$`Bioenergy & WasteServiceHeat total`/ End_Use_Table$`Bioenergy & WasteServiceOverall total`

HeatEndUseMultipliers$`Bioenergy & wastes - Domestic`<- End_Use_Table$`Bioenergy & WasteDomesticHeat total`/ End_Use_Table$`Bioenergy & WasteDomesticOverall total`


OldHeatEndUseMultipliers <- read_excel("Data Sources/Subnational Consumption/HeatEndUseMultipliers.xlsx")

HeatEndUseMultipliers <- bind_rows(OldHeatEndUseMultipliers, HeatEndUseMultipliers)

HeatEndUseMultipliers <- HeatEndUseMultipliers %>% fill(1:3)

write_csv(HeatEndUseMultipliers, "Output/Consumption/HeatEndUseMultipliers.csv")