library(readxl)
library(magrittr)
library(tidyverse)
library(reshape2)

FullDataset <- read_excel("Data Sources/Greenhouse Gas/FullDataset.xlsx", 
                          sheet = "Scottish GHG data")

FullDataset$Category <- "Other"

#additional section to recreate the old SG emissions categories where required.
##################################################################################
FullDataset$`Old_SG_name` <- "Other"
FullDataset[which(FullDataset$`NCFormat` == "International Aviation & Shipping"),]$`Old_SG_name` <- "International Aviation & Shipping"
FullDataset[which(FullDataset$`NCFormat` == "Transport"),]$`Old_SG_name` <- "Transport"
FullDataset[which(FullDataset$`NCFormat` == "Business"),]$`Old_SG_name` <- "Business and Industrial Process"
FullDataset[which(FullDataset$`NCFormat` == "Industrial processes"),]$`Old_SG_name` <- "Business and Industrial Process"
FullDataset[which(FullDataset$`NCFormat` == "Residential"),]$`Old_SG_name` <- "Residential"
FullDataset[which(FullDataset$`NCFormat` == "Public"),]$`Old_SG_name` <- "Public"
##################################################################################

FullDataset[which(FullDataset$`CCP_category` == "Industry"),]$Category <- "Industry"

FullDataset[which(FullDataset$IPCC_name == "1A1ai_Public_Electricity&Heat_Production"),]$Category <- "Electricity"


FullDataset[which(FullDataset$`NCFormat` == "International Aviation & Shipping"),]$Category <- "Transport"
FullDataset[which(FullDataset$`NCFormat` == "Transport"),]$Category <- "Transport"
FullDataset[which(FullDataset$`Old_SG_name` == "Transport"),]$`Old_SG_name` <- "Domestic Transport"

FullDataset[which(FullDataset$`Old_SG_name` == "Business and Industrial Process" & FullDataset$SourceName == "Miscellaneous industrial/commercial combustion"),]$Category <- "Heat"
FullDataset[which(FullDataset$`NCFormat` == "Public"),]$Category <- "Heat"
FullDataset[which(FullDataset$`NCFormat` == "Residential" & FullDataset$`IPCC_name` == "1A4bi_Residential_stationary"),]$Category <- "Heat"

#Take Inventory and map what we include 

ElectricityDataset <- FullDataset[which(FullDataset$Category == "Electricity"),]
TransportDataset <- FullDataset[which(FullDataset$Category == "Transport"),]
HeatDataset <- FullDataset[which(FullDataset$Category == "Heat"),]

FullDataset <- FullDataset %>%
  group_by(EmissionYear, Category) %>% 
  summarise( `Emmisions (MtCO2e)` = sum(`Emmisions (MtCO2e)`))

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
  summarise( `Emmisions (MtCO2e)` = sum(`Emmisions (MtCO2e)`))

ElectricityDataset <- dcast(ElectricityDataset, EmissionYear ~ SourceName)

write.csv(
  ElectricityDataset,
  "Output/Greenhouse Gas/GHGElectricityBreakdown.csv",
  na = "0",
  row.names = FALSE
)

HeatDataset <- HeatDataset %>%
  group_by(EmissionYear, `Old_SG_name`) %>% 
  summarise( `Emmisions (MtCO2e)` = sum(`Emmisions (MtCO2e)`))

HeatDataset <- dcast(HeatDataset, EmissionYear ~ `Old_SG_name`)

write.csv(
  HeatDataset,
  "Output/Greenhouse Gas/GHGHeatBreakdown.csv",
  na = "0",
  row.names = FALSE
)

TransportDataset <- TransportDataset %>%
  group_by(EmissionYear, `Old_SG_name`) %>% 
  summarise( `Emmisions (MtCO2e)` = sum(`Emmisions (MtCO2e)`))

TransportDataset <- dcast(TransportDataset, EmissionYear ~ `Old_SG_name`)

write.csv(
  TransportDataset,
  "Output/Greenhouse Gas/GHGTransportBreakdown.csv",
  na = "0",
  row.names = FALSE
)