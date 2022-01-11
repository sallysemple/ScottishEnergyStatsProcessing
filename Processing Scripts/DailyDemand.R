### Load Packages ###
library(readr)
library(readxl)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(lubridate)
library(plotly)
library(data.table)

###GAS###



### Load Source Data ###
GasDemand <-
  do.call(rbind,
          lapply(
            list.files(path = "Data Sources/Daily Demand/Gas/", full.names = TRUE, pattern = "\\.csv$"),
            read_csv
          )) # Open multiple source files and combine together.

### Rename Columns ###
names(GasDemand) <-
  c("NotDate", "Date", "Item", "Value", "Time", "Category") 

### Subset Data ###
GasDemand <-
  subset(GasDemand, Item != "NTS Energy Offtaken, Moffat, Interconnector", select = c("Date", "Value", "Item")) # Keeps all values that are NOT EQUAL to  ""NTS Energy Offtaken, Moffat, Interconnector"

GasDemand$Date <- lubridate::dmy(GasDemand$Date)

GasDemand <- GasDemand[!duplicated(GasDemand),]
### Group together rows by date ###
GasDemand <- group_by(GasDemand, Date)

### Combine together rows for a per day total ###
GasDemand <-
  dplyr::summarise(GasDemand, Gas = sum(as.numeric(Value)) / 1000000)

### Arrange by Date ###
GasDemand <- dplyr::arrange(GasDemand, Date)

### Convert Dates to be Excel friendly ###
GasDemand$Date <- as.Date(GasDemand$Date, format = "%Y-%m-%d")



############################# Transport ########################################

### Load Sources ###
TransportDemand <-
  read_excel("Data Sources/Daily Demand/Transport/ET_3.13.xlsx",
             sheet = "Month",
             skip = 2)

#Name important columns
names(TransportDemand)[c(1, 6, 7, 9)] <- c("YEAR", "Motor Spirit", "Aviation turbine fuel", "DERV fuel")

#Seperate month and year into seperate columns
TransportDemand <- separate(TransportDemand, YEAR, into = c("MONTH", "YEAR"), sep = " (?=[^ ]+$)")

#Make all columns but first numerical
TransportDemand[2:14]  %<>% lapply(function(x) as.numeric(as.character(x)))

### Convert Units ###
TransportDemand$`Motor Spirit` <- TransportDemand$`Motor Spirit` * 47.09
TransportDemand$`DERV fuel` <- TransportDemand$`DERV fuel` * 45.64369011
TransportDemand$`Aviation turbine fuel` <- TransportDemand$`Aviation turbine fuel` * 46.19

### Calculate Total ###
TransportDemand$Total <-
  TransportDemand$`Motor Spirit` + TransportDemand$`DERV fuel` + TransportDemand$`Aviation turbine fuel`

### Convert Units ###
TransportDemand$Total <- TransportDemand$Total * 1000

TransportDemand$Total <-
  TransportDemand$Total * (1000000000 / 3600000)

#Scotland assumed to be 10%
TransportDemand$Total <- TransportDemand$Total * 0.1

### Combine columns to create Date Column ###
TransportDemand$Date <-
  paste(TransportDemand$YEAR,
        "-",
        match(substr(TransportDemand$MONTH, 1, 3), month.abb),
        "-1",
        sep = "")

TransportDemand$Date <-
  strptime(TransportDemand$Date, format = "%Y-%m-%d")

TransportDemand$Transport <-
  (TransportDemand$Total / days_in_month(TransportDemand$Date)) / 1000000

TransportDemand[1:15] <- NULL

TransportDemand$Date <-
  as.Date(TransportDemand$Date, format = "%Y-%m-%d")

TransportDemand <-
  TransportDemand[complete.cases(TransportDemand), ]


### Electricity

source("Processing Scripts/QtrRenGen.R")
source("Processing Scripts/UKRenGen.R")

#Give GB Data unique names
names(GBRenElecGen) <- paste0("GB", names(GBRenElecGen))

#Rename first column back to quarter, so dataframes can be merged
names(GBRenElecGen)[1] <- "Quarter"

#Merge Scottish and GB data
QTRElecGen <- merge(RenElecGenQTR, GBRenElecGen)

#Ensure there is an all wind column
QTRElecGen$ScotlandWind <- QTRElecGen$`Onshore Wind` + QTRElecGen$`Offshore Wind`
QTRElecGen$GBWind <- QTRElecGen$`GBOnshore Wind` + QTRElecGen$`GBOffshore Wind`

