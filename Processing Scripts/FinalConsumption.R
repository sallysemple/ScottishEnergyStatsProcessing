library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(data.table)

print("FinalConsumption")

### This Script processes Sub-National Consumption from and outputs a data frame with a row for each local authority in each year where data is available. It also includes a calculation of the split between Industrial and Commercial consumption for Gas and Bioenergy. Also produces a version for the format required by Statistics.gov.scot ###


### Is Sub-National individual fuel Source more recent than Sub-National Final Consumption? ###

SubNationalElec <- TRUE
SubNationalGas <- TRUE
#SubNationalTransport <- TRUE Code needs written




#Create list for Data Storage
DataList <- list()

#First Year of Data
yearstart <- 2005

#Sets current year as the final year for upcoming loop
yearend <- format(Sys.Date(), "%Y")


for (year in yearstart:yearend) {
  # Loop for each year between start year and current year
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year (and suffix) in the loop.
  
  
  tryCatch({
    tryCatch({
      # Load subnational consumption for selected year in the loop, with the suffix r
      TotalFinalLAConsumption <-
        read_excel(
          "Data Sources/Subnational Consumption/TotalFinal.xlsx",
          sheet = paste(year, "r", sep = ""),
          col_names = FALSE
        )
      
      #Add column with selected year
      TotalFinalLAConsumption$Year <- year
      
      #Add Data to the list
      DataList[[year]] <- TotalFinalLAConsumption
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
    # Repeat above without the suffix
    tryCatch({
      TotalFinalLAConsumption <-
        read_excel(
          "Data Sources/Subnational Consumption/TotalFinal.xlsx",
          sheet = paste(year),
          col_names = FALSE
        )
      
      TotalFinalLAConsumption$Year <- year
      
      DataList[[year]] <- TotalFinalLAConsumption
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End

#Combine list together into one data frame
TotalFinalLAConsumption <- rbindlist(DataList)

#Rename columns
names(TotalFinalLAConsumption) <- c('LA Code',
                             'Region',
                             'Local Authority',
                             'Notes',
                             'Consuming Sector - Domestic',
                             'Consuming Sector - Transport',
                             'Consuming Sector - Industry & Commercial',
                             'All fuels - Total',
                             'Coal - Industrial',
                             'Coal - Commercial',
                             'Coal - Domestic',
                             'Coal - Rail',
                             'Coal - Public Sector',
                             'Coal - Agriculture',
                             'Coal - Total',
                             'Manufactured fuels - Industrial',
                             'Manufactured fuels - Domestic',
                             'Manufactured fuels - Total',
                             'Petroleum products - Industrial',
                             'Petroleum products - Commercial',
                             'Petroleum products - Domestic',
                             'Petroleum products - Road transport',
                             'Petroleum products - Rail',
                             'Petroleum products - Public Sector',
                             'Petroleum products - Agriculture',
                             'Petroleum products - Total',
                             'Gas - Domestic',
                             'Gas - Industrial & Commercial',
                             'Gas - Total',
                             'Electricity - Domestic',
                             'Electricity - Industrial & Commercial',
                             'Electricity - Total',
                             'Bioenergy & wastes - Domestic',
                             'Bioenergy & wastes - Road transport',
                             'Bioenergy & wastes - Industrial & Commercial',
                             'Bioenergy & wastes - Total',
                             'Year'
                              )


# Remove rows without data
TotalFinalLAConsumption <- TotalFinalLAConsumption[which(TotalFinalLAConsumption$`All fuels - Total` > 0),]

# Keep only rows with a Scottish or UK-wide LA Code
TotalFinalLAConsumption <- TotalFinalLAConsumption[which(substr(TotalFinalLAConsumption$`LA Code`,1,1) == "S" | substr(TotalFinalLAConsumption$`LA Code`,1,1) == "K"),]

# Convert to Tibble, makes next instruction function properly
TotalFinalLAConsumption <- as_tibble(TotalFinalLAConsumption)

# Convert Columns to GWh
TotalFinalLAConsumption[5:36] %<>% lapply(function(x) as.numeric(as.character(x))*11.63)

# Load and run the function that updates LA Codes to the latest standard
source("Processing Scripts/LACodeFunction.R")
TotalFinalLAConsumption <- LACodeUpdate(TotalFinalLAConsumption)


#Run Code if Sub National Gas is more recent 
if (SubNationalGas == TRUE){
  #Run Gas Consumption Script
  source("Processing Scripts/GasConsumption.R")

  
  #Keep only data after the first year of sub-national data
  GasLAConsumption <- GasLAConsumption[which(GasLAConsumption$Year >= min(TotalFinalLAConsumption$Year)),]
  
  #Keep only rows with Data
  GasLAConsumption <- GasLAConsumption[which(GasLAConsumption$`Sales (GWh) - Domestic consumption` > 0),]
  
  #Keep only rows with Scotland or UK Wide LA code
  GasLAConsumption <- GasLAConsumption[which(substr(GasLAConsumption$`LA Code`,1,1) == "S" | substr(GasLAConsumption$`LA Code`,1,1) == "K"),]
  
  GasLAConsumption <- GasLAConsumption[which(substr(GasLAConsumption$`LA Code`,2,2)!= "c"),]
  
  #Select only relevant columns
  GasLAConsumption <- select(GasLAConsumption, c(
    `LA Code`,
    Year,
    `Sales (GWh) - Domestic consumption`,
    `Sales (GWh) - Non-domestic consumption`,
    `Sales (GWh) - Total consumption`
    
  ))
  #Merge Data Frames
  TotalFinalLAConsumption <- merge(TotalFinalLAConsumption, GasLAConsumption, all = TRUE)
 
  #Replace Gas - Domestic in years where it is possible to do so
  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Domestic consumption` > 0),]$`Gas - Domestic` <-  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Domestic consumption` > 0),]$`Sales (GWh) - Domestic consumption`
  
  #Replace Gas - Non-Domestic in years where it is possible to do so
  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Non-domestic consumption` > 0),]$`Gas - Industrial & Commercial` <-  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Non-domestic consumption` > 0),]$`Sales (GWh) - Non-domestic consumption`
  
  #Replace Gas - Total in years where it is possible to do so
  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Total consumption` > 0),]$`Gas - Total` <-  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Total consumption` > 0),]$`Sales (GWh) - Total consumption`
  
  #Remove Extra Columns
  TotalFinalLAConsumption$`Sales (GWh) - Domestic consumption` <- NULL
  TotalFinalLAConsumption$`Sales (GWh) - Non-domestic consumption` <- NULL
  TotalFinalLAConsumption$`Sales (GWh) - Total consumption` <- NULL
  
  #Reoder Data
  TotalFinalLAConsumption <- TotalFinalLAConsumption[order(TotalFinalLAConsumption$`LA Code`, TotalFinalLAConsumption$Year),]
  
  #Fill for Provisional Years
  TotalFinalLAConsumption <- TotalFinalLAConsumption %>% fill(1:37)
  
  #RecalculateTotals
  TotalFinalLAConsumption$`All fuels - Total` <-
    TotalFinalLAConsumption$`Coal - Total` +
    TotalFinalLAConsumption$`Manufactured fuels - Total` +
    TotalFinalLAConsumption$`Petroleum products - Total` +
    TotalFinalLAConsumption$`Gas - Total` +
    TotalFinalLAConsumption$`Electricity - Total`+
    TotalFinalLAConsumption$`Bioenergy & wastes - Total`
  
  TotalFinalLAConsumption$`Consuming Sector - Domestic` <- 
    TotalFinalLAConsumption$`Coal - Domestic` +
    TotalFinalLAConsumption$`Manufactured fuels - Domestic` + 
    TotalFinalLAConsumption$`Petroleum products - Domestic` +
    TotalFinalLAConsumption$`Gas - Domestic` +
    TotalFinalLAConsumption$`Electricity - Domestic` +
    TotalFinalLAConsumption$`Bioenergy & wastes - Domestic`

  
  TotalFinalLAConsumption$`Consuming Sector - Transport` <-
    TotalFinalLAConsumption$`Coal - Rail` +
    TotalFinalLAConsumption$`Petroleum products - Road transport` +
    TotalFinalLAConsumption$`Petroleum products - Rail` +
    TotalFinalLAConsumption$`Bioenergy & wastes - Road transport`
  
  TotalFinalLAConsumption$`Consuming Sector - Industry & Commercial` <-
    TotalFinalLAConsumption$`All fuels - Total` - 
    TotalFinalLAConsumption$`Consuming Sector - Domestic`-
    TotalFinalLAConsumption$`Consuming Sector - Transport`

  
}

#Run Code if Sub National Electricity is more recent 
if (SubNationalElec == TRUE){
  #Run Elec Consumption Script
  source("Processing Scripts/ElectricityConsumption.R")
  
  
  #Keep only data after the first year of sub-national data
  ElecLAConsumption <- ElecLAConsumption[which(ElecLAConsumption$Year >= min(TotalFinalLAConsumption$Year)),]
  
  #Keep only rows with Data
  ElecLAConsumption <- ElecLAConsumption[which(ElecLAConsumption$`Sales (GWh) - Domestic consumers - All domestic` > 0),]
  
  #Keep only rows with Scotland or UK Wide LA code
  ElecLAConsumption <- ElecLAConsumption[which(substr(ElecLAConsumption$`LA Code`,1,1) == "S" | substr(ElecLAConsumption$`LA Code`,1,1) == "K"),]
  
  ElecLAConsumption <- ElecLAConsumption[which(substr(ElecLAConsumption$`LA Code`,2,2)!= "c"),]
  
  #Select only relevant columns
  ElecLAConsumption <- select(ElecLAConsumption, c(
    `LA Code`,
    Year,
    `Sales (GWh) - Domestic consumers - All domestic`,
    `Sales (GWh) - Non-domestic consumers - All non-domestic`,
    `Sales (GWh) - All - Total consumption`
    
  ))
  #Merge Data Frames
  TotalFinalLAConsumption <- merge(TotalFinalLAConsumption, ElecLAConsumption, all = TRUE)
  
  
  
  #Replace Elec - Domestic in years where it is possible to do so
  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Domestic consumers - All domestic` > 0),]$`Electricity - Domestic` <-  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Domestic consumers - All domestic` > 0),]$`Sales (GWh) - Domestic consumers - All domestic`
  
  #Replace Elec - Non-Domestic in years where it is possible to do so
  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Non-domestic consumers - All non-domestic` > 0),]$`Electricity - Industrial & Commercial` <-  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - Non-domestic consumers - All non-domestic` > 0),]$`Sales (GWh) - Non-domestic consumers - All non-domestic`
  
  #Replace Elec - Total in years where it is possible to do so
  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - All - Total consumption` > 0),]$`Electricity - Total` <-  TotalFinalLAConsumption[which(TotalFinalLAConsumption$`Sales (GWh) - All - Total consumption` > 0),]$`Sales (GWh) - All - Total consumption`
  
  #Remove Extra Columns
  TotalFinalLAConsumption$`Sales (GWh) - Domestic consumers - All domestic` <- NULL
  TotalFinalLAConsumption$`Sales (GWh) - Non-domestic consumers - All non-domestic` <- NULL
  TotalFinalLAConsumption$`Sales (GWh) - All - Total consumption` <- NULL
  
  #Reoder Data
  TotalFinalLAConsumption <- TotalFinalLAConsumption[order(TotalFinalLAConsumption$`LA Code`, TotalFinalLAConsumption$Year),]
  
  #Fill for Provisional Years
  TotalFinalLAConsumption <- TotalFinalLAConsumption %>% fill(1:37)
  
  #RecalculateTotals
  TotalFinalLAConsumption$`All fuels - Total` <-
    TotalFinalLAConsumption$`Coal - Total` +
    TotalFinalLAConsumption$`Manufactured fuels - Total` +
    TotalFinalLAConsumption$`Petroleum products - Total` +
    TotalFinalLAConsumption$`Gas - Total` +
    TotalFinalLAConsumption$`Electricity - Total`+
    TotalFinalLAConsumption$`Bioenergy & wastes - Total`
  
  TotalFinalLAConsumption$`Consuming Sector - Domestic` <- 
    TotalFinalLAConsumption$`Coal - Domestic` +
    TotalFinalLAConsumption$`Manufactured fuels - Domestic` + 
    TotalFinalLAConsumption$`Petroleum products - Domestic` +
    TotalFinalLAConsumption$`Gas - Domestic` +
    TotalFinalLAConsumption$`Electricity - Domestic` +
    TotalFinalLAConsumption$`Bioenergy & wastes - Domestic`
  
  
  TotalFinalLAConsumption$`Consuming Sector - Transport` <-
    TotalFinalLAConsumption$`Coal - Rail` +
    TotalFinalLAConsumption$`Petroleum products - Road transport` +
    TotalFinalLAConsumption$`Petroleum products - Rail` +
    TotalFinalLAConsumption$`Bioenergy & wastes - Road transport`
  
  TotalFinalLAConsumption$`Consuming Sector - Industry & Commercial` <-
    TotalFinalLAConsumption$`All fuels - Total` - 
    TotalFinalLAConsumption$`Consuming Sector - Domestic`-
    TotalFinalLAConsumption$`Consuming Sector - Transport`
  
  
}



# Source and run the script that calculates the end use proportion of fuels within sectors 
source("Processing Scripts/ECUKEndUse.R")

# Load the Industrial and Commercial split for Gas and Bioenergy. Output of the above script. 
GasBioenergySplit  <- read_csv("Output/Consumption/GasBioenergySplit.csv")

# Merge the Consumption and Split data frames together
TotalFinalLAConsumption <- merge(TotalFinalLAConsumption, GasBioenergySplit, all = TRUE)

# Order data frame by year and LACode
TotalFinalLAConsumption <- TotalFinalLAConsumption[order(TotalFinalLAConsumption$Year, TotalFinalLAConsumption$`LA Code`),]


# Fill down the Split values for each LA within a year.
TotalFinalLAConsumption <- TotalFinalLAConsumption %>% fill(38:41, .direction = "up")
TotalFinalLAConsumption <- TotalFinalLAConsumption %>% fill(38:41, .direction = "down")
# Convert to Tibble
TotalFinalLAConsumption <- as_tibble(TotalFinalLAConsumption )

# Multiply the Gas - Industrial & Commercial by the split factors, to create new columns for each, then remove the old column 
TotalFinalLAConsumption$`Gas - Industrial` <- TotalFinalLAConsumption$`Gas - Industrial` * TotalFinalLAConsumption$`Gas - Industrial & Commercial`
TotalFinalLAConsumption$`Gas - Commercial` <- TotalFinalLAConsumption$`Gas - Commercial` * TotalFinalLAConsumption$`Gas - Industrial & Commercial`
TotalFinalLAConsumption$`Gas - Industrial & Commercial` <- NULL


# Repeat for Bioenergy & Wastes
TotalFinalLAConsumption$`Bioenergy & Wastes - Industrial` <- TotalFinalLAConsumption$`Bioenergy & Wastes - Industrial` * TotalFinalLAConsumption$`Bioenergy & wastes - Industrial & Commercial`
TotalFinalLAConsumption$`Bioenergy & Wastes - Commercial` <- TotalFinalLAConsumption$`Bioenergy & Wastes - Commercial` * TotalFinalLAConsumption$`Bioenergy & wastes - Industrial & Commercial`
TotalFinalLAConsumption$`Bioenergy & wastes - Industrial & Commercial` <- NULL

# Reorganise Data Frame
TotalFinalLAConsumption <- TotalFinalLAConsumption[c(1,2,4, 10:27, 36,37,28:32, 38, 39, 33,34,35, 9, 6,7,8  )]

# Rename Local Authority column to region
names(TotalFinalLAConsumption)[3] <- "Region"

# Write Output
write_csv(TotalFinalLAConsumption, "Output/Consumption/TotalFinalConsumption.csv")












### Statistics.gov.scot

FinalConsumptionScotStat <- melt(TotalFinalLAConsumption, id.vars = c("LA Code", "Year", "Region"))


FinalConsumptionScotStat <- FinalConsumptionScotStat[which(substr(FinalConsumptionScotStat$`LA Code`,1,1) == "S"),]

FinalConsumptionScotStat <- FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Region` != "SCOTLAND"),]

