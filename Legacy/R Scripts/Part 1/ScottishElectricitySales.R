library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)

print("ScottishElectricitySales")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###
# This is unlikely to change from 2013

yearstart <- 2013

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")

### Read Source Data, which serves as the beginning of the master dataframe too ###
ElecSales <-
  read_csv("Data Sources/Sub National Electricity Consumption and Sales/Header.csv")

###### Two Loops, One with year, one with year and an r at the end #######

### First Loop ###
for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  
  ### tryCatch allows the code to still run if an error is encountered, such as a sheet not existing for any given year ###
  tryCatch({
    ElecSalesWorking <-
      read_excel(
        "Data Sources/Sub National Electricity Consumption and Sales/Current.xlsx",
        sheet = paste(year),
        col_names = FALSE
      )
    
    ### Subset of rows where second column is Scotland ###
    ElecSalesWorking <-
      subset(ElecSalesWorking, X__3 == "S92000003")
    
    ### Add current year in the loop to its own column
    ElecSalesWorking$Year <- year
    
    ### Merge with overall dataframe ###
    ElecSales <- merge(ElecSales, ElecSalesWorking, all = TRUE)
    
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
    ElecSalesWorking <-
      read_excel(
        "Data Sources/Sub National Electricity Consumption and Sales/Current.xlsx",
        sheet = paste(year, "r", sep = ""),
        col_names = FALSE
      )
    
    
    ElecSalesWorking <-
      subset(ElecSalesWorking, X__3 == "S92000003")
    
    ElecSalesWorking$Year <- year
    
    ElecSales <- merge(ElecSales, ElecSalesWorking, all = TRUE)
    
    ### Print any errors from the loop to the console ###
    # This should only be the years for which there is no data. Other errors may require code to be adjusted
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End

### Remove unnecessary columns ###
ElecSales[6:27] <- list(NULL)

### Rename Columns ###
names(ElecSales) <-
  c("Local Authority",
    "All Domestic",
    "All Non-domestic",
    "Average Consumption",
    "Year")

### Remove First Row ###
ElecSales <- ElecSales[-1,]

### Keep only required columns ###
ElecSales <-
  ElecSales[, c('Year',
                'All Domestic',
                'All Non-domestic',
                'Average Consumption')]

### Arrange data by Year ###
ElecSales <- arrange(ElecSales, (Year))

### Export to CSV ###
write.table(
  ElecSales,
  "R Data Output/ElecSales.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)