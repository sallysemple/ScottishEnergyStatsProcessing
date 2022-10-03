library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(data.table)

# Source Energy Consumption
source("Processing Scripts/FinalConsumption.R")

# Keep Only Scotland
EnergyTarget <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$`LA Code` == "S92000003"),]

# Extract the three years that make the baseline
BaselineConsumption <- EnergyTarget[which(EnergyTarget$Year %in% c(2005,2006,2007)),]

# Remove Baseline Years from main data set
EnergyTarget <- EnergyTarget[which(!EnergyTarget$Year %in% c(2005,2006,2007)),]

# Calculate mean for each fuel
BaselineConsumption <- colwise(mean)(BaselineConsumption)

# Restore LACode, Year, and Region
BaselineConsumption$`LA Code` <- "S92000003"
BaselineConsumption$Year <- "2005-2007 (baseline)"
BaselineConsumption$Region <- "All local authorities"

# Baseline Total
BaselineTotal <- BaselineConsumption$`All fuels - Total`

EnergyTarget <- as_tibble(EnergyTarget[-c(29)])

# Add baseline back to main data
EnergyTarget <- rbind(BaselineConsumption, EnergyTarget)

# Keep only useful columns
EnergyTarget <- select(EnergyTarget, Year, `All fuels - Total`)


# Calculate change in Energy Consumption
EnergyTarget$Change <- BaselineTotal - EnergyTarget$`All fuels - Total`

# Calculate % change
EnergyTarget$Target <- (EnergyTarget$`All fuels - Total` / BaselineTotal)-1

# Rename Columns 
names(EnergyTarget) <- c("Year", "Total Energy Consumption (GWh)", "Change in Consumption from Baseline (GWh)", "% Progress")

# Export to CSV
write_csv(EnergyTarget, "Output/Consumption/EnergyTarget.csv")
