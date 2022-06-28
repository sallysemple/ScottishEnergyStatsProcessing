library(readxl)
library(magrittr)
library(tidyverse)
library(reshape2)

FullDataset <- read_excel("Data Sources/Greenhouse Gas/FullDataset.xlsx", 
                          sheet = "Scottish GHG data")

FullDataset <- FullDataset %>%
  group_by(EmissionYear, `CCP_category`) %>% 
  summarise( `Emmisions (MtCO2e)` = sum(`Emmisions (MtCO2e)`))

FullDataset <- dcast(FullDataset, EmissionYear ~ `CCP_category`)

write.table(
  FullDataset,
  "Output/Greenhouse Gas/GHGCCP.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

