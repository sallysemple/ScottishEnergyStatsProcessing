library(readxl)
library(readr)
library(plyr)
library(dplyr)
library(data.table)
library(tidyverse)

MultiplierList <- list()

for(Year in 2010:2019){
  
UKEnergyBalance <- read_excel("Energy Balance/Sources/DUKES_1.1-1.3.xls", 
                            sheet = paste(Year), skip = 2)


names(UKEnergyBalance) <- c("Variable", "Coal", "Manufactured fuel", "Primary oils", "Petroleum products", "Natural gas", "Bioenergy & waste", "Primary electricity", "Electricity", "Heat sold", "Total")

UKEnergyBalance$Variable<- gsub("\\s*\\([^\\)]+\\)","",as.character(UKEnergyBalance$Variable))

UKEnergyBalance$Variable

UKEnergyBalance <- melt(UKEnergyBalance)

UKEnergyBalance[complete.cases(UKEnergyBalance),]

names(UKEnergyBalance) <- c("Variable", "Fuel", "Value")

Multipliers <- data.frame(Year = Year)



Multipliers$CoalStockChange <- sum(UKEnergyBalance[which(UKEnergyBalance$Variable == "Electricity generation" & UKEnergyBalance$Fuel == "Coal"),]$Value)*UKEnergyBalance[which(UKEnergyBalance$Variable == "Stock change" & UKEnergyBalance$Fuel == "Coal"),]$Value


Multipliers$CoalManFuel <- (
  UKEnergyBalance[which(UKEnergyBalance$Variable == "Heat generation" & UKEnergyBalance$Fuel == "Coal"),]$Value[1] +
  UKEnergyBalance[which(UKEnergyBalance$Variable == "Coke manufacture" & UKEnergyBalance$Fuel == "Coal"),]$Value[1] +
  UKEnergyBalance[which(UKEnergyBalance$Variable == "Blast furnaces" & UKEnergyBalance$Fuel == "Coal"),]$Value[1] +
  UKEnergyBalance[which(UKEnergyBalance$Variable == "Patent fuel manufacture" & UKEnergyBalance$Fuel == "Coal"),]$Value[1]
  ) / UKEnergyBalance[which(UKEnergyBalance$Variable == "Electricity generation" & UKEnergyBalance$Fuel == "Coal"),]$Value[1]


Multipliers$CoalIndustry <- {
        UKEnergyBalance[which(UKEnergyBalance$Variable == "Industry" & UKEnergyBalance$Fuel == "Coal"),]$Value[1] /
              (
              UKEnergyBalance[which(UKEnergyBalance$Variable == "Industry" & UKEnergyBalance$Fuel == "Coal"),]$Value[1] +
              UKEnergyBalance[which(UKEnergyBalance$Variable == "Public administration" & UKEnergyBalance$Fuel == "Coal"),]$Value[1] +
              UKEnergyBalance[which(UKEnergyBalance$Variable == "Commercial" & UKEnergyBalance$Fuel == "Coal"),]$Value[1] +
              UKEnergyBalance[which(UKEnergyBalance$Variable == "Agriculture" & UKEnergyBalance$Fuel == "Coal"),]$Value[1] +
              UKEnergyBalance[which(UKEnergyBalance$Variable == "Miscellaneous" & UKEnergyBalance$Fuel == "Coal"),]$Value[1]
              )     
}

MultiplierList[[Year]] <- Multipliers

}

rbindlist(MultiplierList)


###### Coal ######

Coal_Imports_Exports <- read_csv("Energy Balance/Sources/Coal Imports Exports.csv")

Coal_Imports_Exports$`Flow Type` <- substr(Coal_Imports_Exports$`Flow Type`, str_length(Coal_Imports_Exports$`Flow Type`)-6, str_length(Coal_Imports_Exports$`Flow Type`))

Coal_Imports_Exports <- Coal_Imports_Exports %>% group_by(`Flow Type`, Year) %>% summarise(`Net Mass (Kg)` = sum(`Net Mass (Kg)`))

Coal_Imports_Exports <- dcast(Coal_Imports_Exports, Year ~ `Flow Type`)

##################



