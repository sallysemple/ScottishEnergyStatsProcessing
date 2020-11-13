library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(data.table)
library(lubridate)
library(zoo)

print("RHI")
### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")
Combined <- list()


DataSources <- list.files("Data Sources/RHI/Format 1", full.names = TRUE, pattern = "\\.xlsx$")

for (i in 1:length(DataSources)){
Data <- read_excel(DataSources[i], 
                       sheet = "2.3")
Data <- Filter(function(x)!all(is.na(x)), Data)
Data <- subset(Data, Data[2]== "Scotland")
Data <- Data[,c(1,2,3,5,7,9,11,13,15,17,19,21)]
names(Data) <- c("CODE", "Country", "Air source heat pump Applications", "Air source heat pump Accredited", "Ground source heat pump Applications", "Ground source heat pump Accredited", "Biomass Applications", "Biomass Accredited", "Solar Applications", "Solar Accredited", "Total Applications", "Total Accredited")
Data$Date <- substr(DataSources[i], 27, 34)


Combined[[length(Combined)+1]] <- Data
}

DataSources <- list.files("Data Sources/RHI/Format 2", full.names = TRUE, pattern = "\\.xlsx$")

for (i in 1:length(DataSources)){
  Data <- read_excel(DataSources[i], 
                     sheet = "Table 2.3")
  Data <- Filter(function(x)!all(is.na(x)), Data)
  Data <- subset(Data, Data[2]== "Scotland")
  Data <- Data[,c(1,2,3,5,7,9,11,13,15,17,19,21)]
  names(Data) <- c("CODE", "Country", "Air source heat pump Applications", "Air source heat pump Accredited", "Ground source heat pump Applications", "Ground source heat pump Accredited", "Biomass Applications", "Biomass Accredited", "Solar Applications", "Solar Accredited", "Total Applications", "Total Accredited")
  Data$Date <- substr(DataSources[i], 27, 34)
  
  
  Combined[[length(Combined)+1]] <- Data
}

DataSources <- list.files("Data Sources/RHI/Format 3", full.names = TRUE, pattern = "\\.xlsx$")