#Calculate Scottish proportion of GB
QTRElecGen$WindProportion <- QTRElecGen$ScotlandWind / QTRElecGen$GBWind
QTRElecGen$SolarProportion <- QTRElecGen$`Solar photovoltaics` / QTRElecGen$`GBSolar photovoltaics`

#Keep only useful columns
QTRElecGen <- select(QTRElecGen, Quarter, WindProportion, SolarProportion)

#Convert Date column
QTRElecGen$SETTLEMENT_DATE <-  as.Date(as.yearqtr(QTRElecGen$Quarter, format="%Y-%m-%d"))


######
ElecDemand <-
  do.call(rbind.fill,
          lapply(
            list.files(path = "Data Sources/Daily Demand/Electricity/", full.names = TRUE, pattern = "\\.csv$"),
            read_csv
          ))

ElecDemand <- ElecDemand %>% arrange(-row_number())
ElecDemandCorrections <- read_csv("Data Sources/Daily Demand/Electricity/Corrections/Corrections.csv")

names(ElecDemandCorrections) <- names(ElecDemand)

ElecDemand <- rbind(ElecDemandCorrections,ElecDemand)



ElecDemand$SETTLEMENT_DATE <-
  lubridate::dmy(ElecDemand$SETTLEMENT_DATE)

ElecDemand$SETTLEMENT_DATE <-
  as.Date(ElecDemand$SETTLEMENT_DATE, format = "%Y-%m-%d")

ElecDemand <- ElecDemand %>% distinct(SETTLEMENT_DATE,SETTLEMENT_PERIOD, .keep_all = TRUE)

ElecDemand$FORECAST_ACTUAL_INDICATOR <- NULL

ElecDemand <- ElecDemand[!duplicated(ElecDemand),]

ElecDemand <- merge(ElecDemand, QTRElecGen, all.x = TRUE)

ElecDemand <- fill(ElecDemand, WindProportion)
ElecDemand <- fill(ElecDemand, SolarProportion)


### Getting 2010 Proportions from Q1 2011 ###

# ElecDemand[ElecDemand == 0] <- NA
# 
# ElecDemand <- fill(ElecDemand, 24:25, .direction = "up")
# 
ElecDemand <- ElecDemand %>% mutate_at(c(2:ncol(ElecDemand)), ~replace(., is.na(.), 0)) 


ElecDemand <- ElecDemand[complete.cases(ElecDemand),]

GBElecDemand <- ElecDemand

ElecDemand$Total <-
  ElecDemand$ND + (ElecDemand$EMBEDDED_WIND_GENERATION * ElecDemand$WindProportion) + (ElecDemand$EMBEDDED_SOLAR_GENERATION * ElecDemand$SolarProportion) - (ElecDemand$ENGLAND_WALES_DEMAND)

ElecDemand <- ElecDemand %>%  select(c("SETTLEMENT_DATE", "SETTLEMENT_PERIOD", "Total"))

ElecDemandHalfHourly <- ElecDemand

ElecDemandHalfHourly$Quarter <- lubridate::quarter(ElecDemandHalfHourly$SETTLEMENT_DATE, with_year = TRUE, fiscal_start = 1)

#fwrite(
#  ElecDemandHalfHourly,
#  "R Data Output/ElecDemandHalfHourly.csv")


ElecDemand <- group_by(ElecDemand, SETTLEMENT_DATE)

ElecDemand <-
  dplyr::summarise(ElecDemand, Electricity = sum(as.numeric(Total)) / 2000)

colnames(ElecDemand) <- c("Date", "Electricity")

ElecDemand <- dplyr::arrange(ElecDemand, Date)

FullDemand <- merge(GasDemand, TransportDemand, all = TRUE)

FullDemand <- merge(FullDemand, ElecDemand)

FullDemand <- fill(FullDemand, Transport)

FullDemand <- FullDemand[complete.cases(FullDemand),]

FullDemand$RollingGas <- rollmean(FullDemand$Gas, 365, align = "right", na.pad = TRUE)
FullDemand$RollingTransport <- rollmean(FullDemand$Transport, 365, align = "right", na.pad = TRUE)
FullDemand$RollingElectricity <- rollmean(FullDemand$Electricity, 365, align = "right", na.pad = TRUE)

write.csv(FullDemand, "Output/Daily Demand/DailyDemand.csv", row.names = FALSE)
