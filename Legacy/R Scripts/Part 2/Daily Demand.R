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

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("Part 2")
###############################  GAS  ############################################


### Load Source Data ###
GasDemand <-
  do.call(rbind,
          lapply(
            list.files(path = "Daily Demand/Sources/Gas/", full.names = TRUE, pattern = "\\.csv$"),
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
  read_excel("Daily Demand/Sources/Transport/ET_3.13.xls",
             sheet = "Month",
             skip = 6)

### Convert Units ###
TransportDemand$spirit <- TransportDemand$spirit * 47.09
TransportDemand$fuel__1 <- TransportDemand$fuel__1 * 45.64369011
TransportDemand$fuel <- TransportDemand$fuel * 46.19

### Calculate Total ###
TransportDemand$Total <-
  TransportDemand$spirit + TransportDemand$fuel__1

### Convert Units ###
TransportDemand$Total <- TransportDemand$Total * 1000

TransportDemand$Total <-
  TransportDemand$Total * (1000000000 / 3600000)

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

TransportDemand[1:14] <- NULL

TransportDemand$Date <-
  as.Date(TransportDemand$Date, format = "%Y-%m-%d")

TransportDemand <-
  TransportDemand[complete.cases(TransportDemand), ]

#TransportDemand$Date <- lubridate::dmy(TransportDemand$Date)

######

UKQTR <- read_delim(
  "R Data Output/UKGenerationOutput.txt",
  "\t",
  escape_double = FALSE,
  trim_ws = TRUE
)

UKQTR <- t(UKQTR)

UKQTR <- data.frame(r1 = row.names(UKQTR), UKQTR, row.names = NULL)

names(UKQTR) <- lapply(UKQTR[1,], as.character)

UKQTR <- UKQTR[-1, ]

UKQTR[4:14] <- NULL

names(UKQTR) <- c("Time", "Wind1", "Wind2")

UKQTR$Wind1 <- as.character(UKQTR$Wind1)

UKQTR$Wind2 <- as.character(UKQTR$Wind2)

UKQTR$UKWind <- as.numeric(UKQTR$Wind1) + as.numeric(UKQTR$Wind2)

UKQTR[2:3] <- NULL


ScotQTR <- read_delim(
  "R Data Output/GenerationOutput.txt",
  "\t",
  escape_double = FALSE,
  trim_ws = TRUE
)

ScotQTR <- t(ScotQTR)

ScotQTR <-
  data.frame(r1 = row.names(ScotQTR), ScotQTR, row.names = NULL)

names(ScotQTR) <- lapply(ScotQTR[1,], as.character)

ScotQTR <- ScotQTR[-1, ]

ScotQTR[4:14] <- NULL

names(ScotQTR) <- c("Time", "Wind1", "Wind2")

ScotQTR$Wind1 <- as.character(ScotQTR$Wind1)

ScotQTR$Wind2 <- as.character(ScotQTR$Wind2)

ScotQTR$ScotWind <-
  as.numeric(ScotQTR$Wind1) + as.numeric(ScotQTR$Wind2)

ScotQTR[2:3] <- NULL

WindProportion <- merge(UKQTR, ScotQTR)

WindProportion$WindPercentage <-
  WindProportion$ScotWind / WindProportion$UKWind

WindProportion[2:3] <- NULL

WindProportion <-
  transform(WindProportion,
            SETTLEMENT_DATE = (substr(Time, 1, 4)),
            Quarter = (substr(Time, 8, 8)))

WindProportion$Quarter <- as.character(WindProportion$Quarter)


WindProportion$Quarter[WindProportion$Quarter == "1"] <- "-01-01"

WindProportion$Quarter[WindProportion$Quarter == "2"] <- "-04-01"

WindProportion$Quarter[WindProportion$Quarter == "3"] <- "-07-01"

WindProportion$Quarter[WindProportion$Quarter == "4"] <- "-10-01"


WindProportion$SETTLEMENT_DATE <-
  paste(WindProportion$SETTLEMENT_DATE, WindProportion$Quarter, sep = "")

WindProportion$SETTLEMENT_DATE <-
  as.Date(WindProportion$SETTLEMENT_DATE, format = "%Y-%m-%d")

WindProportion$Time <- NULL

WindProportion$Quarter <- NULL

######


######

UKQTR <- read_delim(
  "R Data Output/UKGenerationOutput.txt",
  "\t",
  escape_double = FALSE,
  trim_ws = TRUE
)

UKQTR <- t(UKQTR)

UKQTR <- data.frame(r1 = row.names(UKQTR), UKQTR, row.names = NULL)

names(UKQTR) <- lapply(UKQTR[1,], as.character)

UKQTR <- UKQTR[-1, ]

UKQTR[2:4] <- NULL

UKQTR[3:11] <- NULL

names(UKQTR) <- c("SETTLEMENT_DATE", "UKSolar")

UKQTR$UKSolar <- as.character(UKQTR$UKSolar)

UKQTR$UKSolar <- as.numeric(UKQTR$UKSolar)

ScotQTR <- read_delim(
  "R Data Output/GenerationOutput.txt",
  "\t",
  escape_double = FALSE,
  trim_ws = TRUE
)

ScotQTR <- t(ScotQTR)
ScotQTR <-
  data.frame(r1 = row.names(ScotQTR), ScotQTR, row.names = NULL)

names(ScotQTR) <- lapply(ScotQTR[1,], as.character)

ScotQTR <- ScotQTR[-1, ]

ScotQTR[2:3] <- NULL

ScotQTR[3:8] <- NULL

names(ScotQTR) <- c("SETTLEMENT_DATE", "ScotSolar")

ScotQTR$ScotSolar <- as.character(ScotQTR$ScotSolar)

ScotQTR$ScotSolar <- as.numeric(ScotQTR$ScotSolar)


SolarProportion <- merge(UKQTR, ScotQTR)

SolarProportion$SolarPercentage <-
  SolarProportion$ScotSolar / SolarProportion$UKSolar

SolarProportion[2:3] <- NULL

SolarProportion <-
  transform(SolarProportion,
            SETTLEMENT_DATE = (substr(SETTLEMENT_DATE, 1, 4)),
            Quarter = (substr(SETTLEMENT_DATE, 8, 8)))

SolarProportion$Quarter <- as.character(SolarProportion$Quarter)


SolarProportion$Quarter[SolarProportion$Quarter == "1"] <- "-01-01"

SolarProportion$Quarter[SolarProportion$Quarter == "2"] <- "-04-01"

SolarProportion$Quarter[SolarProportion$Quarter == "3"] <- "-07-01"

SolarProportion$Quarter[SolarProportion$Quarter == "4"] <- "-10-01"

SolarProportion$SETTLEMENT_DATE <-
  paste(SolarProportion$SETTLEMENT_DATE,
        SolarProportion$Quarter,
        sep = "")

SolarProportion$SETTLEMENT_DATE <-
  as.Date(SolarProportion$SETTLEMENT_DATE, format = "%Y-%m-%d")

SolarProportion$Time <- NULL

SolarProportion$Quarter <- NULL

######
ElecDemand <-
  do.call(rbind.fill,
          lapply(
            list.files(path = "Daily Demand/Sources/Electricity/", full.names = TRUE, pattern = "\\.csv$"),
            read_csv
          ))

ElecDemand <- ElecDemand %>% arrange(-row_number())
ElecDemandCorrections <- read_csv("Daily Demand/Sources/Electricity/Corrections/Corrections.csv")

names(ElecDemandCorrections) <- names(ElecDemand)

ElecDemand <- rbind(ElecDemandCorrections,ElecDemand)



ElecDemand$SETTLEMENT_DATE <-
  lubridate::dmy(ElecDemand$SETTLEMENT_DATE)

ElecDemand$SETTLEMENT_DATE <-
  as.Date(ElecDemand$SETTLEMENT_DATE, format = "%Y-%m-%d")

ElecDemand <- ElecDemand %>% distinct(SETTLEMENT_DATE,SETTLEMENT_PERIOD, .keep_all = TRUE)

ElecDemand$FORECAST_ACTUAL_INDICATOR <- NULL

ElecDemand <- ElecDemand[!duplicated(ElecDemand),]

ElecDemand <- merge(ElecDemand, WindProportion, all.x = TRUE)

ElecDemand <- fill(ElecDemand, WindPercentage)

ElecDemand <- merge(ElecDemand, SolarProportion, all.x = TRUE)

ElecDemand <- fill(ElecDemand, SolarPercentage)

### Getting 2010 Proportions from Q1 2011 ###

# ElecDemand[ElecDemand == 0] <- NA
# 
# ElecDemand <- fill(ElecDemand, 24:25, .direction = "up")
# 
ElecDemand <- ElecDemand %>% mutate_at(c(2:ncol(ElecDemand)), ~replace(., is.na(.), 0)) 


ElecDemand <- ElecDemand[complete.cases(ElecDemand),]

GBElecDemand <- ElecDemand

ElecDemand$Total <-
  ElecDemand$ND + (ElecDemand$EMBEDDED_WIND_GENERATION * ElecDemand$WindPercentage) + (ElecDemand$EMBEDDED_SOLAR_GENERATION * ElecDemand$SolarPercentage) - (ElecDemand$ENGLAND_WALES_DEMAND)

ElecDemand <- ElecDemand %>%  select(c("SETTLEMENT_DATE", "SETTLEMENT_PERIOD", "Total"))

ElecDemandHalfHourly <- ElecDemand

ElecDemandHalfHourly$Quarter <- lubridate::quarter(ElecDemandHalfHourly$SETTLEMENT_DATE, with_year = TRUE, fiscal_start = 1)

fwrite(
  ElecDemandHalfHourly,
  "R Data Output/ElecDemandHalfHourly.csv")


ElecDemand <- group_by(ElecDemand, SETTLEMENT_DATE)

ElecDemand <-
  dplyr::summarise(ElecDemand, Electricity = sum(as.numeric(Total)) / 2000)

colnames(ElecDemand) <- c("Date", "Electricity")

ElecDemand <- dplyr::arrange(ElecDemand, Date)

UKQTR <- read_delim(
  "R Data Output/UKGenerationOutput.txt",
  "\t",
  escape_double = FALSE,
  trim_ws = TRUE
)

UKQTR <- t(UKQTR)

UKQTR <- data.frame(r1 = row.names(UKQTR), UKQTR, row.names = NULL)

names(UKQTR) <- lapply(UKQTR[1,], as.character)

UKQTR <- UKQTR[-1, ]

UKQTR[4:14] <- NULL

names(UKQTR) <- c("Time", "Wind1", "Wind2")

UKQTR$Wind1 <- as.character(UKQTR$Wind1)

UKQTR$Wind2 <- as.character(UKQTR$Wind2)

UKQTR$UKWind <- as.numeric(UKQTR$Wind1) + as.numeric(UKQTR$Wind2)

UKQTR[2:3] <- NULL


ScotQTR <- read_delim(
  "R Data Output/GenerationOutput.txt",
  "\t",
  escape_double = FALSE,
  trim_ws = TRUE
)

ScotQTR[ncol(ScotQTR)] <- NULL

ScotQTRExtra <- read_delim(
  "Data Sources/Additional R Files/GenerationOutput2009&2010.txt",
  "\t",
  escape_double = FALSE,
  trim_ws = TRUE
)

ScotQTRExtra[1] <- NULL

ScotQTR <- cbind(ScotQTR, ScotQTRExtra)

ScotQTR <- t(ScotQTR)

ScotQTR <-
  data.frame(r1 = row.names(ScotQTR), ScotQTR, row.names = NULL)

names(ScotQTR) <- lapply(ScotQTR[1,], as.character)

ScotQTR <- ScotQTR[-1, ]

ScotQTR[4:14] <- NULL

names(ScotQTR) <- c("Time", "Wind1", "Wind2")

ScotQTR$Wind1 <- as.character(ScotQTR$Wind1)

ScotQTR$Wind2 <- as.character(ScotQTR$Wind2)

ScotQTR$ScotWind <-
  as.numeric(ScotQTR$Wind1) + as.numeric(ScotQTR$Wind2)

ScotQTR[2:3] <- NULL

WindProportion <- merge(UKQTR, ScotQTR)

WindProportion$WindPercentage <-
  WindProportion$ScotWind / WindProportion$UKWind

WindProportion[2:3] <- NULL

WindProportion <-
  transform(WindProportion,
            Year = (substr(Time, 1, 4)),
            Quarter = (substr(Time, 8, 8)))

WindProportion$Quarter <- as.character(WindProportion$Quarter)


WindProportion$Quarter[WindProportion$Quarter == "1"] <- "-01-01"

WindProportion$Quarter[WindProportion$Quarter == "2"] <- "-04-01"

WindProportion$Quarter[WindProportion$Quarter == "3"] <- "-07-01"

WindProportion$Quarter[WindProportion$Quarter == "4"] <- "-10-01"

WindProportion$Year <-
  paste(WindProportion$Year, WindProportion$Quarter, sep = "")

WindProportion$Year <-
  as.Date(WindProportion$Year, format = "%Y-%m-%d")

WindProportion$Time <- NULL

WindProportion$Quarter <- NULL

FullDemand <- merge(GasDemand, TransportDemand, all = TRUE)

FullDemand <- merge(FullDemand, ElecDemand) # Do we want this?

FullDemand <- fill(FullDemand, Transport)

write.table(
  FullDemand,
  "R Data Output/DailyDemand.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


Midnight <- ymd_hms("01/01/01 00:00:00")
HalfHour <- hms("00:30:00")

ElecDemandHalfHourly$Time <- ((ElecDemandHalfHourly$SETTLEMENT_PERIOD - 1) * HalfHour)+ Midnight

ElecDemandHalfHourly$Time <- substring(ElecDemandHalfHourly$Time, 12, 20)


ElecDemandHalfHourly$Time <- ymd_hms(paste(ElecDemandHalfHourly$SETTLEMENT_DATE ,ElecDemandHalfHourly$Time))

ElecDemandHalfHourly[c(1,2,4)] <- NULL

names(ElecDemandHalfHourly) <- c("DEMAND", "Time")

ElecDemandHalfHourly <- ElecDemandHalfHourly[order(ElecDemandHalfHourly$Time),]

p <- plot_ly(ElecDemandHalfHourly, x = ~Time, y = ~DEMAND, type = 'scatter', mode = 'lines')
p

