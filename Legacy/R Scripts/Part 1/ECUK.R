library(readr)
library(readxl)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(lubridate)
library(writexl)
library(data.table)
library(tidyverse)
### Set the Working Directory for the Scripts ###

print("ECUK")

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

CurrentYears <- read_excel("Data Sources/ECUK/Current.xlsx", 
                           sheet = "Table U2", skip = 4)

CurrentYears$Year <- 0

CurrentYears[which(is.na(CurrentYears$`End use`)),]$Year <- CurrentYears[which(is.na(CurrentYears$`End use`)),]$Gas

CurrentYears$Year[CurrentYears$Year == 0] <- NA

CurrentYears$Sector[CurrentYears$Sector == "Services (excl agriculture)"] <- "Service"

CurrentYears$Sector[CurrentYears$Sector == "Industry3"] <- "Industry"

CurrentYears <- fill(CurrentYears, 1, 10)[c(10,1,2,3:9)]

CurrentYears <- CurrentYears[complete.cases(CurrentYears),]

names(CurrentYears) <- c("Year", "Sector", "End Use", "Gas", "Oil", "Solid Fuel", "Electricity","Heat sold", "Bioenergy & Waste", "Total")

CurrentYears <- melt(CurrentYears, id = c("Year", "Sector", "End Use"))

names(CurrentYears)[4:5] <- c("Fuel", "Value")

CurrentYears$Lookup <- paste0(CurrentYears$Year,CurrentYears$Sector, CurrentYears$`End Use`, CurrentYears$Fuel)

CurrentYears <- CurrentYears[c(6,1:5)]


PreviousYears <- read_excel("Data Sources/ECUK/PreviousYears.xlsx", skip = 2)

PreviousYears$Year <- 0

PreviousYears[which(is.na(PreviousYears$`End use`)),]$Year <- PreviousYears[which(is.na(PreviousYears$`End use`)),]$Gas

PreviousYears$Year[PreviousYears$Year == 0] <- NA

PreviousYears$Sector[PreviousYears$Sector == "Service2"] <- "Service"

PreviousYears$Sector[PreviousYears$Sector == "Industry3"] <- "Industry"

PreviousYears <- fill(PreviousYears, 1, 10)[c(10,1,2,3:9)]

PreviousYears <- PreviousYears[complete.cases(PreviousYears),]

names(PreviousYears) <- c("Year", "Sector", "End Use", "Gas", "Oil", "Solid Fuel", "Electricity","Heat sold", "Bioenergy & Waste", "Total")

PreviousYears <- melt(PreviousYears, id = c("Year", "Sector", "End Use"))

names(PreviousYears)[4:5] <- c("Fuel", "Value")

PreviousYears$Lookup <- paste0(PreviousYears$Year,PreviousYears$Sector, PreviousYears$`End Use`, PreviousYears$Fuel)

PreviousYears <- PreviousYears[c(6,1:5)]

PreviousYears <- PreviousYears[which(PreviousYears$Year < min(CurrentYears$Year)),]

ECUK <- rbind(CurrentYears, PreviousYears)

table(ECUK$Year)

unique(ECUK$`End Use`)

write.table(
  ECUK,
  "R Data Output/ECUK.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
