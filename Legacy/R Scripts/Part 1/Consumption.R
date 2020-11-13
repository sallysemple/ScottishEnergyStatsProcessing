### Load Packages ###
library(readr)
library(readxl)
library(dplyr)

print("Consumption")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###
# This is unlikely to change from 2005
yearstart <- 2005

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")

### Load up a list of Local Authority areas and their corresponding LAU codes ###
AreaCodes <-
  read_csv("Data Sources/Sub-National Consumption/AreaCodes.csv")

### Load the Data Headers ###
# This will also be used in the loop to merge data together

Consumption <-
  read_csv("Data Sources/Sub-National Consumption/DataHeaders.csv",
           col_names = FALSE)

### Convert Headers to a format that can then be applied to the dataset ###
ConsumptionHeader <- sapply(Consumption, paste, collapse = "")

### Apply Headers to Dataset ###
names(Consumption) <- ConsumptionHeader


###### LOOP ######
# This Loop runs for each year between the yearstart (2005) to the current year, inclusive.

for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    ### Load the Data from Sub-National total final energy Consumption, from the corresponding Year tab ###
    # If the Year does not have an associated tab, an error will be printed in the console, and
    # and the rest of the code WITHIN the loop will not be ran. Code after the loop will still be executed.
    # skip and n_max allow only the necessary data to be extracted
    ConsumptionInProgress <-
      read_excel(
        "Data Sources/Sub-National Consumption/Current.xlsx",
        sheet = paste(year, " GWh", sep = ""),
        col_names = FALSE,
        skip = 4
      )
    ### Keep neccessary columns ###
    #ConsumptionInProgress <- ConsumptionInProgress[1:32]
    
    ### Create a new column that adds the corresponding year to the data.
    ConsumptionInProgress$Year <- year
    
    ### Attach the Column Headers to the Data
    names(ConsumptionInProgress) <-  ConsumptionHeader
    
    ### Ensure All Pages read Total Scotland ###
    ConsumptionInProgress$GovernmentRegion[ConsumptionInProgress$GovernmentRegion == "SCOTLAND"] <-
      "TOTAL SCOTLAND"
    
    
    ### Remove the Area codes from the Data
    ConsumptionInProgress$`LAU1` <- NULL
    
    ### Merge with an updated list of Area Codes ###
    # This allows for the data to be uploaded to statistics.gov.scot, though further processing will be needed
    ConsumptionInProgress <-
      merge(
        ConsumptionInProgress,
        AreaCodes,
        by = c("GovernmentRegion"),
        all.y = TRUE
      )
    
    ### Reverse the order of the rows ###
    # The full dataset is revresed again after the loop. This means that areas will be in alphabetical order.
    ConsumptionInProgress <-
      ConsumptionInProgress[nrow(ConsumptionInProgress):1,]
    
    ### Add the Data from the loop to the bottom of the final dataset ###
    Consumption <- rbind(Consumption, ConsumptionInProgress)
    
    
    ### Print any errors from the loop to the console ###
    # This should only be the years for which there is no data. Other errors may require code to be adjusted
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  ###### Repeat for XXXXr ######
  
  tryCatch({
    ### Load the Data from Sub-National total final energy Consumption, from the corresponding Year tab ###
    # If the Year does not have an associated tab, an error will be printed in the console, and
    # and the rest of the code WITHIN the loop will not be ran. Code after the loop will still be executed.
    # skip and n_max allow only the necessary data to be extracted
    ConsumptionInProgress <-
      read_excel(
        "Data Sources/Sub-National Consumption/Current.xlsx",
        sheet = paste(year, "r GWh", sep = ""),
        col_names = FALSE,
        skip = 4
      )
    ### Keep neccessary columns ###
    #ConsumptionInProgress <- ConsumptionInProgress[1:32]
    
    ### Create a new column that adds the corresponding year to the data.
    ConsumptionInProgress$Year <- year
    
    ### Attach the Column Headers to the Data
    names(ConsumptionInProgress) <-  ConsumptionHeader
    
    ### Ensure All Pages read Total Scotland ###
    ConsumptionInProgress$GovernmentRegion[ConsumptionInProgress$GovernmentRegion == "SCOTLAND"] <-
      "TOTAL SCOTLAND"
    
    
    ### Remove the Area codes from the Data
    ConsumptionInProgress$`LAU1` <- NULL
    
    ### Merge with an updated list of Area Codes ###
    # This allows for the data to be uploaded to statistics.gov.scot, though further processing will be needed
    ConsumptionInProgress <-
      merge(
        ConsumptionInProgress,
        AreaCodes,
        by = c("GovernmentRegion"),
        all.y = TRUE
      )
    
    ### Reverse the order of the rows ###
    # The full dataset is revresed again after the loop. This means that areas will be in alphabetical order.
    ConsumptionInProgress <-
      ConsumptionInProgress[nrow(ConsumptionInProgress):1,]
    
    ### Add the Data from the loop to the bottom of the final dataset ###
    Consumption <- rbind(Consumption, ConsumptionInProgress)
    
    
    ### Print any errors from the loop to the console ###
    # This should only be the years for which there is no data. Other errors may require code to be adjusted
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
}


### Remove the First Row from the Dataset ###
# This is the row which was used to create the data headers.
Consumption <- Consumption[-1, ]

### Reverse the Order of the rows, so latest year is at the top ###
Consumption <- Consumption[nrow(Consumption):1,]

### Remove Columns with no data ###
Consumption <-
  Consumption[, grep("^(NA)",
                     names(Consumption),
                     value = TRUE,
                     invert = TRUE)]

### Reorder Columns or readability ###
Consumption <-
  select(Consumption,
         "LAU1",
         "GovernmentRegion",
         "Year",
         "All Fuels Total",
         everything())

### Export to CSV ###
write.table(
  Consumption,
  "R Data Output/Consumption.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)

### Create Subset of just the Scotland Total Consumption Data ###
ScotlandConsumption <- subset(Consumption, LAU1 == "S92000003")

### Export to CSV
write.table(
  ScotlandConsumption,
  "R Data Output/ScotlandConsumption.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
