### Load Packages ###
library(readr)
library(readxl)
library(dplyr)
library(tidyr)

print("LoadFactors")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###
# This is unlikely to change from 2014
yearstart <- 2013

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")


### Load the Data Headers ###
# This will also be used in the loop to merge data together

LoadFactors <-
  read_csv("Data Sources/Load Factors/Header.csv")

for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    LoadFactorsWorking <-
      read_excel(
        "Data Sources/Load Factors/Current.xls",
        sheet = paste("UC LF ", year, sep = ""),
        skip = 2
      )
    LoadFactorsWorking <-
      subset(LoadFactorsWorking, X__1 == "Scotland" | X__1 == "UK AVERAGE")
    
    LoadFactorsWorking$Year <- year
    
    LoadFactors <- merge(LoadFactors, LoadFactorsWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  tryCatch({
    LoadFactorsWorking <-
      read_excel(
        "Data Sources/Load Factors/Current.xls",
        sheet = paste("UC LF ", year, "r", sep = ""),
        skip = 2
      )
    LoadFactorsWorking <-
      subset(LoadFactorsWorking, X__1 == "Scotland" | X__1 == "UK AVERAGE")
    
    LoadFactorsWorking$Year <- year
    
    LoadFactors <- merge(LoadFactors, LoadFactorsWorking, all = TRUE)
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
}


LoadFactors <- fill(LoadFactors, 'Solar PV', .direction = "up")

LoadFactors <- subset(LoadFactors, X__1 == "Scotland")

### Export to CSV
write.table(
  LoadFactors,
  "R Data Output/LoadFactors.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)