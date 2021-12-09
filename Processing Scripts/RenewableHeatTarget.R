library(readxl)
library(readr)
library(plyr)
library(dplyr)
library(reshape2)

# Source Heat Demand
source("Processing Scripts/HeatConsumptionLA.R")

# Source Heat Generation and Capacity - MUST BE MANUALLY UPDATED
RenHeatGen <- read_excel("Data Sources/MANUAL/RenHeatGen.xlsx")

# Keep only Scotland and the Year and Total columns
RenHeatTgt <- HeatWorking[which(HeatWorking$`LA Code` == "S92000003"),] %>% 
                select(Year, `Total - All Fuels`)

# Merge Data Frames
RenHeatTgt <- merge(RenHeatGen, RenHeatTgt, all.x = TRUE)

# Fill down for provisional year (if needed)
RenHeatTgt <- RenHeatTgt %>% fill(4)

# Calculate Target
RenHeatTgt$Target <- RenHeatTgt$`Renewable Heat` / RenHeatTgt$`Total - All Fuels`

# Remove 2009 Data (since it will be filled in the above state and not valid)
RenHeatTgt[2,2:5] <- NA

# Reorder Columns
RenHeatTgt <- RenHeatTgt[c(1,2,4,5,3)]

# Rename Columns
names(RenHeatTgt) <- c("Year", "Renewable Heat Generation", "Heat Consumption", "Heat Target", "Renewable Heat Capacity")

# Export to CSV
write_csv(RenHeatTgt, "Output/Consumption/RenHeatTgt.csv")
