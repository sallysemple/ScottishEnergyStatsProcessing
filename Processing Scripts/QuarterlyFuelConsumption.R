library(readr)
library(lubridate)
library(zoo)
library(plyr)
library(dplyr)
library(timeDate)

print("QuarterlyFuelConsumption")

AllScotland <- read_csv("Data Sources/National Grid API/AllScotland.csv")

AllScotland <- AllScotland[c(2,4,8:16)]


names(AllScotland)[1:2] <- c("region", "time")

AllScotland$time <- as.Date(ymd_hms(AllScotland$time))

AllScotland <- AllScotland[which(AllScotland$time >= ymd("2018-07-01") ),]

AllScotland <- AllScotland[which(AllScotland$time < ymd(timeFirstDayInQuarter(max(AllScotland$time)))),]

AllScotland$time <- as.yearqtr(AllScotland$time)

AllScotlandQTR <- AllScotland %>% group_by(region, time) %>% summarise(
  biomass = mean(biomass),
  coal = mean(coal),
  gas = mean(gas),
  hydro = mean(hydro),
  imports = mean(imports),
  nuclear = mean(nuclear),
  other = mean(other),
  solar = mean(solar),
  wind = mean(wind)
)

write_csv(AllScotlandQTR, "Output/National Grid API/AllScotlandQTR.csv")

AllScotlandYear <- read_csv("Data Sources/National Grid API/AllScotland.csv")

AllScotlandYear <- AllScotlandYear[c(2,4,8:16)]

names(AllScotlandYear)[1:2] <- c("region", "time")

AllScotlandYear$time <- as.Date(ymd_hms(AllScotlandYear$time))

AllScotlandYear <- AllScotlandYear[which(AllScotlandYear$time >= ymd("2019-01-01") ),]

AllScotlandYear <- AllScotlandYear[which(AllScotlandYear$time < ymd(paste0(substr(max(AllScotlandYear$time),1,4),"-01-01"))),]

AllScotlandYear$time <- substr(AllScotlandYear$time,1,4)

AllScotlandYear <- AllScotlandYear %>% group_by(region, time) %>% summarise(
  biomass = mean(biomass),
  coal = mean(coal),
  gas = mean(gas),
  hydro = mean(hydro),
  imports = mean(imports),
  nuclear = mean(nuclear),
  other = mean(other),
  solar = mean(solar),
  wind = mean(wind)
)

write_csv(AllScotlandYear, "Output/National Grid API/AllScotlandYear.csv")

AllScotlandRolling <- AllScotland[order(AllScotland$time, decreasing = TRUE),]

AllScotlandRolling$time <- as.character(AllScotlandRolling$time)

RollingListValues <- unique(AllScotlandRolling$time)

RollingList <- list()

for (i in 1:(length(RollingListValues)-3)){
  AllScotlandRollingWorking <- AllScotlandRolling[which(AllScotlandRolling$time %in% c(RollingListValues[i:(i+3)])),]
  
  AllScotlandRollingWorking <- AllScotlandRollingWorking %>%  group_by(region) %>% summarise(
    biomass = mean(biomass),
    coal = mean(coal),
    gas = mean(gas),
    hydro = mean(hydro),
    imports = mean(imports),
    nuclear = mean(nuclear),
    other = mean(other),
    solar = mean(solar),
    wind = mean(wind)
  )
  
  AllScotlandRollingWorking$QuarterEnding <- RollingListValues[i]
  
  RollingList[[i]] <- AllScotlandRollingWorking
  
}

AllScotlandRolling <- bind_rows(RollingList)

write_csv(AllScotlandRolling, "Output/National Grid API/AllScotlandRollingQTR.csv")

### North Scotland ###

NorthScotland <- read_csv("Data Sources/National Grid API/NorthScotland.csv")

NorthScotland <- NorthScotland[c(2,4,8:16)]


names(NorthScotland)[1:2] <- c("region", "time")

NorthScotland$time <- as.Date(ymd_hms(NorthScotland$time))

NorthScotland <- NorthScotland[which(NorthScotland$time >= ymd("2018-07-01") ),]

NorthScotland <- NorthScotland[which(NorthScotland$time < ymd(timeFirstDayInQuarter(max(NorthScotland$time)))),]

NorthScotland$time <- as.yearqtr(NorthScotland$time)

NorthScotlandQTR <- NorthScotland %>% group_by(region, time) %>% summarise(
  biomass = mean(biomass),
  coal = mean(coal),
  gas = mean(gas),
  hydro = mean(hydro),
  imports = mean(imports),
  nuclear = mean(nuclear),
  other = mean(other),
  solar = mean(solar),
  wind = mean(wind)
)

write_csv(NorthScotlandQTR, "Output/National Grid API/NorthScotlandQTR.csv")

