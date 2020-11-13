library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(data.table)

print("LAConsumption")

### First Row to Names Function ###
header.true <- function(df) {
  names(df) <- as.character(unlist(df[1,]))
  df[-1,]
}


### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###
# This is unlikely to change from 2013

yearstart <- 2013

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")

###### Electricity ######

### Read Source Data, which serves as the beginning of the master dataframe too ###
LASide <-
  read_csv("Data Sources/Sub National Electricity Consumption and Sales/LABreakdown.csv")
ElecHeader <-
  read_csv("Data Sources/Sub National Electricity Consumption and Sales/Header.csv")

ElecHeader <- head(ElecHeader, 1)
###### Two Loops, One with year, one with year and an r at the end #######

### Loop ###
for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  
  ### tryCatch allows the code to still run if an error is encountered, such as a sheet not existing for any given year ###
  tryCatch({
    tryCatch({
      ElecLAConsumption <-
        read_excel(
          "Data Sources/Sub National Electricity Consumption and Sales/Current.xlsx",
          sheet = paste(year, "r", sep = ""),
          col_names = FALSE
        )
      
      ElecLAConsumption$Year <- year
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
    tryCatch({
      ElecLAConsumption <-
        read_excel(
          "Data Sources/Sub National Electricity Consumption and Sales/Current.xlsx",
          sheet = paste(year),
          col_names = FALSE
        )
      
      ElecLAConsumption$Year <- year
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End

ElecLAConsumption <-
  merge(ElecHeader, ElecLAConsumption, all = TRUE)
ElecLAConsumption <- merge(LASide, ElecLAConsumption)

ElecLAConsumption[7:27] <- NULL


ElecLAConsumption <- header.true(ElecLAConsumption)

write.table(
  ElecLAConsumption,
  "R Data Output/ElecLAConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


###### Gas #######

### Read Source Data, which serves as the beginning of the master dataframe too ###
LASide <-
  read_csv("Data Sources/Sub National Gas Consumption and Sales/LABreakdown.csv")
GasHeader <-
  read_csv("Data Sources/Sub National Gas Consumption and Sales/Header.csv")

GasHeader <- head(GasHeader, 1)
###### Two Loops, One with year, one with year and an r at the end #######

### Loop ###
for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  
  ### tryCatch allows the code to still run if an error is encountered, such as a sheet not existing for any given year ###
  tryCatch({
    tryCatch({
      GasLAConsumption <-
        read_excel(
          "Data Sources/Sub National Gas Consumption and Sales/Current.xlsx",
          sheet = paste(year, "r", sep = ""),
          col_names = FALSE
        )
      
      GasLAConsumption$Year <- year
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
    tryCatch({
      GasLAConsumption <-
        read_excel(
          "Data Sources/Sub National Gas Consumption and Sales/Current.xlsx",
          sheet = paste(year),
          col_names = FALSE
        )
      
      GasLAConsumption$Year <- year
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End

GasLAConsumption <-
  merge(GasHeader, GasLAConsumption, all = TRUE)
GasLAConsumption <- merge(LASide, GasLAConsumption)

GasLAConsumption[8:27] <- NULL


GasLAConsumption <- header.true(GasLAConsumption)

write.table(
  GasLAConsumption,
  "R Data Output/GasLAConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
