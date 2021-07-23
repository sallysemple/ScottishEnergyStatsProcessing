library(readxl)
library(magrittr)
library(tidyverse)
library(reshape2)

FullDataset <- read_excel("Data Sources/Greenhouse Gas/FullDataset.xlsx", 
                          sheet = "Scottish GHG data")

FullDataset$Category <- "Other"

FullDataset[which(FullDataset$`CCP_categories` == "Industry"),]$Category <- "Industry"

FullDataset[which(FullDataset$IPCC == "1A1ai_Public_Electricity&Heat_Production"),]$Category <- "Electricity"


FullDataset[which(FullDataset$`NCFormat` == "International Aviation and Shipping"),]$Category <- "Transport"
FullDataset[which(FullDataset$`NCFormat` == "Transport"),]$Category <- "Transport"
FullDataset[which(FullDataset$`SG_categories` == "Transport"),]$`SG_categories` <- "Domestic Transport"

FullDataset[which(FullDataset$`SG_categories` == "Business and Industrial Process" & FullDataset$SourceName == "Miscellaneous industrial/commercial combustion"),]$Category <- "Heat"
FullDataset[which(FullDataset$`SG_categories` == "Public"),]$Category <- "Heat"
FullDataset[which(FullDataset$`SG_categories` == "Residential" & FullDataset$SourceName == "Domestic combustion"),]$Category <- "Heat"

#Take Inventory and map what we include 

ElectricityDataset <- FullDataset[which(FullDataset$Category == "Electricity"),]
TransportDataset <- FullDataset[which(FullDataset$Category == "Transport"),]
HeatDataset <- FullDataset[which(FullDataset$Category == "Heat"),]

FullDataset <- FullDataset %>%
  group_by(EmissionYear, Category) %>% 
  summarise( `GHG Emissions (MtCO2e)` = sum(`GHG Emissions (MtCO2e)`))

FullDataset <- dcast(FullDataset, EmissionYear ~ Category)

FullDataset$Total <- rowSums(FullDataset[2:6])

write.csv(
  FullDataset,
  "Output/Greenhouse Gas/GHGSector.csv",
  na = "0",
  row.names = FALSE
)


ElectricityDataset <- ElectricityDataset %>%
  group_by(EmissionYear, SourceName) %>% 
  summarise( `GHG Emissions (MtCO2e)` = sum(`GHG Emissions (MtCO2e)`))

ElectricityDataset <- dcast(ElectricityDataset, EmissionYear ~ SourceName)

write.csv(
  ElectricityDataset,
  "Output/Greenhouse Gas/GHGElectricityBreakdown.csv",
  na = "0",
  row.names = FALSE
)

HeatDataset <- HeatDataset %>%
  group_by(EmissionYear, `SG_categories`) %>% 
  summarise( `GHG Emissions (MtCO2e)` = sum(`GHG Emissions (MtCO2e)`))

HeatDataset <- dcast(HeatDataset, EmissionYear ~ `SG_categories`)

write.csv(
  HeatDataset,
  "Output/Greenhouse Gas/GHGHeatBreakdown.csv",
  na = "0",
  row.names = FALSE
)

TransportDataset <- TransportDataset %>%
  group_by(EmissionYear, `SG_categories`) %>% 
  summarise( `GHG Emissions (MtCO2e)` = sum(`GHG Emissions (MtCO2e)`))

TransportDataset <- dcast(TransportDataset, EmissionYear ~ `SG_categories`)

write.csv(
  TransportDataset,
  "Output/Greenhouse Gas/GHGTransportBreakdown.csv",
  na = "0",
  row.names = FALSE
)

