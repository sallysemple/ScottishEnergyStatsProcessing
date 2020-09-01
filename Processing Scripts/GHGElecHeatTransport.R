library(readxl)
library(magrittr)
library(tidyverse)
library(reshape2)

FullDataset <- read_excel("Data Sources/Greenhouse Gas/FullDataset.xlsx", 
                          sheet = "GHG data 2018")

FullDataset$Category <- "Other"

FullDataset[which(FullDataset$SourceName == "Power stations"),]$Category <- "Electricity"


FullDataset[which(FullDataset$`National Communication Categories` == "International Aviation and Shipping"),]$Category <- "Transport"
FullDataset[which(FullDataset$`National Communication Categories` == "Transport (excluding international)"),]$Category <- "Transport"

FullDataset[which(FullDataset$`SG Source Sector` == "Business and Industrial Process" & FullDataset$SourceName == "Miscellaneous industrial/commercial combustion"),]$Category <- "Heat"
FullDataset[which(FullDataset$`SG Source Sector` == "Public Sector Buildings"),]$Category <- "Heat"
FullDataset[which(FullDataset$`SG Source Sector` == "Residential" & FullDataset$SourceName == "Domestic combustion"),]$Category <- "Heat"

FullDataset <- FullDataset %>%
  group_by(EmissionYear, Category) %>% 
  summarise( `Emissions (MtCO2e)` = sum(`Emissions (MtCO2e)`))

FullDataset <- dcast(FullDataset, EmissionYear ~ Category)

write.table(
  FullDataset,
  "Output/Greenhouse Gas/GHGElecHeatTransport.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)