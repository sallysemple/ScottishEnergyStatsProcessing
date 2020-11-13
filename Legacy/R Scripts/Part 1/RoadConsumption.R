library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)

print("RoadCOnsumption")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###
# This is unlikely to change from 2005

yearstart <- 2005

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")

### Read Source Data for Header ###
RoadConsumption <-
  read_csv("Data Sources/Road Transport/Header.csv")

### LOOP ###
for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    ### Read Source Data, tab of the current year ###
    RoadConsumptionWorking <-
      read_excel(
        "Data Sources/Road Transport/Current.xlsx",
        sheet = paste(year),
        col_names = FALSE
      )
    
    ### Subset Country Level information ###
    RoadConsumptionWorking <-
      subset(
        RoadConsumptionWorking,
        X__2 == "Scotland" |
          X__2 == "Wales" |
          X__2 == "England" | X__2 == "TOTAL UNITED KINGDOM"
      )
    
    ### Add Current Loop year to its own column ###
    RoadConsumptionWorking$Year <- year
    
    ### Merge Data to master dataframe ###
    RoadConsumption <-
      merge(RoadConsumption, RoadConsumptionWorking, all = TRUE)
    
    ### Print any errors from the loop to the console ###
    # This should only be the years for which there is no data. Other errors may require code to be adjusted
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })

  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    ### Read Source Data, tab of the current year ###
    RoadConsumptionWorking <-
      read_excel(
        "Data Sources/Road Transport/Current.xlsx",
        sheet = paste(year, "r", sep=""),
        col_names = FALSE
      )
    
    ### Subset Country Level information ###
    RoadConsumptionWorking <-
      subset(
        RoadConsumptionWorking,
        X__2 == "Scotland" |
          X__2 == "Wales" |
          X__2 == "England" | X__2 == "TOTAL UNITED KINGDOM"
      )
    
    ### Add Current Loop year to its own column ###
    RoadConsumptionWorking$Year <- year
    
    ### Merge Data to master dataframe ###
    RoadConsumption <-
      merge(RoadConsumption, RoadConsumptionWorking, all = TRUE)
    
    ### Print any errors from the loop to the console ###
    # This should only be the years for which there is no data. Other errors may require code to be adjusted
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End

### Remove uneeded columns ###
RoadConsumption[13:34] <- list(NULL)

### Apply Column Names from first row ###
names(RoadConsumption) <- as.matrix(RoadConsumption[1,])

### Remove First Row ###
RoadConsumption <- RoadConsumption[-1,]

### Create Scottish Subset ###
ScotlandRoadConsumption <-
  subset(RoadConsumption, Country == "Scotland")

### Export Table ###
write.table(
  ScotlandRoadConsumption,
  "R Data Output/ScotlandRoadConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### Create English Subset ###
EnglandRoadConsumption <-
  subset(RoadConsumption, Country == "England")

### Export ###
write.table(
  EnglandRoadConsumption,
  "R Data Output/EnglandRoadConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### Welsh Subset ###
WalesRoadConsumption <- subset(RoadConsumption, Country == "Wales")

### Export ###
write.table(
  WalesRoadConsumption,
  "R Data Output/WalesRoadConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### UK subset ###
UKRoadConsumption <-
  subset(RoadConsumption, Country == "TOTAL UNITED KINGDOM")

### Export ###
write.table(
  UKRoadConsumption,
  "R Data Output/UKRoadConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)