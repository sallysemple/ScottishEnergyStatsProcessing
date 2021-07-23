library(readxl)
library(magrittr)
library(tidyverse)
library(reshape2)

FullDataset <- read_excel("Data Sources/Greenhouse Gas/FullDataset.xlsx", 
                          sheet = "Scottish GHG data")

FullDataset <- FullDataset %>%
  group_by(EmissionYear, `CCP_categories`) %>% 
  summarise( `GHG Emissions (MtCO2e)` = sum(`GHG Emissions (MtCO2e)`))

FullDataset <- dcast(FullDataset, EmissionYear ~ `CCP_categories`)

write.table(
  FullDataset,
  "Output/Greenhouse Gas/GHGCCP.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

