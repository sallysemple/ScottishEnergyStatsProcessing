library(readr)
library(readxl)
library(dplyr)
library(tidyverse)
library(reshape2)

print("ScotStat")

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")
Consumption <- read_delim("R Data Output/Consumption.txt", 
                          "\t", escape_double = FALSE, trim_ws = TRUE)

CodeChanges <- read_excel("Data Sources/Geography Codes/CodeChanges.xlsx")

names(CodeChanges)[1] <- "LAU1"

merged <- merge(Consumption, CodeChanges, all.x = TRUE)

merged$LAU1 <- merged$NewCode

merged$NewCode <- NULL

merged$Council <- NULL

Consumption <- merged

Consumption <-  Consumption %>% 
  melt(id=c("LAU1", "GovernmentRegion", "Year")) %>% 
  mutate(variable = recode(variable, "All Fuels Total" = "All - All")) %>% 
  separate(variable, c("EnergyType", "EnergySector"), sep =" - ") %>% 
  mutate(EnergyType = recode(EnergyType, "Consuming Sector" = "All")) %>%
  mutate(EnergyType = recode(EnergyType, "Total" = "All")) %>%
  mutate(value = floor(as.numeric(value)*100)/100) %>% 
  mutate(value = if_else(is.na(value), 0, value)) %>% 
  mutate(EnergySector = recode(EnergySector, "Industrial" = "Industrial & Commercial")) %>%
  mutate(EnergySector = recode(EnergySector, "Industry & Commercial" = "Industrial & Commercial")) %>%
  mutate(EnergySector = recode(EnergySector, "Road transport" = "Road Transport")) %>% 
  mutate(EnergySector = recode(EnergySector, "Total" = "All"))
  
Consumption$GovernmentRegion <- NULL
Consumption$Measurement = "Count"
Consumption$Units = "GWh"

names(Consumption) <- c("GeographyCode", "DateCode", "Energy Type", "Energy Consuming Sector", "Value", "Measurement", "Units")

Consumption <- Consumption %>% 
  select("GeographyCode", "DateCode", "Measurement", "Units", "Value",  "Energy Consuming Sector", "Energy Type")

### Export to CSV
write_csv(
  Consumption,
  "ScotStat/Consumption.csv")
