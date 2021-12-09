library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(data.table)

# Source Energy Consumption
source("Processing Scripts/FinalConsumption.R")

# Keep only Scotland
TotalFinalLAConsumption <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$`LA Code` == "S92000003"),]

# Keep only columns that matter
TotalFinalLAConsumption <- select(TotalFinalLAConsumption, Year, `Consuming Sector - Transport`)

# Load Biofuels proportions (which need to be updated manually)
BiofuelsProportion <- read_excel("Data Sources/MANUAL/BiofuelsProportion.xlsx")

# Merge Data Frames
BiofuelsProportion <- merge(TotalFinalLAConsumption, BiofuelsProportion, all.y = TRUE)

# Fill Transport consumption down for a provisional year
BiofuelsProportion <- BiofuelsProportion %>% fill(2)

# Multiply transport consumption with the biofuels proportion to get biofuels used in transport
BiofuelsProportion$Biofuels <- BiofuelsProportion$`Consuming Sector - Transport` * BiofuelsProportion$`Biofuel Proportion`

# Export to CSV
write_csv(BiofuelsProportion, "Output/Consumption/BiofuelsInTransport.csv")

