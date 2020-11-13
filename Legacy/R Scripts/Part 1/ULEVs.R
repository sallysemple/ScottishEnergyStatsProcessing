library(readODS)
library(readxl)
library(dplyr)

print("ULEVs")

yearstart <- 2015

yearend <- format(Sys.Date(), "%Y")

### Set the Working Directory for the Scripts ###

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

ULEV <- read_ods("Data Sources/Vehicles/CurrentULEV.ods", skip = 6)

colnames(ULEV)[1] <- "CODE"

ULEV <- subset(ULEV, CODE == "S92000003")
for (year in 2011:2014) { 
colnames(ULEV)[colnames(ULEV)==paste(year," Q4", sep = "")] <- paste(year)

ULEV[colnames(ULEV)==paste(year," Q3", sep = "")] <- NULL
ULEV[colnames(ULEV)==paste(year," Q2", sep = "")] <- NULL
ULEV[colnames(ULEV)==paste(year," Q1", sep = "")] <- NULL
}

write.table(
  ULEV,
  "R Data Output/ULEV.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

Battery <- read_excel("Data Sources/Vehicles/CurrentBattery.xlsx", skip = 6)

colnames(Battery)[1] <- "CODE"

Battery <- subset(Battery, CODE == "S92000003")
for (year in 2011:2014) { 
  colnames(Battery)[colnames(Battery)==paste(year," Q4", sep = "")] <- paste(year)
  
  Battery[colnames(Battery)==paste(year," Q3", sep = "")] <- NULL
  Battery[colnames(Battery)==paste(year," Q2", sep = "")] <- NULL
  Battery[colnames(Battery)==paste(year," Q1", sep = "")] <- NULL
}

write.table(
  Battery,
  "R Data Output/Battery.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


AllVehicles <- read_excel("Data Sources/Vehicles/Header.xlsx")

for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    AllWorking <-
      read_ods(
        "Data Sources/Vehicles/CurrentAll.ods",
        sheet = paste(year, "_Q1", sep = ""),
        skip = 7
      )
    AllWorking$Time <- paste(year, " Q1", sep = "")
    
    AllWorking <- head(AllWorking, n = 21)
    
    names(AllWorking) <- names(AllVehicles)
    
    AllWorking <- subset(AllWorking, Region == "Scotland")
    
    AllVehicles <- merge(AllVehicles, AllWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  tryCatch({
    AllWorking <-
      read_ods(
        "Data Sources/Vehicles/CurrentAll.ods",
        sheet = paste(year, "_Q2", sep = ""),
        skip = 7
      )
    AllWorking$Time <- paste(year, " Q2", sep = "")
    
    AllWorking <- head(AllWorking, n = 21)
    
    names(AllWorking) <- names(AllVehicles)
    
    AllWorking <- subset(AllWorking, Region == "Scotland")
    
    AllVehicles <- merge(AllVehicles, AllWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  tryCatch({
    AllWorking <-
      read_ods(
        "Data Sources/Vehicles/CurrentAll.ods",
        sheet = paste(year, "_Q3", sep = ""),
        skip = 7
      )
    AllWorking$Time <- paste(year, " Q3", sep = "")
    
    AllWorking <- head(AllWorking, n = 21)
    
    names(AllWorking) <- names(AllVehicles)
    
    AllWorking <- subset(AllWorking, Region == "Scotland")
    
    AllVehicles <- merge(AllVehicles, AllWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  tryCatch({
    AllWorking <-
      read_ods(
        "Data Sources/Vehicles/CurrentAll.ods",
        sheet = paste(year, "_Q4", sep = ""),
        skip = 7
      )
    AllWorking$Time <- paste(year, " Q4", sep = "")
    
    AllWorking <- head(AllWorking, n = 21)
    
    names(AllWorking) <- names(AllVehicles)
    
    AllWorking <- subset(AllWorking, Region == "Scotland")
    
    AllVehicles <- merge(AllVehicles, AllWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  tryCatch({
    AllWorking <-
      read_ods(
        "Data Sources/Vehicles/CurrentAll.ods",
        sheet = paste(year, "_Q1_(r)", sep = ""),
        skip = 7
      )
    AllWorking$Time <- paste(year, " Q1", sep = "")
    
    AllWorking <- head(AllWorking, n = 21)
    
    names(AllWorking) <- names(AllVehicles)
    
    AllWorking <- subset(AllWorking, Region == "Scotland")
    
    AllVehicles <- merge(AllVehicles, AllWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  tryCatch({
    AllWorking <-
      read_ods(
        "Data Sources/Vehicles/CurrentAll.ods",
        sheet = paste(year, "_Q2_(r)", sep = ""),
        skip = 7
      )
    AllWorking$Time <- paste(year, " Q2", sep = "")
    
    AllWorking <- head(AllWorking, n = 21)
    
    names(AllWorking) <- names(AllVehicles)
    
    AllWorking <- subset(AllWorking, Region == "Scotland")
    
    AllVehicles <- merge(AllVehicles, AllWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  tryCatch({
    AllWorking <-
      read_ods(
        "Data Sources/Vehicles/CurrentAll.ods",
        sheet = paste(year, "_Q3_(r)", sep = ""),
        skip = 7
      )
    AllWorking$Time <- paste(year, " Q3", sep = "")
    
    AllWorking <- head(AllWorking, n = 21)
    
    names(AllWorking) <- names(AllVehicles)
    
    AllWorking <- subset(AllWorking, Region == "Scotland")
    
    AllVehicles <- merge(AllVehicles, AllWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  tryCatch({
    AllWorking <-
      read_ods(
        "Data Sources/Vehicles/CurrentAll.ods",
        sheet = paste(year, "_Q4_(r)", sep = ""),
        skip = 7
      )
    AllWorking$Time <- paste(year, " Q4", sep = "")
    
    AllWorking <- head(AllWorking, n = 21)
    
    names(AllWorking) <- names(AllVehicles)
    
    AllWorking <- subset(AllWorking, Region == "Scotland")
    
    AllVehicles <- merge(AllVehicles, AllWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
}

AllVehicles <- select(AllVehicles, Time, everything())

AllVehicles <- arrange(AllVehicles, Time)

write.table(
  AllVehicles,
  "R Data Output/AllVehicles.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

AllVehiclesRegister <- read_excel("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/Data Sources/Vehicles/CurrentAllRegister.xlsx", 
                                     skip = 8)

AllVehiclesRegister <- subset(AllVehiclesRegister, substr(AllVehiclesRegister$Date,5,6) == " Q" )

write.table(
  AllVehiclesRegister,
  "R Data Output/AllVehiclesRegister.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


ULEVRegister <- read_excel("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/Data Sources/Vehicles/CurrentULEVRegister.xlsx", 
                                      skip = 6)

ULEVRegister <- subset(ULEVRegister, substr(ULEVRegister$Date,5,6) == " Q" )

write.table(
  ULEVRegister,
  "R Data Output/ULEVRegisterRegister.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
