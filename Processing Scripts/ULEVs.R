library(readODS)
library(readxl)
library(readr)
library(dplyr)
library(data.table)

print("ULEVs")

yearstart <- 2015

yearend <- format(Sys.Date(), "%Y")

### Set the Working Directory for the Scripts ###

ULEV <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132a_All", skip = 6)

colnames(ULEV)[1] <- "CODE"

ULEV <- subset(ULEV, CODE == "S92000003")
for (year in 2011:2014) { 
colnames(ULEV)[colnames(ULEV)==paste(year," Q4", sep = "")] <- paste(year)

ULEV[colnames(ULEV)==paste(year," Q3", sep = "")] <- NULL
ULEV[colnames(ULEV)==paste(year," Q2", sep = "")] <- NULL
ULEV[colnames(ULEV)==paste(year," Q1", sep = "")] <- NULL
}

ULEV$Category <- "Total"

Battery <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132b_BEV", skip = 6)

colnames(Battery)[1] <- "CODE"

Battery <- subset(Battery, CODE == "S92000003")
for (year in 2011:2014) { 
  colnames(Battery)[colnames(Battery)==paste(year," Q4", sep = "")] <- paste(year)
  
  Battery[colnames(Battery)==paste(year," Q3", sep = "")] <- NULL
  Battery[colnames(Battery)==paste(year," Q2", sep = "")] <- NULL
  Battery[colnames(Battery)==paste(year," Q1", sep = "")] <- NULL
}

Battery$Category <- "Battery"

ULEV <- rbind(ULEV, Battery)

Hybrid <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132c_PHEV", skip = 6)

colnames(Hybrid)[1] <- "CODE"

Hybrid <- subset(Hybrid, CODE == "S92000003")
for (year in 2011:2014) { 
  colnames(Hybrid)[colnames(Hybrid)==paste(year," Q4", sep = "")] <- paste(year)
  
  Hybrid[colnames(Hybrid)==paste(year," Q3", sep = "")] <- NULL
  Hybrid[colnames(Hybrid)==paste(year," Q2", sep = "")] <- NULL
  Hybrid[colnames(Hybrid)==paste(year," Q1", sep = "")] <- NULL
}

Hybrid$Category <- "Hybrid"

ULEV <- rbind(ULEV, Hybrid)

ULEV[1:2] <- NULL

ULEV <- ULEV[ncol(ULEV):1]

ULEV <- melt(ULEV, id.vars = "Category")

ULEV <- dcast(ULEV, variable ~ Category)

names(ULEV)[1] <- "Quarter"

ULEV$Battery <- as.numeric(ULEV$Battery)
ULEV$Hybrid <- as.numeric(ULEV$Hybrid)
ULEV$Total <- as.numeric(ULEV$Total)

ULEV$Other <- ULEV$Total - ULEV$Battery -ULEV$Hybrid

ULEV <- rbind(read_delim("Data Sources/Vehicles/ULEV2014.txt", 
                         "\t", escape_double = FALSE, trim_ws = TRUE),ULEV)