NorthScotlandYear <- read_csv("Data Sources/National Grid API/NorthScotland.csv")

NorthScotlandYear <- NorthScotlandYear[c(2,4,8:16)]

names(NorthScotlandYear)[1:2] <- c("region", "time")

NorthScotlandYear$time <- as.Date(ymd_hms(NorthScotlandYear$time))

NorthScotlandYear <- NorthScotlandYear[which(NorthScotlandYear$time >= ymd("2019-01-01") ),]

NorthScotlandYear <- NorthScotlandYear[which(NorthScotlandYear$time < ymd(paste0(substr(max(NorthScotlandYear$time),1,4),"-01-01"))),]

NorthScotlandYear$time <- substr(NorthScotlandYear$time,1,4)

NorthScotlandYear <- NorthScotlandYear %>% group_by(region, time) %>% summarise(
  biomass = mean(biomass),
  coal = mean(coal),
  gas = mean(gas),
  hydro = mean(hydro),
  imports = mean(imports),
  nuclear = mean(nuclear),
  other = mean(other),
  solar = mean(solar),
  wind = mean(wind)
)

write_csv(NorthScotlandYear, "Output/National Grid API/NorthScotlandYear.csv")

NorthScotlandRolling <- NorthScotland[order(NorthScotland$time, decreasing = TRUE),]

NorthScotlandRolling$time <- as.character(NorthScotlandRolling$time)

RollingListValues <- unique(NorthScotlandRolling$time)

RollingList <- list()

for (i in 1:(length(RollingListValues)-3)){
  NorthScotlandRollingWorking <- NorthScotlandRolling[which(NorthScotlandRolling$time %in% c(RollingListValues[i:(i+3)])),]
  
  NorthScotlandRollingWorking <- NorthScotlandRollingWorking %>%  group_by(region) %>% summarise(
    biomass = mean(biomass),
    coal = mean(coal),
    gas = mean(gas),
    hydro = mean(hydro),
    imports = mean(imports),
    nuclear = mean(nuclear),
    other = mean(other),
    solar = mean(solar),
    wind = mean(wind)
  )
  
  NorthScotlandRollingWorking$QuarterEnding <- RollingListValues[i]
  
  RollingList[[i]] <- NorthScotlandRollingWorking
  
}

NorthScotlandRolling <- bind_rows(RollingList)

write_csv(NorthScotlandRolling, "Output/National Grid API/NorthScotlandRollingQTR.csv")

### South Scotland ###

SouthScotland <- read_csv("Data Sources/National Grid API/SouthScotland.csv")

SouthScotland <- SouthScotland[c(2,4,8:16)]


names(SouthScotland)[1:2] <- c("region", "time")

SouthScotland$time <- as.Date(ymd_hms(SouthScotland$time))

SouthScotland <- SouthScotland[which(SouthScotland$time >= ymd("2018-07-01") ),]

SouthScotland <- SouthScotland[which(SouthScotland$time < ymd(timeFirstDayInQuarter(max(SouthScotland$time)))),]

SouthScotland$time <- as.yearqtr(SouthScotland$time)

SouthScotlandQTR <- SouthScotland %>% group_by(region, time) %>% summarise(
  biomass = mean(biomass),
  coal = mean(coal),
  gas = mean(gas),
  hydro = mean(hydro),
  imports = mean(imports),
  nuclear = mean(nuclear),
  other = mean(other),
  solar = mean(solar),
  wind = mean(wind)
)

write_csv(SouthScotlandQTR, "Output/National Grid API/SouthScotlandQTR.csv")

SouthScotlandYear <- read_csv("Data Sources/National Grid API/SouthScotland.csv")

SouthScotlandYear <- SouthScotlandYear[c(2,4,8:16)]

names(SouthScotlandYear)[1:2] <- c("region", "time")

SouthScotlandYear$time <- as.Date(ymd_hms(SouthScotlandYear$time))

SouthScotlandYear <- SouthScotlandYear[which(SouthScotlandYear$time >= ymd("2019-01-01") ),]

SouthScotlandYear <- SouthScotlandYear[which(SouthScotlandYear$time < ymd(paste0(substr(max(SouthScotlandYear$time),1,4),"-01-01"))),]

SouthScotlandYear$time <- substr(SouthScotlandYear$time,1,4)

SouthScotlandYear <- SouthScotlandYear %>% group_by(region, time) %>% summarise(
  biomass = mean(biomass),
  coal = mean(coal),
  gas = mean(gas),
  hydro = mean(hydro),
  imports = mean(imports),
  nuclear = mean(nuclear),
  other = mean(other),
  solar = mean(solar),
  wind = mean(wind)
)

write_csv(SouthScotlandYear, "Output/National Grid API/SouthScotlandYear.csv")

