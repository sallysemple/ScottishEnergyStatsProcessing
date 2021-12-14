library(readxl)

print("Energy Productivity")

source("Processing Scripts/FinalConsumption.R")

EnergyConsumption <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$`LA Code` == "S92000003"),]

source("Processing Scripts/GVA.R")

EnProductivity <-  merge(EnergyConsumption, GDP)
  
EnProductivity <- select(EnProductivity, Year, `All fuels - Total`, GVA, `GDP at Market Prices`)

#Adjust GVA to Most Recent Prices
EnProductivity$GVA <-  EnProductivity[which(EnProductivity$Year == max(EnProductivity$Year)),]$GVA * ( EnProductivity$`GDP at Market Prices` / EnProductivity[which(EnProductivity$Year == max(EnProductivity$Year)),]$`GDP at Market Prices`)
  
EnProductivity$`Energy Productivity` <- EnProductivity$GVA / EnProductivity$`All fuels - Total`


EnProductivity$`2015 change` <- (EnProductivity$`Energy Productivity` / EnProductivity[which(EnProductivity$Year == 2015),]$`Energy Productivity`) -1

EnProductivity[which(EnProductivity$Year < 2015),]$`2015 change` <- NA


EnProductivity$`2005 change` <- (EnProductivity$`Energy Productivity` / EnProductivity[which(EnProductivity$Year == 2005),]$`Energy Productivity`) -1

write.csv(
  EnProductivity,
  "Output/GVA/EnProductivity.csv",
  row.names = FALSE
)