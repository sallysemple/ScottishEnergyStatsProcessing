library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(data.table)



DataList <- list()

yearstart <- 2013
yearend <- format(Sys.Date(), "%Y")


for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  
  ### tryCatch allows the code to still run if an error is encountered, such as a sheet not existing for any given year ###
  tryCatch({
    tryCatch({
      GasLAConsumption <-
        read_excel(
          "Data Sources/Subnational Consumption/Gas.xlsx",
          sheet = paste(year, "r", sep = ""),
          col_names = FALSE
        )
      GasLAConsumption$Year <- year
      
      DataList[[year]] <- GasLAConsumption
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
    tryCatch({
      GasLAConsumption <-
        read_excel(
          "Data Sources/Subnational Consumption/Gas.xlsx",
          sheet = paste(year),
          col_names = FALSE
        )
      
      GasLAConsumption$Year <- year
      
      DataList[[year]] <- GasLAConsumption
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End

GasLAConsumption <- rbindlist(DataList)

names(GasLAConsumption) <- c('Region',
                              'Local Authority',
                              ' ',
                              'LA Code',
                              'LAU1',
                              'Number of MPRNs (thousands) - Domestic meters',
                              'Number of MPRNs (thousands) - Non-domestic meters',
                              'Number of MPRNs (thousands) - Total number of meters',
                              'Sales (GWh) - Domestic consumption',
                              'Sales (GWh) - Non-domestic consumption',
                              'Sales (GWh) - Total consumption',
                              'Averages - Domestic - Mean consumption',
                              'Averages - Domestic - Median consumption',
                              'Averages - Non-domestic - Mean consumption',
                              'Averages - Non-domestic - Median consumption',
                              'Averages - All - Mean consumption',
                              'Averages - All - Median consumption',
                              'Year'
                              )

GasLAConsumption$` ` <- NULL

#GasLAConsumption <- GasLAConsumption[which(substr(GasLAConsumption$`LA Code`,1,1) == "S"),]

source("Processing Scripts/LACodeFunction.R")

GasLAConsumption <- LACodeUpdate(GasLAConsumption)

GasLAConsumption <- as_tibble(GasLAConsumption)

GasLAConsumption[5:17] %<>% lapply(function(x) as.numeric(as.character(x)))

GasLAConsumption <- as_tibble(GasLAConsumption)

write_csv(GasLAConsumption, "Output/Consumption/GasConsumption.csv")
