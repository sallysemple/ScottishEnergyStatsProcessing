### Load Packages ###
library(readr)
library(readxl)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(lubridate)

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

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
ScotlandGasDemand <-
  subset(GasDemand, Item != "NTS Energy Offtaken, Moffat, Interconnector", select = c("Date", "Value", "Item")) # Keeps all values that are NOT EQUAL to  ""NTS Energy Offtaken, Moffat, Interconnector"





ScotlandGasDemand$Date <- lubridate::dmy(ScotlandGasDemand$Date)

ScotlandGasDemand <- ScotlandGasDemand[!duplicated(ScotlandGasDemand),]
### Group together rows by date ###
ScotlandGasDemand <- group_by(ScotlandGasDemand, Date)

### Combine together rows for a per day total ###
ScotlandGasDemand <-
  dplyr::summarise(ScotlandGasDemand, Gas = sum(as.numeric(Value)) / 1000000)

### Arrange by Date ###
ScotlandGasDemand <- dplyr::arrange(ScotlandGasDemand, Date)

### Convert Dates to be Excel friendly ###
ScotlandGasDemand$Date <- as.Date(ScotlandGasDemand$Date, format = "%Y-%m-%d")

names(ScotlandGasDemand) <- c("Date", "ScotDemand")

MoffatGas <-
  subset(GasDemand, Item == "NTS Energy Offtaken, Moffat, Interconnector", select = c("Date", "Value", "Item"))

MoffatGas$Date <- lubridate::dmy(MoffatGas$Date)

MoffatGas <- MoffatGas[!duplicated(MoffatGas),]
### Group together rows by date ###
MoffatGas <- group_by(MoffatGas, Date)

### Combine together rows for a per day total ###
MoffatGas <-
  dplyr::summarise(MoffatGas, Gas = sum(as.numeric(Value)) / 1000000)

### Arrange by Date ###
MoffatGas <- dplyr::arrange(MoffatGas, Date)

### Convert Dates to be Excel friendly ###
MoffatGas$Date <- as.Date(MoffatGas$Date, format = "%Y-%m-%d")

names(MoffatGas) <- c("Date", "NITransfer")




### Load Source Data ###
GasSupplies <-
  do.call(rbind,
          lapply(
            list.files(path = "Daily Demand/Sources/Gas Supplies/", full.names = TRUE, pattern = "\\.csv$"),
            read_csv
          )) # Open multiple source files and combine together.

GasSuppliesCorrections <- read_csv("Daily Demand/Sources/Gas Supplies/Corrections/Corrections.csv")

GasSupplies <- rbind(GasSuppliesCorrections,GasSupplies)

GasSupplies <- GasSupplies %>% distinct(GasSupplies$`Applicable For`,GasSupplies$`Data Item`, .keep_all = TRUE)

### Rename Columns ###
names(GasSupplies) <-
  c("NotDate", "Date", "Item", "Value", "Time", "Category") 

### Subset Data ###
Fergus <-
  subset(GasSupplies, Item != "NTS System Input Physical, Actual (Energy), D+1", select = c("Date", "Value", "Item")) # Keeps all values that are NOT EQUAL to  ""NTS Energy Offtaken, Moffat, Interconnector"

Fergus$Date <- lubridate::dmy(Fergus$Date)

Fergus <- Fergus[!duplicated(Fergus),]
### Group together rows by date ###
Fergus <- group_by(Fergus, Date)

### Combine together rows for a per day total ###
Fergus <-
  dplyr::summarise(Fergus, Gas = sum(as.numeric(Value)) / 1000000)

### Arrange by Date ###
Fergus <- dplyr::arrange(Fergus, Date)

### Convert Dates to be Excel friendly ###
Fergus$Date <- as.Date(Fergus$Date, format = "%Y-%m-%d")

names(Fergus) <- c("Date", "Fergus")



### Subset Data ###
GBTotal <-
  subset(GasSupplies, Item == "NTS System Input Physical, Actual (Energy), D+1", select = c("Date", "Value", "Item")) # Keeps all values that are NOT EQUAL to  ""NTS Energy Offtaken, Moffat, Interconnector"

GBTotal$Date <- lubridate::dmy(GBTotal$Date)

GBTotal <- GBTotal[!duplicated(GBTotal),]
### Group together rows by date ###
GBTotal <- group_by(GBTotal, Date)

### Combine together rows for a per day total ###
GBTotal <-
  dplyr::summarise(GBTotal, Gas = sum(as.numeric(Value)) / 1000000)

### Arrange by Date ###
GBTotal <- dplyr::arrange(GBTotal, Date)

### Convert Dates to be Excel friendly ###
GBTotal$Date <- as.Date(GBTotal$Date, format = "%Y-%m-%d")

names(GBTotal) <- c("Date", "GBTotal")

GasDistribution <- merge(ScotlandGasDemand, MoffatGas)
GasDistribution <- merge(GasDistribution, Fergus)
GasDistribution <- merge(GasDistribution, GBTotal)

GasDistribution$EnglandTransfer <- GasDistribution$Fergus - GasDistribution$ScotDemand - GasDistribution$NITransfer 


### Export to CSV ###
write.table(
  GasDistribution,
  "R Data Output/GasDistribution.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
