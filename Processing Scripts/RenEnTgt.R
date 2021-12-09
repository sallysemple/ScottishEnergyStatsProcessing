library(readxl)
library(readr)
library(plyr)
library(dplyr)
library(reshape2)

# Source Heat Demand
source("Processing Scripts/FinalConsumption.R")

# Extract Scotland and relevant columns
Consumption <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$`LA Code` == "S92000003"),] %>%  select(Year, `LA Code`, `Electricity - Total`, `All fuels - Total`)

source("Processing Scripts/RenElecTgt.R")
source("Processing Scripts/RenewableHeatTarget.R")
source("Processing Scripts/BiofuelsinTransport.R")


# Combine
x <- merge(Consumption, RenElecTgt)

merge(x, RenHeatTgt)
