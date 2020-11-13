library(readr)
library(plyr)
library(lubridate)
library(tidyverse)
library(reshape2)
library(dplyr)
### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

source("R Scripts/Part 2/Daily Demand.R")

ElecDemandHalfHourly <-
  read.csv("R Data Output/ElecDemandHalfHourly.csv")
ElecDemandHalfHourly <-
  subset(ElecDemandHalfHourly,
         substring(ElecDemandHalfHourly$SETTLEMENT_DATE, 1, 4) >= 2018)
AllScotland <- read_csv("National Grid/AllScotland.csv")

Midnight <- ymd_hms("01/01/01 00:00:00")
HalfHour <- hms("00:30:00")

Midnight + HalfHour

ElecDemandHalfHourly$Time <-
  ((ElecDemandHalfHourly$SETTLEMENT_PERIOD - 1) * HalfHour) + Midnight

ElecDemandHalfHourly$Time <-
  substring(ElecDemandHalfHourly$Time, 12, 20)

ElecDemandHalfHourly$Period <-
  paste(ElecDemandHalfHourly$SETTLEMENT_DATE,
        ElecDemandHalfHourly$Time,
        sep = " ")

ElecDemandHalfHourly$Period <- ymd_hms(ElecDemandHalfHourly$Period)

ElecDemandHalfHourly <-
  ElecDemandHalfHourly %>%  select(c("Period", "Total"))

AllScotland$Period <- ymd_hms(AllScotland$data.data.from)

AllScotland[3:5] <- NULL

CombinedData <-
  merge(ElecDemandHalfHourly, AllScotland, all.y = TRUE) %>% mutate(BiomassValue = biomass * Total / 100) %>% 
 mutate(BiomassValue = biomass * Total / 100) %>% 
mutate(CoalValue = coal * Total / 100) %>% 
 mutate(GasValue = gas * Total / 100) %>% 
 mutate(HydroValue = hydro * Total / 100) %>% 
 mutate(ImportsValue = imports * Total / 100) %>% 
 mutate(NuclearValue = nuclear * Total / 100) %>% 
 mutate(OtherValue = other * Total / 100) %>% 
 mutate(SolarValue = solar * Total / 100) %>% 
 mutate(WindValue = wind * Total / 100)


write_csv(CombinedData, "R Data Output/HalfHourlyDemand.csv")

# GBElecDemand <-
#   do.call(rbind.fill,
#           lapply(
#             list.files(path = "Daily Demand/Sources/Electricity/", full.names = TRUE),
#             read_csv
#           ))
# 
# GBElecDemand$SETTLEMENT_DATE <-
#   lubridate::dmy(GBElecDemand$SETTLEMENT_DATE)
# 
# GBElecDemand$SETTLEMENT_DATE <-
#   as.Date(GBElecDemand$SETTLEMENT_DATE, format = "%Y-%m-%d")
# 
# GBElecDemand <- distinct(GBElecDemand)
# 
# GBElecDemand <- merge(GBElecDemand, WindProportion, all.x = TRUE)
# 
# GBElecDemand <- fill(GBElecDemand, WindPercentage)
# 
# GBElecDemand <- distinct(GBElecDemand)
# 
# GBElecDemand <- merge(GBElecDemand, SolarProportion, all.x = TRUE)
# 
# GBElecDemand <- fill(GBElecDemand, SolarPercentage)
# 
# GBElecDemand <- distinct(GBElecDemand)

