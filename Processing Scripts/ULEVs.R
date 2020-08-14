library(readODS)
library(readxl)
library(readr)
library(dplyr)
library(data.table)

print("ULEVs")

yearstart <- 2015

yearend <- format(Sys.Date(), "%Y")

### Set the Working Directory for the Scripts ###

ULEV <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132a", skip = 6)

colnames(ULEV)[1] <- "CODE"

ULEV <- subset(ULEV, CODE == "S92000003")
for (year in 2011:2014) { 
colnames(ULEV)[colnames(ULEV)==paste(year," Q4", sep = "")] <- paste(year)

ULEV[colnames(ULEV)==paste(year," Q3", sep = "")] <- NULL
ULEV[colnames(ULEV)==paste(year," Q2", sep = "")] <- NULL
ULEV[colnames(ULEV)==paste(year," Q1", sep = "")] <- NULL
}

ULEV$Category <- "Total"

Battery <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132b", skip = 6)

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

Hybrid <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132c", skip = 6)

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


AllVehicles <- read_excel("Data Sources/Vehicles/Header.xlsx")

for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    AllWorking <-
      read_ods(
        "Data Sources/Vehicles/veh0104.ods",
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
        "Data Sources/Vehicles/veh0104.ods",
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
        "Data Sources/Vehicles/veh0104.ods",
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
        "Data Sources/Vehicles/veh0104.ods",
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
        "Data Sources/Vehicles/veh0104.ods",
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
        "Data Sources/Vehicles/veh0104.ods",
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
        "Data Sources/Vehicles/veh0104.ods",
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
        "Data Sources/Vehicles/veh0104.ods",
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

ULEV <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132a", skip = 6)

colnames(ULEV)[1] <- "CODE"

ULEV <- subset(ULEV, substr(CODE,1,2) == "S1" | substr(CODE,1,2) == "S9")
for (year in 2011:2014) { 
  colnames(ULEV)[colnames(ULEV)==paste(year," Q4", sep = "")] <- paste(year)
  
  ULEV[colnames(ULEV)==paste(year," Q3", sep = "")] <- NULL
  ULEV[colnames(ULEV)==paste(year," Q2", sep = "")] <- NULL
  ULEV[colnames(ULEV)==paste(year," Q1", sep = "")] <- NULL
}

ULEV$Category <- "Total"

Battery <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132b", skip = 6)

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

Hybrid <- read_ods("Data Sources/Vehicles/veh0132.ods", sheet = "VEH0132c", skip = 6)

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
