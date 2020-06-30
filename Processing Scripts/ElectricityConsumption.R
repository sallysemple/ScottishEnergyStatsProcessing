library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(data.table)

print("ElectricityConsumption")

DataList <- list()

yearstart <- 2013
yearend <- format(Sys.Date(), "%Y")


for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  
  ### tryCatch allows the code to still run if an error is encountered, such as a sheet not existing for any given year ###
  tryCatch({
    tryCatch({
      ElecLAConsumption <-
        read_excel(
          "Data Sources/Subnational Consumption/Electricity.xlsx",
          sheet = paste(year, "r", sep = ""),
          col_names = FALSE
        )
      ElecLAConsumption$Year <- year
      
      DataList[[year]] <- ElecLAConsumption
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
    tryCatch({
      ElecLAConsumption <-
        read_excel(
          "Data Sources/Subnational Consumption/Electricity.xlsx",
          sheet = paste(year),
          col_names = FALSE
        )
      
      ElecLAConsumption$Year <- year
      
      DataList[[year]] <- ElecLAConsumption
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End

ElecLAConsumption <- rbindlist(DataList)

names(ElecLAConsumption) <- c('Region',	
                              'Local Authority',	
                              'LA Code',	
                              'LAU1',
                              'Number of MPANs (thousands) - Domestic consumers - Economy 7 meters',
                              'Number of MPANs (thousands) - Domestic consumers - Standard Meters',
                              'Number of MPANs (thousands) - Domestic consumers - All domestic',
                              'Number of MPANs (thousands) - Non-domestic consumers - All Non-domestic',
                              'Number of MPANs (thousands) - Non-domestic consumers - Total number of Meters',
                              'Sales (GWh) - Domestic consumers - Economy 7 meters',
                              'Sales (GWh) - Domestic consumers - Standard meters',
                              'Sales (GWh) - Domestic consumers - All domestic',
                              'Sales (GWh) - Non-domestic consumers - All non-domestic',
                              'Sales (GWh) - All - Total consumption',
                              'Averages (KWh) - Domestic Economy 7 - Mean consumption',
                              'Averages (KWh) - Domestic Economy 8 - Median consumption',
                              'Averages (KWh) - Standard - Mean consumption',
                              'Averages (KWh) - Standard - Median consumption',
                              'Averages (KWh) - All domestic - Mean consumption',
                              'Averages (KWh) - All domestic - Median consumption',
                              'Averages (KWh) - Non-domestic - Mean consumption',
                              'Averages (KWh) - Non-domestic - Median consumption',
                              'Averages (KWh) - All - Mean consumption',
                              'Averages (KWh) - All - Median consumption',
                              ' ',
                              'Average domestic consumption per household (kWh) (2) -  - ',
                              'Year'
                              
)

ElecLAConsumption$` ` <- NULL

ElecLAConsumption <- ElecLAConsumption[which(substr(ElecLAConsumption$`LA Code`,1,1) == "S"),]

source("Processing Scripts/LACodeFunction.R")

ElecLAConsumption <- LACodeUpdate(ElecLAConsumption)

ElecLAConsumption

write_csv(ElecLAConsumption, "Output/Consumption/ElectricityConsumption.csv")