for (i in 1:length(DataSources)){
  Data <- read_excel(DataSources[i], 
                     sheet = "Table 2.3")
  Data <- Filter(function(x)!all(is.na(x)), Data)
  Data <- subset(Data, Data[1]== "Scotland")
  Data <- Data[,c(1,2,4,6,8,10,12,14,16,18,20)]
  names(Data) <- c("Country", "Air source heat pump Applications", "Air source heat pump Accredited", "Ground source heat pump Applications", "Ground source heat pump Accredited", "Biomass Applications", "Biomass Accredited", "Solar Applications", "Solar Accredited", "Total Applications", "Total Accredited")
  Data$Date <- substr(DataSources[i], 27, 34)
  Data$CODE <- "S92000003"
  Data <- Data[,c(13,1:11,12)]
  
  Combined[[length(Combined)+1]] <- Data
}

  Combined <- rbindlist(Combined)
  
  Combined$Date <- as.yearmon(Combined$Date)

  Combined <- Combined[,c(13,1:12)]  
  
  Combined <- Combined[order(Combined$Date)]
  
  
  ### Export to CSV ###
  write.table(
    Combined,
    "R Data Output/RHIDom.txt",
    sep = "\t",
    na = "0",
    row.names = FALSE
  )  
  
  
  Combined <- list()
  
  DataSources <- list.files("Data Sources/RHI/Format 1", full.names = TRUE, pattern = "\\.xlsx$")
  
  for (i in 1:length(DataSources)){
    Data <- read_excel(DataSources[i], 
                       sheet = "1.3")
    Data <- Filter(function(x)!all(is.na(x)), Data)
    Data <- subset(Data, Data[2]== "Scotland")
    Data <- Data[,c(1,2,3,5,7,9)]
    names(Data) <- c("CODE", "Country", "Full applications", "Accredited full applications", "Capacity of full applications", "Capacity of accredited full applications")
    Data$Date <- substr(DataSources[i], 27, 34)
    
    
    Combined[[length(Combined)+1]] <- Data
  }
  
  DataSources <- list.files("Data Sources/RHI/Format 2", full.names = TRUE, pattern = "\\.xlsx$")
  
  for (i in 1:length(DataSources)){
    Data <- read_excel(DataSources[i], 
                       sheet = "Table 1.3")
    Data <- Filter(function(x)!all(is.na(x)), Data)
    Data <- subset(Data, Data[2]== "Scotland")
    Data <- Data[,c(1,2,3,5,7,9)]
    names(Data) <- c("CODE", "Country", "Full applications", "Accredited full applications", "Capacity of full applications", "Capacity of accredited full applications")
    Data$Date <- substr(DataSources[i], 27, 34)
    
    
    Combined[[length(Combined)+1]] <- Data
  }
  
  DataSources <- list.files("Data Sources/RHI/Format 3", full.names = TRUE, pattern = "\\.xlsx$")
  
  for (i in 1:length(DataSources)){
    Data <- read_excel(DataSources[i], 
                       sheet = "Table 1.3")
    Data <- Filter(function(x)!all(is.na(x)), Data)
    Data <- subset(Data, Data[1]== "Scotland")
    Data <- Data[,c(1,2,4,6,8)]
    names(Data) <- c("Country", "Full applications", "Accredited full applications", "Capacity of full applications", "Capacity of accredited full applications")
    Data$Date <- substr(DataSources[i], 27, 34)
    Data$CODE <- "S92000003"
    Data <- Data[,c(7,1:6)]
    
    Combined[[length(Combined)+1]] <- Data
  }
  
  Combined <- rbindlist(Combined)
  
  Combined$Date <- as.yearmon(Combined$Date)
  
  Combined <- Combined[,c(7,1:6)]  
  
  Combined <- Combined[order(Combined$Date)]
  
  
  ### Export to CSV ###
  write.table(
    Combined,
    "R Data Output/RHINonDom.txt",
    sep = "\t",
    na = "0",
    row.names = FALSE
  )  
  
  Combined <- list()
  
  DataSources <- list.files("Data Sources/RHI/Format 1", full.names = TRUE, pattern = "\\.xlsx$")
  
  for (i in 1:length(DataSources)){
    Data <- read_excel(DataSources[i], 
                       sheet = "1.4")
    Data <- Filter(function(x)!all(is.na(x)), Data)
    names(Data) <- c("CODE", "LA", "Accredited Applications", "Capacity")
    Data <- subset(Data, substr(Data$CODE, 1,1) == "S")
    Data <- Data[complete.cases(Data),]
    Data$Date <- substr(DataSources[i], 27, 34)
    
    
    Combined[[length(Combined)+1]] <- Data
  }
  
  Combined <- rbindlist(Combined)
  
  Combined$Date <- as.yearmon(Combined$Date)
  
  Combined <- Combined[,c(5,1:4)]  
  
  Combined <- subset(Combined, Combined$Date == max(Combined$Date))
  
  
  ### Export to CSV ###
  write.table(
    Combined,
    "R Data Output/RHINonDomLA.txt",
    sep = "\t",
    na = "0",
    row.names = FALSE
  )  
  
  Combined <- list()
  
  DataSources <- list.files("Data Sources/RHI/Format 1", full.names = TRUE, pattern = "\\.xlsx$")
    
  for (i in 1:length(DataSources)){
    Data <- read_excel(DataSources[i], 
                       sheet = "2.4")
    Data <- Filter(function(x)!all(is.na(x)), Data)
    names(Data) <- c("CODE", "LA", "Accredited Installations")
    Data <- subset(Data, substr(Data$CODE, 1,1) == "S")
    Data <- Data[complete.cases(Data),]
    Data$Date <- substr(DataSources[i], 27, 34)
    
    
    Combined[[length(Combined)+1]] <- Data
  }
  
  Combined <- rbindlist(Combined)
  
  Combined$Date <- as.yearmon(Combined$Date)
  
  Combined <- Combined[,c(4,1:3)]  
  
  Combined <- subset(Combined, Combined$Date == max(Combined$Date))
  
  
  ### Export to CSV ###
  write.table(
    Combined,
    "R Data Output/RHIDomLA.txt",
    sep = "\t",
    na = "0",
    row.names = FALSE
  )  
  