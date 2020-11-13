library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)

print("ScottishGasSales")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###
# This is unlikely to change from 2012

yearstart <- 2012

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")

### Read Source Data, which serves as the beginning of the master dataframe too ###
GasSales <-
  read_csv("Data Sources/Sub National Gas Consumption and Sales/Header.csv")

###### Two Loops, One with year, one with year and an r at the end #######

### First Loop ###
for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  ### tryCatch allows the code to still run if an error is encountered, such as a sheet not existing for any given year ###
  tryCatch({
    GasSalesWorking <-
      read_excel(
        "Data Sources/Sub National Gas Consumption and Sales/Current.xlsx",
        sheet = paste(year),
        col_names = FALSE
      )
    
    ### Subset of rows where second column is Scotland ###
    GasSalesWorking <- subset(GasSalesWorking, X__4 == "S92000003")
    
    ### Add current year in the loop to its own column
    GasSalesWorking$Year <- year
    
    ### Merge with overall dataframe ###
    GasSales <- merge(GasSales, GasSalesWorking, all = TRUE)
    
    ### Print any errors from the loop to the console ###
    # This should only be the years for which there is no data. Other errors may require code to be adjusted
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End


### Second Loop - XXXXr ###
for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    GasSalesWorking <-
      read_excel(
        "Data Sources/Sub National Gas Consumption and Sales/Current.xlsx",
        sheet = paste(year, "r", sep = ""),
        col_names = FALSE
      )
    
    
    GasSalesWorking <- subset(GasSalesWorking, X__4 == "S92000003")
    
    GasSalesWorking$Year <- year
    
    GasSales <- merge(GasSales, GasSalesWorking, all = TRUE)
    
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End

### Remove unnecessary columns ###
GasSales[7:27] <- list(NULL)

### Rename Columns ###
names(GasSales) <-
  c(
    "Local Authority",
    "All Domestic",
    "All Non-domestic",
    "Total Consumption",
    "Mean Domestic",
    "Year"
  )

### Remove First Row ###
GasSales <- GasSales[-1,]

### Keep only required columns ###
GasSales <-
  GasSales[, c('Year',
               'All Domestic',
               'All Non-domestic',
               'Total Consumption',
               "Mean Domestic")]

### Arrange data by Year ###
GasSales <- arrange(GasSales, (Year))

### Export to CSV ###
write.table(
  GasSales,
  "R Data Output/GasSales.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)