library(plyr)
library(dplyr)
library(readr)
library(readxl)
library(tidyverse)
library(reshape2)
library(readr)
library(lubridate)
library(zoo)
library(magrittr)

print("RenElecTarget")

source("Processing Scripts/Renewable Generation.R")
source("Processing Scripts/QtrRenGen.R")
source("Processing Scripts/ProvisionalElecGen.R")


Renewable_Generation <- Renewable_Generation[which(Renewable_Generation$Country == "Scotland"),]

RenElecTgt <- merge(RenElecGen, Renewable_Generation)

RenElecTgt$`Gross Consumption` <- (RenElecTgt$`Total generated` - RenElecTgt$`Electricity transferred to England (net of receipts)` - RenElecTgt$`Electricity transferred to Northern Ireland (net of receipts)` - RenElecTgt$`Electricity transferred to Europe (net of receipts)`)

RenElecTgt$Target <- RenElecTgt$Total / RenElecTgt$`Gross Consumption`


RenElecTgt <- select(RenElecTgt, Year, Total, 'Gross Consumption', Target)

names(RenElecTgt) <- c("Year", "Renewable", "Gross Electricity Consumption", "Target")

ProvisionalElecGen$Target <- ProvisionalElecGen$Renewable / ProvisionalElecGen$`Gross Electricity Consumption`

RenElecTgt <- rbind(RenElecTgt,ProvisionalElecGen)

RenElecTgt <- distinct(RenElecTgt, Year, .keep_all = TRUE)


RenElecTgt<- rbind(
  read_csv("Data Sources/MANUAL/OldRenElecTgt.csv"),
  RenElecTgt
)

write.csv(RenElecTgt, 
          "Output/Renewable Generation/RenElecTgt.csv",
          row.names = FALSE)
