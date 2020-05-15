library(readr)
library(readxl)
library(plyr)
library(dplyr)
library(tidyverse)
library(lubridate)


ElecDemand <- read_excel("Data Sources/Transfer Data/2020.xlsx")

ElecDemand$Month <- format(ymd(ElecDemand$SETT_DATE), format = "%b %Y")

ElecDemand$IMPORT_TO_EW_FROM_SCOT_MW <- ifelse(ElecDemand$IMPORT_TO_EW_FROM_SCOT_MW > 0, ElecDemand$IMPORT_TO_EW_FROM_SCOT_MW/2000, 0)

ElecDemand <-  ElecDemand %>% 
  group_by(Month) %>% 
  summarise(IMPORT_TO_EW_FROM_SCOT_MW = sum(IMPORT_TO_EW_FROM_SCOT_MW))

names(ElecDemand) <- c("Month Year", "Exports to GB")

ElecDemandPP <- read_excel("Data Sources/Transfer Data/Preprocessed/Pre2020.xlsx")

ElecDemandPP$`Month Year` <- format(ymd(ElecDemandPP$`Month Year`), format = "%b %Y")

ElecDemand <- rbind(ElecDemandPP, ElecDemand)

write.table(ElecDemand,
            "Output/Exports/ExportsGB.txt",
            sep = "\t",
            row.names = FALSE)
