library(readxl)
library(magrittr)
library(tidyverse)
library(reshape2)

FullDataset <- read_excel("Data Sources/Greenhouse Gas/FullDataset.xlsx", 
                          sheet = "GHG data 2018")

FullDataset$Category <- "Other"

FullDataset[which(FullDataset$`CCP mapping` == "Industry"),]$Category <- "Indusrty"

FullDataset[which(FullDataset$IPCC == "1A1ai_Public_Electricity&Heat_Production"),]$Category <- "Electricity"


FullDataset[which(FullDataset$`National Communication Categories` == "International Aviation and Shipping"),]$Category <- "Transport"
FullDataset[which(FullDataset$`National Communication Categories` == "Transport (excluding international)"),]$Category <- "Transport"

FullDataset[which(FullDataset$`SG Source Sector` == "Business and Industrial Process" & FullDataset$SourceName == "Miscellaneous industrial/commercial combustion"),]$Category <- "Heat"
FullDataset[which(FullDataset$`SG Source Sector` == "Public Sector Buildings"),]$Category <- "Heat"
FullDataset[which(FullDataset$`SG Source Sector` == "Residential" & FullDataset$SourceName == "Domestic combustion"),]$Category <- "Heat"

#Take Inventory and map what we include 

ElectricityDataset <- FullDataset[which(FullDataset$Category == "Electricity"),]
TransportDataset <- FullDataset[which(FullDataset$Category == "Transport"),]
HeatDataset <- FullDataset[which(FullDataset$Category == "Heat"),]

FullDataset <- FullDataset %>%
  group_by(EmissionYear, Category) %>% 
  summarise( `Emissions (MtCO2e)` = sum(`Emissions (MtCO2e)`))

FullDataset <- dcast(FullDataset, EmissionYear ~ Category)

FullDataset$Total <- rowSums(FullDataset[2:6])

write.table(
  FullDataset,
  "Output/Greenhouse Gas/GHGElecHeatTransport.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


ElectricityDataset <- ElectricityDataset %>%
  group_by(EmissionYear, SourceName) %>% 
  summarise( `Emissions (MtCO2e)` = sum(`Emissions (MtCO2e)`))

ElectricityDataset <- dcast(ElectricityDataset, EmissionYear ~ SourceName)

write.table(
  ElectricityDataset,
  "Output/Greenhouse Gas/GHGElectricityBreakdown.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

HeatDataset <- HeatDataset %>%
  group_by(EmissionYear, `SG Source Sector`) %>% 
  summarise( `Emissions (MtCO2e)` = sum(`Emissions (MtCO2e)`))

HeatDataset <- dcast(HeatDataset, EmissionYear ~ `SG Source Sector`)

write.table(
  HeatDataset,
  "Output/Greenhouse Gas/GHGHeatBreakdown.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

TransportDataset <- TransportDataset %>%
  group_by(EmissionYear, `SG Source Sector`) %>% 
  summarise( `Emissions (MtCO2e)` = sum(`Emissions (MtCO2e)`))

TransportDataset <- dcast(TransportDataset, EmissionYear ~ `SG Source Sector`)

write.table(
  TransportDataset,
  "Output/Greenhouse Gas/GHGTransportBreakdown.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
