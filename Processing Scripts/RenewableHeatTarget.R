library(readxl)
library(readr)
library(plyr)
library(dplyr)
library(reshape2)

# Source Heat Demand
source("Processing Scripts/HeatConsumptionLA.R")

# Source Heat Generation and Capacity - MUST BE MANUALLY UPDATED
RenHeatGen <- read_excel("Data Sources/MANUAL/RenHeatGen.xlsx")

# Keep only Scotland and the Year and non-industrial Total columns
RenHeatTgt <- HeatDetailed[which(HeatWorking$`LA Code` == "S92000003"),] 
RenHeatTgt$Domestic <- RenHeatTgt$`Gas - Domestic`+RenHeatTgt$`Coal - Domestic`+RenHeatTgt$`Manufactured fuels - Domestic`+RenHeatTgt$`Petroleum products - Domestic` + RenHeatTgt$`Bioenergy & wastes - Domestic`  

RenHeatTgt$Industrial <- RenHeatTgt$`Gas - Industrial`+ RenHeatTgt$`Coal - Industrial`+RenHeatTgt$`Manufactured fuels - Industrial`+RenHeatTgt$`Petroleum products - Industrial` + RenHeatTgt$`Bioenergy & Wastes - Industrial` 

RenHeatTgt$Commercial <- RenHeatTgt$`Total - All Fuels` - RenHeatTgt$Domestic - RenHeatTgt$Industrial  

RenHeatTgt$Total <- RenHeatTgt$`Total - All Fuels` - RenHeatTgt$Industrial    
  

RenHeatTgt$Year <- as.character(RenHeatTgt$Year)
               
RenHeatTgt <- RenHeatTgt[c(2,21,30)]

# Merge Data Frames
RenHeatTgt <- merge(RenHeatGen, RenHeatTgt, all.x = TRUE)

# Fill down for provisional year (if needed)
#RenHeatTgt <- RenHeatTgt %>% fill(4,5)

# Calculate old Target
RenHeatTgt$OldTarget <- RenHeatTgt$`Renewable Heat` / RenHeatTgt$`Total - All Fuels`

# Calculate new Targets
RenHeatTgt$NewMaxTarget <- RenHeatTgt$`Maximum non-industrial renewable heat` / RenHeatTgt$`Total`
RenHeatTgt$NewMinTarget <- RenHeatTgt$`Minimum non-industrial renewable heat` / RenHeatTgt$`Total`

# Reorder Columns
RenHeatTgt <- RenHeatTgt[c(1,2,3,4,6,7,8,9,10,5)]

# Rename Columns
names(RenHeatTgt) <- c("Year","Renewable Heat (GWh)", "Maximum non-industrial renewable heat (GWh)", "Minimum non-industrial renewable heat (GWh)","Non-electrical heat demand (GWh)", "Non-electrical, non-industrial, heat demand (GWh)", 
"Renewable heat target (including industrial)","Maximum non-industrial renewable heat target", "Minimum non-industrial renewable heat target","Capacity" )

# Export to CSV
write_csv(RenHeatTgt, "Output/Consumption/RenHeatTgt.csv")
