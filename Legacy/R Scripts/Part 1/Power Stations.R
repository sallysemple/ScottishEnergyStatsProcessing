### Load Packages
library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)

print("Power stations")

### Set the Working Directory for the Scripts ###

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

yearstart <- 2006
yearend <- format(Sys.Date(), "%Y")

PowerStations <- read_csv("Data Sources/Power Station/Header.csv")

CategoryLookup <-
  read_csv("Data Sources/Power Station/CategoryLookup.csv")

for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    PowerStationsWorking <-
      read_excel(
        "Data Sources/Power Station/Current.xls",
        sheet = paste("DUKES ", year, sep = ""),
        skip = 3
      )
    
    names(PowerStationsWorking)[3] <- "Fuel"
    names(PowerStationsWorking)[4] <- "Capacity2"
    names(PowerStationsWorking)[6] <- "Location"
    
    PowerStationsWorking$Year <- year
    
    Moyle <- subset(PowerStationsWorking, PowerStationsWorking$`Company Name` == "Scotland - Northern Ireland", select = c("Capacity2", "Year"))
    Moyle$Category <- "Moyle Interconnector"
    #PowerStationsWorking[1:2] <- NULL
    
    #PowerStationsWorking[3] <- NULL
    
    PowerStationsWorking <-
      subset(PowerStationsWorking, Location == "Scotland")
    
    
    PowerStationsWorking <-
      merge(PowerStationsWorking, CategoryLookup, all.x = TRUE)
    
    PowerStationsWorking <-
      merge(PowerStationsWorking, Moyle, all = TRUE)
    
    PowerStationsWorking <-
      group_by(PowerStationsWorking, Year, Category) # Year included allows for column removal.
    
    PowerStationsWorking <-
      dplyr::summarise(PowerStationsWorking, Capacity = sum(as.numeric(Capacity2)))
    
    
    
    PowerStations <-
      merge(PowerStations, PowerStationsWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
}

year <- max(PowerStations$Year, na.rm = TRUE) + 1

PowerStationsWorking <-
  read_excel("Data Sources/Power Station/Current.xls",
             sheet = "5.11",
             skip = 3)

names(PowerStationsWorking)[3] <- "Fuel"
names(PowerStationsWorking)[4] <- "Capacity2"
names(PowerStationsWorking)[6] <- "Location"

PowerStationsWorking$Year <- year

Moyle <- subset(PowerStationsWorking, PowerStationsWorking$`Company Name` == "Scotland - Northern Ireland", select = c("Capacity2", "Year"))
Moyle$Category <- "Moyle Interconnector"

PowerStationsWorking <-
  subset(PowerStationsWorking, Location == "Scotland")


PowerStationsWorking <-
  merge(PowerStationsWorking, CategoryLookup, all.x = TRUE)

PowerStationsWorking <-
  merge(PowerStationsWorking, Moyle, all = TRUE)

PowerStationsWorking <-
  group_by(PowerStationsWorking, Year, Category) # Year included allows for column removal.

PowerStationsWorking <-
  dplyr::summarise(PowerStationsWorking, Capacity = sum(as.numeric(Capacity2)))



PowerStations <-
  merge(PowerStations, PowerStationsWorking, all = TRUE)

PowerStations <- dcast(PowerStations, Year ~ Category, sum)

write.table(
  PowerStations,
  "R Data Output/PowerStations.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