FinalConsumptionScotStat <- separate(FinalConsumptionScotStat, 4, c("Energy Type", "Energy Consuming Sector"), sep = "-")

FinalConsumptionScotStat$Measurement <- "Count"

FinalConsumptionScotStat$Units <- "GWh"

FinalConsumptionScotStat$Region <- NULL

names(FinalConsumptionScotStat) <- c("GeographyCode", "DateCode", "Energy Type", "Energy Consuming Sector", "Value", "Measurement", "Units")

FinalConsumptionScotStat$`Energy Consuming Sector` <- trimws(FinalConsumptionScotStat$`Energy Consuming Sector`)

FinalConsumptionScotStat$`Energy Type` <- trimws(FinalConsumptionScotStat$`Energy Type`)

FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Energy Consuming Sector` %in% c("Industrial & Commercial", "Industry & Commercial")),]$`Energy Consuming Sector` <- "Industrial & Commercial"

FinalConsumptionScotStat <- FinalConsumptionScotStat %>% group_by(GeographyCode, DateCode,Measurement, Units,`Energy Type`, `Energy Consuming Sector`) %>% summarise(Value = sum(Value))

FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Energy Type` == "Consuming Sector"),]$`Energy Type` <- "All"

FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Energy Type` == "All fuels"),]$`Energy Type` <- "All"

FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Energy Type` == "Bioenergy & wastes"),]$`Energy Type` <- "Bioenergy & Wastes"

FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Energy Type` == "Manufactured fuels"),]$`Energy Type` <- "Manufactured Fuels"

FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Energy Type` == "Petroleum products"),]$`Energy Type` <- "Petroleum Products"

FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Energy Consuming Sector` == "Total"),]$`Energy Consuming Sector` <- "All"

FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Energy Consuming Sector` == "Road transport"),]$`Energy Consuming Sector` <- "Road Transport"

unique(FinalConsumptionScotStat$`Energy Consuming Sector`)

unique(FinalConsumptionScotStat$`Energy Type`)

FinalConsumptionScotStat$Value <- as.numeric(round(FinalConsumptionScotStat$Value,3))

write_csv(FinalConsumptionScotStat, "Output/Consumption/ScotStatConsumption.csv")