SouthScotlandRolling <- SouthScotland[order(SouthScotland$time, decreasing = TRUE),]

SouthScotlandRolling$time <- as.character(SouthScotlandRolling$time)

RollingListValues <- unique(SouthScotlandRolling$time)

RollingList <- list()

for (i in 1:(length(RollingListValues)-3)){
  SouthScotlandRollingWorking <- SouthScotlandRolling[which(SouthScotlandRolling$time %in% c(RollingListValues[i:(i+3)])),]
  
  SouthScotlandRollingWorking <- SouthScotlandRollingWorking %>%  group_by(region) %>% summarise(
    biomass = mean(biomass),
    coal = mean(coal),
    gas = mean(gas),
    hydro = mean(hydro),
    imports = mean(imports),
    nuclear = mean(nuclear),
    other = mean(other),
    solar = mean(solar),
    wind = mean(wind)
  )
  
  SouthScotlandRollingWorking$QuarterEnding <- RollingListValues[i]
  
  RollingList[[i]] <- SouthScotlandRollingWorking
  
}

SouthScotlandRolling <- bind_rows(RollingList)

write_csv(SouthScotlandRolling, "Output/National Grid API/SouthScotlandRollingQTR.csv")

### GB ###

SouthScotland <- read_csv("Data Sources/National Grid API/SouthScotland.csv")

SouthScotland <- SouthScotland[c(2,4,8:16)]


names(SouthScotland)[1:2] <- c("region", "time")

SouthScotland$time <- as.Date(ymd_hms(SouthScotland$time))

SouthScotland <- SouthScotland[which(SouthScotland$time >= ymd("2018-07-01") ),]

SouthScotland <- SouthScotland[which(SouthScotland$time < ymd(timeFirstDayInQuarter(max(SouthScotland$time)))),]

SouthScotland$time <- as.yearqtr(SouthScotland$time)

SouthScotlandQTR <- SouthScotland %>% group_by(region, time) %>% summarise(
  biomass = mean(biomass),
  coal = mean(coal),
  gas = mean(gas),
  hydro = mean(hydro),
  imports = mean(imports),
  nuclear = mean(nuclear),
  other = mean(other),
  solar = mean(solar),
  wind = mean(wind)
)

write_csv(SouthScotlandQTR, "Output/National Grid API/SouthScotlandQTR.csv")

SouthScotlandYear <- read_csv("Data Sources/National Grid API/SouthScotland.csv")

SouthScotlandYear <- SouthScotlandYear[c(2,4,8:16)]

names(SouthScotlandYear)[1:2] <- c("region", "time")

SouthScotlandYear$time <- as.Date(ymd_hms(SouthScotlandYear$time))

SouthScotlandYear <- SouthScotlandYear[which(SouthScotlandYear$time >= ymd("2019-01-01") ),]

SouthScotlandYear <- SouthScotlandYear[which(SouthScotlandYear$time < ymd(paste0(substr(max(SouthScotlandYear$time),1,4),"-01-01"))),]

SouthScotlandYear$time <- substr(SouthScotlandYear$time,1,4)

SouthScotlandYear <- SouthScotlandYear %>% group_by(region, time) %>% summarise(
  biomass = mean(biomass),
  coal = mean(coal),
  gas = mean(gas),
  hydro = mean(hydro),
  imports = mean(imports),
  nuclear = mean(nuclear),
  other = mean(other),
  solar = mean(solar),
  wind = mean(wind)
)

write_csv(SouthScotlandYear, "Output/National Grid API/SouthScotlandYear.csv")

SouthScotlandRolling <- SouthScotland[order(SouthScotland$time, decreasing = TRUE),]

SouthScotlandRolling$time <- as.character(SouthScotlandRolling$time)

RollingListValues <- unique(SouthScotlandRolling$time)

RollingList <- list()

for (i in 1:(length(RollingListValues)-3)){
  SouthScotlandRollingWorking <- SouthScotlandRolling[which(SouthScotlandRolling$time %in% c(RollingListValues[i:(i+3)])),]
  
  SouthScotlandRollingWorking <- SouthScotlandRollingWorking %>%  group_by(region) %>% summarise(
    biomass = mean(biomass),
    coal = mean(coal),
    gas = mean(gas),
    hydro = mean(hydro),
    imports = mean(imports),
    nuclear = mean(nuclear),
    other = mean(other),
    solar = mean(solar),
    wind = mean(wind)
  )
  
  SouthScotlandRollingWorking$QuarterEnding <- RollingListValues[i]
  
  RollingList[[i]] <- SouthScotlandRollingWorking
  
}

SouthScotlandRolling <- bind_rows(RollingList)

write_csv(SouthScotlandRolling, "Output/National Grid API/SouthScotlandRollingQTR.csv")

### 

