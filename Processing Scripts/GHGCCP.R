library(readxl)
library(magrittr)
library(tidyverse)
library(reshape2)

FullDataset <- read_excel("Data Sources/Greenhouse Gas/FullDataset.xlsx", 
                          sheet = "GHG data 2018")

FullDataset <- FullDataset %>%
  group_by(EmissionYear, `CCP mapping`) %>% 
  summarise( `Emissions (MtCO2e)` = sum(`Emissions (MtCO2e)`))

FullDataset <- dcast(FullDataset, EmissionYear ~ `CCP mapping`)

write.table(
  FullDataset,
  "Output/Greenhouse Gas/GHGCCP.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

