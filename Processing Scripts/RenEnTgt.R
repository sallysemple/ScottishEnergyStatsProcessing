library(readxl)
library(readr)
library(plyr)
library(dplyr)
library(reshape2)

# Source Consumption
source("Processing Scripts/FinalConsumption.R")

# Extract Scotland and relevant columns
Consumption <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$`LA Code` == "S92000003"),] %>%  select(Year, `LA Code`, `Electricity - Total`, `All fuels - Total`)

# Source Ren Elec Target
source("Processing Scripts/RenElecTgt.R")
names(RenElecTgt) <- c("Year", "Renwable Electricity Generation", "Gross Electricity Consumption", "Renewable Electricity Target")

# Source Ren Heat Target
source("Processing Scripts/RenewableHeatTarget.R")
RenHeatTgt <- RenHeatTgt [c(1,2,5,7,10)]
names(RenHeatTgt) <- c("Year","Renewable Heat Generation","Heat Consumption", "Heat Target", "Renewable Heat Capacity")

# Souce Biofuels
source("Processing Scripts/BiofuelsinTransport.R")
BiofuelsProportion

# Combine Files together
RenEnTgt <- merge(Consumption, RenElecTgt)
RenEnTgt <- merge(RenEnTgt, RenHeatTgt)
RenEnTgt <- merge(RenEnTgt, BiofuelsProportion)

# Calculate Consumption for Renewable Energy (replace electricity consumption with gross electricity consumption)
RenEnTgt$`Adjusted Consumption` <- RenEnTgt$`All fuels - Total` - RenEnTgt$`Electricity - Total` + RenEnTgt$`Gross Electricity Consumption`

# Calculate Total Renewable Generation
RenEnTgt$`Renewable Generation` <- (RenEnTgt$`Renwable Electricity Generation`+RenEnTgt$`Renewable Heat Generation`+RenEnTgt$Biofuels)

# Calculate Ren En Target
RenEnTgt$`Renewable Energy Target` <- RenEnTgt$`Renewable Generation` / RenEnTgt$`Adjusted Consumption`

# Calculate individual proportions
RenEnTgt$ElecProportion <- RenEnTgt$`Renwable Electricity Generation` / RenEnTgt$`Adjusted Consumption`
RenEnTgt$HeatProportion <- RenEnTgt$`Renewable Heat Generation` / RenEnTgt$`Adjusted Consumption`
RenEnTgt$TransportProportion <- RenEnTgt$Biofuels / RenEnTgt$`Adjusted Consumption`

# Export to CSV
write_csv(RenEnTgt, "Output/Consumption/RenEnTgt.csv")
