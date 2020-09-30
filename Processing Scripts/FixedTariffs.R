



### Source file formating changed, being done manually ATM ###



# library(readxl)
# library(plyr)
# library(dplyr)
# library(tidyverse)
# library(data.table)
# 
# print("FixedTariffs")
# 
# ElectricityPaymentMethod <- read_excel("Data Sources/Energy Bills/ElectricityPaymentMethod.xlsx",
#                                        sheet = "Fixed and Online Tariffs",
#                                        skip = 3)[2:10]
# 
# ElectricityPaymentMethod <- ElectricityPaymentMethod[complete.cases(ElectricityPaymentMethod),]
# 
# ElectricityPaymentMethod$Quarter<- as.Date(as.numeric(ElectricityPaymentMethod$Quarter), origin = "1899-12-30")
# 
# ElectricityPaymentMethod[3:6] <- ElectricityPaymentMethod[3:6] / 100
# 
# ElectricityPaymentMethod <- ElectricityPaymentMethod[c(1,2,6)]
# 
# ElectricityPaymentMethod[which(substr(ElectricityPaymentMethod$`PES region`,1,5) == "Great"),]$`PES region` <- "Great Britain"
# 
# ElectricityPaymentMethod <- ElectricityPaymentMethod[which(ElectricityPaymentMethod$`PES region` %in% c("North Scotland", "South Scotland", "Great Britain")),]
# 
# ElectricityPaymentMethod <- dcast(ElectricityPaymentMethod, Quarter ~ `PES region`)
# 
# write.table(ElectricityPaymentMethod,
#             "Output/Energy Bills/FixedTariffElectricity.txt",
#             sep = "\t",
#             row.names = FALSE)
# 
# GasPaymentMethod <- read_excel("Data Sources/Energy Bills/GasPaymentMethod.xlsx",
#                                        sheet = "Fixed Tariffs by Region",
#                                        skip = 2)
# 
# GasPaymentMethod <- GasPaymentMethod[complete.cases(GasPaymentMethod),]
# 
# GasPaymentMethod$Quarter<- as.Date(as.numeric(GasPaymentMethod$Quarter), origin = "1899-12-30")
# 
# GasPaymentMethod[3:6] <- GasPaymentMethod[3:6] / 100
# 
# GasPaymentMethod[which(substr(GasPaymentMethod$`PES region`,1,5) == "Great"),]$`PES region` <- "Great Britain"
# 
# GasPaymentMethod <- GasPaymentMethod[which(GasPaymentMethod$`PES region` %in% c("North Scotland", "South Scotland", "Great Britain")),]
# 
# GasPaymentMethod <- dcast(GasPaymentMethod, Quarter ~ `PES region`)
# 
# write.table(GasPaymentMethod,
#             "Output/Energy Bills/FixedTariffGas.txt",
#             sep = "\t",
#             row.names = FALSE)