# GBElecDemand <-
#   do.call(rbind.fill,
#           lapply(
#             list.files(path = "Daily Demand/Sources/Electricity/", full.names = TRUE),
#             read_csv
#           ))
# 
# GBElecDemand <- GBElecDemand %>% arrange(-row_number())
# GBElecDemandCorrections <- read_csv("Daily Demand/Sources/Electricity/Corrections/Corrections.csv")
# 
# names(GBElecDemandCorrections) <- names(GBElecDemand)
# 
# GBElecDemand <- rbind(GBElecDemandCorrections,GBElecDemand)
# 
# 
# 
# GBElecDemand$SETTLEMENT_DATE <-
#   lubridate::dmy(GBElecDemand$SETTLEMENT_DATE)
# 
# GBElecDemand$SETTLEMENT_DATE <-
#   as.Date(GBElecDemand$SETTLEMENT_DATE, format = "%Y-%m-%d")
# 
# GBElecDemand <- GBElecDemand %>% distinct(SETTLEMENT_DATE,SETTLEMENT_PERIOD, .keep_all = TRUE)
# 
# GBElecDemand$FORECAST_ACTUAL_INDICATOR <- NULL
# 
# GBElecDemand <- GBElecDemand[!duplicated(GBElecDemand),]
# 
# GBElecDemand <- merge(GBElecDemand, WindProportion, all.x = TRUE)
# 
# GBElecDemand <- fill(GBElecDemand, WindPercentage)
# 
# GBElecDemand <- merge(GBElecDemand, SolarProportion, all.x = TRUE)
# 
# GBElecDemand <- fill(GBElecDemand, SolarPercentage)
# 
# ### Getting 2010 Proportions from Q1 2011 ###
# 
# # ElecDemand[ElecDemand == 0] <- NA
# # 
# # ElecDemand <- fill(ElecDemand, 24:25, .direction = "up")
# # 
# GBElecDemand <- GBElecDemand %>% mutate_at(c(2:ncol(GBElecDemand)), ~replace(., is.na(.), 0)) 
# 
# 
# GBElecDemand <- GBElecDemand[complete.cases(GBElecDemand),]


###


GBElecDemand$Total <-
  GBElecDemand$ND + GBElecDemand$EMBEDDED_WIND_GENERATION + GBElecDemand$EMBEDDED_SOLAR_GENERATION

GBElecDemandHalfHourly <-
  GBElecDemand %>%  select(c("SETTLEMENT_DATE", "SETTLEMENT_PERIOD", "Total"))

GBElecDemand <- distinct(GBElecDemand)

write_csv(GBElecDemandHalfHourly,
          "R Data Output/GBElecDemandHalfHourly.csv")

GBElecDemandHalfHourly <-
  subset(GBElecDemandHalfHourly,
         substring(GBElecDemandHalfHourly$SETTLEMENT_DATE, 1, 4) >= 2018)
GB <- read_csv("National Grid/GB.csv")

Midnight <- ymd_hms("01/01/01 00:00:00")
HalfHour <- hms("00:30:00")

Midnight + HalfHour

GBElecDemandHalfHourly$Time <-
  ((GBElecDemandHalfHourly$SETTLEMENT_PERIOD - 1) * HalfHour) + Midnight

GBElecDemandHalfHourly$Time <-
  substring(GBElecDemandHalfHourly$Time, 12, 20)

GBElecDemandHalfHourly$Period <-
  paste(GBElecDemandHalfHourly$SETTLEMENT_DATE,
        GBElecDemandHalfHourly$Time,
        sep = " ")

GBElecDemandHalfHourly$Period <- ymd_hms(GBElecDemandHalfHourly$Period)

GBElecDemandHalfHourly <-
  GBElecDemandHalfHourly %>%  select(c("Period", "Total"))

GB$Period <- ymd_hms(GB$data.data.from)

GB[3:5] <- NULL

GBCombinedData <-
  merge(GBElecDemandHalfHourly, GB, all.y = TRUE) %>% mutate(BiomassValue = biomass * Total / 100) %>% 
  mutate(BiomassValue = biomass * Total / 100) %>% 
  mutate(CoalValue = coal * Total / 100) %>% 
  mutate(GasValue = gas * Total / 100) %>% 
  mutate(HydroValue = hydro * Total / 100) %>% 
  mutate(ImportsValue = imports * Total / 100) %>% 
  mutate(NuclearValue = nuclear * Total / 100) %>% 
  mutate(OtherValue = other * Total / 100) %>% 
  mutate(SolarValue = solar * Total / 100) %>% 
  mutate(WindValue = wind * Total / 100)

GBCombinedData <- distinct(GBCombinedData)
write_csv(GBCombinedData, "R Data Output/GBHalfHourlyDemand.csv")

