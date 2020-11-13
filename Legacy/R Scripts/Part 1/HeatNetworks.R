library(readr)
library(readxl)
library(dplyr)
library(tidyverse)
library(reshape2)
library("readODS")
library(tidyr)
library(tidyverse)
library(magrittr)

print("Heat Networks")


setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

HeatNetworks <- read_csv("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/Data Sources/Heat Networks/Current.csv")

HeatNetworks <- subset(HeatNetworks,
                       select = c(
                         "customer_type",
                         "network_type",
                         "DwellingCustomers",
                         "AllConnectedCustomers",
                         "supply",
                         "capacity_kw",
                         "generation_kwh",
                         "primarytechnology",
                         "secondarytechnology",
                         "primaryfuel",
                         "secondaryfuel",
                         "AllConnectedBuildings"
                       ))
HeatNetworks$Count <- 1

HeatNetworks[is.na(HeatNetworks)] <- 0

SectorbyNetwork <- HeatNetworks[c(1,2,13)]

SectorbyNetwork <- dcast(HeatNetworks, customer_type ~ network_type)

SectorCustomersHeat <- HeatNetworks %>% 
  group_by(customer_type) %>% 
  summarise(DwellingCustomers = sum(DwellingCustomers),
            NonDomConnectedCustomers = sum(AllConnectedCustomers)-sum(DwellingCustomers),
            capacity_kw = sum(capacity_kw, na.rm = TRUE)/1000000,
            generation_kwh = sum(generation_kwh, na.rm = TRUE)/1000000,
            supply = sum(supply, na.rm = TRUE)/1000000
            )

HeatNetworkSectors <- merge(SectorbyNetwork, SectorCustomersHeat, all = TRUE)

write.table(
  HeatNetworkSectors,
  "R Data Output/HeatNetworkSectors.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

HeatNetworkTypes <- HeatNetworks %>% 
  group_by(network_type) %>% 
  summarise(DwellingCustomers = sum(DwellingCustomers),
            NonDomConnectedCustomers = sum(AllConnectedCustomers)-sum(DwellingCustomers),
            capacity_kw = sum(capacity_kw, na.rm = TRUE)/1000000,
            generation_kwh = sum(generation_kwh, na.rm = TRUE)/1000000,
            supply = sum(supply, na.rm = TRUE)/1000000
  )

write.table(
  HeatNetworkTypes,
  "R Data Output/HeatNetworkTypes.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

HeatNetworkTechFuel <- dcast(HeatNetworks, primarytechnology ~ primaryfuel)

write.table(
  HeatNetworkTechFuel,
  "R Data Output/HeatNetworkTechFuel.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


HeatNetworkCustomersTechFuel <- dcast(HeatNetworks, primarytechnology ~ primaryfuel, value.var = 'AllConnectedCustomers', sum)

write.table(
  HeatNetworkCustomersTechFuel,
  "R Data Output/HeatNetworkCustomersTechFuel.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

HeatNetworkBuildingsTechFuel <- dcast(HeatNetworks, primarytechnology ~ primaryfuel, value.var = 'AllConnectedBuildings', sum)

write.table(
  HeatNetworkBuildingsTechFuel,
  "R Data Output/HeatNetworkBuildingsTechFuel.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

HeatNetworkSuppliedTechFuel <- dcast(HeatNetworks, primarytechnology ~ primaryfuel, value.var = 'supply', sum)

HeatNetworkSuppliedTechFuel[2:8] %<>% lapply(function(x) as.numeric(as.character(x))/1000000)

write.table(
  HeatNetworkSuppliedTechFuel,
  "R Data Output/HeatNetworkSuppliedTechFuel.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
