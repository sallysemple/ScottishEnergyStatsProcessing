library(readr)
library(plyr)
library(dplyr)
library(tidyverse)
library(lubridate)

print("Exports to NI")

ElecDemand <-
  do.call(rbind.fill,
          lapply(
            list.files(path = "Data Sources/National Grid Data Explorer/", full.names = TRUE, pattern = "\\.csv$"),
            read_csv
          ))

ElecDemand <- ElecDemand %>% arrange(-row_number())
ElecDemandCorrections <- read_csv("Data Sources/National Grid Data Explorer/Corrections/Corrections.csv")



names(ElecDemandCorrections) <- names(ElecDemand)

ElecDemand <- rbind(ElecDemandCorrections,ElecDemand)



ElecDemand$SETTLEMENT_DATE <-
  lubridate::dmy(ElecDemand$SETTLEMENT_DATE)

ElecDemand$SETTLEMENT_DATE <-
  as.Date(ElecDemand$SETTLEMENT_DATE, format = "%Y-%m-%d")

ElecDemand <- ElecDemand %>% distinct(SETTLEMENT_DATE,SETTLEMENT_PERIOD, .keep_all = TRUE)

ElecDemand$FORECAST_ACTUAL_INDICATOR <- NULL

ElecDemand <- ElecDemand[!duplicated(ElecDemand),]

ElecDemand$Month <- format(ymd(ElecDemand$SETTLEMENT_DATE), format = "%b %Y")

ElecDemand <- ElecDemand[c(1,2,17,28)]

ElecDemand$MOYLE_FLOW <- ifelse(ElecDemand$MOYLE_FLOW < 0, ElecDemand$MOYLE_FLOW/-2000, 0)

ElecDemand <-  ElecDemand %>% 
  group_by(Month) %>% 
  summarise(MOYLE_FLOW = sum(MOYLE_FLOW))

names(ElecDemand) <- c("Month Year", "Exports to NI")

write.table(ElecDemand,
            "Output/Exports/ExportsNI.txt",
            sep = "\t",
            row.names = FALSE)
