library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(data.table)

print("FinalConsumption")

DataList <- list()

yearstart <- 2005
yearend <- format(Sys.Date(), "%Y")


for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  
  ### tryCatch allows the code to still run if an error is encountered, such as a sheet not existing for any given year ###
  tryCatch({
    tryCatch({
      TotalFinalLAConsumption <-
        read_excel(
          "Data Sources/Subnational Consumption/TotalFinal.xlsx",
          sheet = paste(year, "r", " GWh", sep = ""),
          col_names = FALSE
        )
      TotalFinalLAConsumption$Year <- year
      
      DataList[[year]] <- TotalFinalLAConsumption
      
    }, error = function(e) {
      cat("ERROR :", conditionMessage(e), "\n")
    })
    
    tryCatch({
      TotalFinalLAConsumption <-
        read_excel(
          "Data Sources/Subnational Consumption/TotalFinal.xlsx",
          sheet = paste(year, "GWh"),
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

TotalFinalLAConsumption <- rbindlist(DataList)

names(TotalFinalLAConsumption) <- c('LA Code',
                             'Region',
                             'Coal - Industrial',
                             'Coal - Commercial',
                             'Coal - Domestic',
                             'Coal - Rail',
                             'Coal - Public Sector',
                             'Coal - Agriculture',
                             'Coal - Total',
                             'Coal',
                             'Manufactured fuels - Industrial',
                             'Manufactured fuels - Domestic',
                             'Manufactured fuels - Total',
                             'Manufactured fuels',
                             'Petroleum products - Industrial',
                             'Petroleum products - Commercial',
                             'Petroleum products - Domestic',
                             'Petroleum products - Road transport',
                             'Petroleum products - Rail',
                             'Petroleum products - Public Sector',
                             'Petroleum products - Agriculture',
                             'Petroleum products - Total',
                             'Petroleum products',
                             'Gas - Industrial & Commercial',
                             'Gas - Domestic',
                             'Gas - Total',
                             'Gas',
                             'Electricity - Industrial & Commercial',
                             'Electricity - Domestic',
                             'Electricity - Total',
                             'Electricity',
                             'Bioenergy & wastes - Industrial & Commercial',
                             'Bioenergy & wastes - Domestic',
                             'Bioenergy & wastes - Total',
                             'Bioenergy & wastes',
                             'All fuels - Total',
                             'All fuels',
                             'Consuming Sector - Industry & Commercial',
                             'Consuming Sector - Domestic',
                             'Consuming Sector - Transport',
                             'Year'
                              )

TotalFinalLAConsumption$Coal <- NULL
TotalFinalLAConsumption$`Manufactured fuels` <- NULL
TotalFinalLAConsumption$`Petroleum products` <- NULL
TotalFinalLAConsumption$Gas <- NULL
TotalFinalLAConsumption$Electricity <- NULL
TotalFinalLAConsumption$`Bioenergy & wastes` <- NULL
TotalFinalLAConsumption$`All fuels` <- NULL



TotalFinalLAConsumption <- TotalFinalLAConsumption[which(substr(TotalFinalLAConsumption$`LA Code`,1,1) == "S" | substr(TotalFinalLAConsumption$`LA Code`,1,1) == "K"),]

#TotalFinalLAConsumption <- subset(TotalFinalLAConsumption, TotalFinalLAConsumption$Region != "SCOTLAND")

source("Processing Scripts/LACodeFunction.R")

TotalFinalLAConsumption <- LACodeUpdate(TotalFinalLAConsumption)



GasBioenergySplit <- read_excel("Data Sources/Subnational Consumption/GasBioenergySplit.xlsx")

TotalFinalLAConsumption <- merge(TotalFinalLAConsumption, GasBioenergySplit, all = TRUE)

TotalFinalLAConsumption <- TotalFinalLAConsumption[order(TotalFinalLAConsumption$Year, -TotalFinalLAConsumption$`LA Code`),]

TotalFinalLAConsumption <- TotalFinalLAConsumption %>% fill(34:38)

TotalFinalLAConsumption <- as_tibble(TotalFinalLAConsumption )

TotalFinalLAConsumption[4:38] %<>% lapply(function(x) as.numeric(as.character(x)))

TotalFinalLAConsumption[is.na(TotalFinalLAConsumption)] <- 0

TotalFinalLAConsumption$`Gas - Industrial` <- TotalFinalLAConsumption$`Gas - Industrial` * TotalFinalLAConsumption$`Gas - Industrial & Commercial`

TotalFinalLAConsumption$`Gas - Commercial` <- TotalFinalLAConsumption$`Gas - Commercial` * TotalFinalLAConsumption$`Gas - Industrial & Commercial`

TotalFinalLAConsumption$`Gas - Industrial & Commercial` <- NULL

TotalFinalLAConsumption$`Bioenergy & Wastes - Industrial` <- TotalFinalLAConsumption$`Bioenergy & Wastes - Industrial` * TotalFinalLAConsumption$`Bioenergy & wastes - Industrial & Commercial`

TotalFinalLAConsumption$`Bioenergy & Wastes - Commercial` <- TotalFinalLAConsumption$`Bioenergy & Wastes - Commercial` * TotalFinalLAConsumption$`Bioenergy & wastes - Industrial & Commercial`

TotalFinalLAConsumption$`Bioenergy & wastes - Industrial & Commercial` <- NULL

TotalFinalLAConsumption <- TotalFinalLAConsumption[c(1:21,33,34,22:26,35,36,27:32)]

write_csv(TotalFinalLAConsumption, "Output/Consumption/TotalFinalConsumption.csv")


### Statistics.gov.scot

FinalConsumptionScotStat <- melt(TotalFinalLAConsumption, id.vars = c("LA Code", "Year", "Region"))


FinalConsumptionScotStat <- FinalConsumptionScotStat[which(substr(FinalConsumptionScotStat$`LA Code`,1,1) == "S"),]

FinalConsumptionScotStat <- FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Region` != "SCOTLAND"),]

FinalConsumptionScotStat <- separate(FinalConsumptionScotStat, 4, c("Energy Type", "Energy Consuming Sector"), sep = "-")

FinalConsumptionScotStat$Measurement <- "Count"

FinalConsumptionScotStat$Units <- "GWh"

FinalConsumptionScotStat$Region <- NULL

names(FinalConsumptionScotStat) <- c("FeatureCode", "DateCode", "Energy Type", "Energy Consuming Sector", "Value", "Measurement", "Units")

FinalConsumptionScotStat$`Energy Consuming Sector` <- trimws(FinalConcumptionScotStat$`Energy Consuming Sector`)

FinalConsumptionScotStat$`Energy Type` <- trimws(FinalConcumptionScotStat$`Energy Type`)

FinalConsumptionScotStat[which(FinalConsumptionScotStat$`Energy Consuming Sector` %in% c("Industrial","Commercial", "Industrial & Commercial", "Industry & Commercial")),]$`Energy Consuming Sector` <- "Industrial & Commercial"

FinalConsumptionScotStat <- FinalConsumptionScotStat %>% group_by(FeatureCode, DateCode,Measurement, Units,`Energy Type`, `Energy Consuming Sector`) %>% summarise(Value = sum(Value))

unique(FinalConsumptionScotStat$`Energy Consuming Sector`)

write_csv(FinalConsumptionScotStat, "Output/Consumption/ScotStatConsumption.csv")