write.table(
  ULEV,
  "Output/Vehicles/ULEV.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)



AllVehicles <- read_ods("Data Sources/Vehicles/veh0104.ods", sheet = "VEH0104a_All", skip = 6)[c(1,13)]
AllVehicles <- AllVehicles[complete.cases(AllVehicles),]
names(AllVehicles)<- c("Time", "Total")



AllVehicles_Cars <- read_ods("Data Sources/Vehicles/veh0104.ods", sheet = "VEH0104b_Cars", skip = 6)[c(1,13)]
AllVehicles_Cars <- AllVehicles_Cars[complete.cases(AllVehicles_Cars),]
AllVehicles$Cars <- AllVehicles_Cars$Scotland



AllVehicles_MotorCycles <- read_ods("Data Sources/Vehicles/veh0104.ods", sheet = "VEH0104c_Motorcycles", skip = 6)[c(1,13)]
AllVehicles_MotorCycles <- AllVehicles_MotorCycles[complete.cases(AllVehicles_MotorCycles),]
AllVehicles$`Motor cycles` <- AllVehicles_MotorCycles$Scotland



AllVehicles_LightGoods <- read_ods("Data Sources/Vehicles/veh0104.ods", sheet = "VEH0104d_LGVs", skip = 6)[c(1,13)]
AllVehicles_LightGoods <- AllVehicles_LightGoods[complete.cases(AllVehicles_LightGoods),]
AllVehicles$`Light goods` <- AllVehicles_LightGoods$Scotland



AllVehicles_HeavyGoods <- read_ods("Data Sources/Vehicles/veh0104.ods", sheet = "VEH0104e_HGVs", skip = 6)[c(1,13)]
AllVehicles_HeavyGoods <- AllVehicles_HeavyGoods[complete.cases(AllVehicles_HeavyGoods),]
AllVehicles$`Heavy goods` <- AllVehicles_HeavyGoods$Scotland



AllVehicles_BusesCoaches <- read_ods("Data Sources/Vehicles/veh0104.ods", sheet = "VEH0104f_Buses_&_coaches", skip = 6)[c(1,13)]
AllVehicles_BusesCoaches <- AllVehicles_BusesCoaches[complete.cases(AllVehicles_BusesCoaches),]
AllVehicles$`Buses and coaches` <- AllVehicles_BusesCoaches$Scotland



AllVehicles_OtherVehicles <- read_ods("Data Sources/Vehicles/veh0104.ods", sheet = "VEH0104g_Other_vehicles", skip = 6)[c(1,13)]
AllVehicles_OtherVehicles <- AllVehicles_OtherVehicles[complete.cases(AllVehicles_OtherVehicles),]
AllVehicles$`Other vehicles` <- AllVehicles_OtherVehicles$Scotland


AllVehicles$Region <- "Scotland"
AllVehicles <- AllVehicles[c(1,9,3:8,2)]



AllVehicles <- select(AllVehicles, Time, everything())

AllVehicles <- arrange(AllVehicles, Time)

write.table(
  AllVehicles,
  "Output/Vehicles/AllVehicles.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

AllVehiclesRegister <- read_excel("Data Sources/Vehicles/CurrentAllRegister.xlsx",
                                     skip = 8)

AllVehiclesRegister <- subset(AllVehiclesRegister, substr(AllVehiclesRegister$Date,5,6) == " Q" )

write.table(
  AllVehiclesRegister,
  "Output/Vehicles/AllVehiclesRegister.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


ULEVRegister <- read_excel("Data Sources/Vehicles/CurrentULEVRegister.xlsx",
                                      skip = 6)

ULEVRegister <- subset(ULEVRegister, substr(ULEVRegister$Date,5,6) == " Q" )

write.table(
  ULEVRegister,
  "Output/Vehicles/ULEVRegister.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


library(readODS)
library(readxl)
library(readr)
library(dplyr)
library(data.table)
library(lubridate)
library(zoo)

print("ULEVs")

yearstart <- 2015

yearend <- format(Sys.Date(), "%Y")

### Set the Working Directory for the Scripts ###

ULEV <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132a_All", skip = 6)

colnames(ULEV)[1] <- "CODE"

ULEV <- subset(ULEV, substr(CODE,1,2) == "S1" | substr(CODE,1,2) == "S9")
for (year in 2011:2014) { 
  colnames(ULEV)[colnames(ULEV)==paste(year," Q4", sep = "")] <- paste(year)
  
  ULEV[colnames(ULEV)==paste(year," Q3", sep = "")] <- NULL
  ULEV[colnames(ULEV)==paste(year," Q2", sep = "")] <- NULL
  ULEV[colnames(ULEV)==paste(year," Q1", sep = "")] <- NULL
}

ULEV$Category <- "Total"

Battery <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132b_BEV", skip = 6)

colnames(Battery)[1] <- "CODE"

Battery <- subset(Battery, substr(CODE,1,2) == "S1" | substr(CODE,1,2) == "S9")
for (year in 2011:2014) { 
  colnames(Battery)[colnames(Battery)==paste(year," Q4", sep = "")] <- paste(year)
  
  Battery[colnames(Battery)==paste(year," Q3", sep = "")] <- NULL
  Battery[colnames(Battery)==paste(year," Q2", sep = "")] <- NULL
  Battery[colnames(Battery)==paste(year," Q1", sep = "")] <- NULL
}

Battery$Category <- "Battery"

ULEV <- rbind(ULEV, Battery)

Hybrid <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132c_PHEV", skip = 6)

colnames(Hybrid)[1] <- "CODE"

Hybrid <- subset(Hybrid, substr(CODE,1,2) == "S1" | substr(CODE,1,2) == "S9")
for (year in 2011:2014) { 
  colnames(Hybrid)[colnames(Hybrid)==paste(year," Q4", sep = "")] <- paste(year)
  
  Hybrid[colnames(Hybrid)==paste(year," Q3", sep = "")] <- NULL
  Hybrid[colnames(Hybrid)==paste(year," Q2", sep = "")] <- NULL
  Hybrid[colnames(Hybrid)==paste(year," Q1", sep = "")] <- NULL
}

Hybrid$Category <- "Hybrid"

ULEV <- rbind(ULEV, Hybrid)

ULEV[2] <- NULL

ULEV <- melt(ULEV, id.vars = c("Category", "CODE"))

names(ULEV) <- c("Category", "LACode", "Quarter", "Value")

ULEV$Value <- as.numeric(ULEV$Value)

source("Processing Scripts/LACodeFunction.R")

ULEV <- LACodeUpdate(ULEV)

LANameLookup <- read_excel("LALookup.xlsx", sheet = "Code to LA")

names(LANameLookup) <- c("LACode", "LAName")

ULEV <- merge(ULEV, LANameLookup)

ULEV <- dcast(ULEV, Quarter + LAName + LACode ~ Category, value.var = "Value")

ULEV$Other <- ULEV$Total - ULEV$Hybrid - ULEV$Battery

ULEV <- ULEV[c(1:5,7,6)]

names(ULEV)[4:7] <- c("Battery Electric Vehicles", "Plug-in Hybrids", "Other ULEVs", "Total ULEVs")

ULEV <- melt(ULEV)

ULEV <- ULEV[which(substr(ULEV$Quarter,6,6) == "Q"),]

ULEV$Quarter <- as.yearqtr(ULEV$Quarter)

write.table(
  ULEV,
  "Output/Vehicles/ULEVbyLA.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
