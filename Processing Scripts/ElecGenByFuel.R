library(plyr)
library(dplyr)
library(readr)
library(readxl)
library(tidyverse)
library(reshape2)
library(readr)
library(lubridate)
library(zoo)
library(magrittr)

print("ElecGenByFuel")

### Load Regional generation Data
Fuel <- read_excel(
  "Data Sources/Regional Generation/Regional Generation.xlsx",
  col_names = TRUE,
  sheet = "Electricity generation by fuel",
  skip = 5,
  n_max = 35
)

Fuel[3:ncol(Fuel)] %<>% lapply(function(x) as.numeric(as.character(x)))

Fuel[Fuel == "Wind [Note 1]"] <- "Wind"
Fuel[Fuel == "Bioenergy [Note 2]"] <- "Bioenergy"
Fuel[Fuel == "Oil [Note 3]"] <- "Oil"
Fuel[Fuel == "Other fuels [Note 3][Note 4]"] <- "Other fuels"
Fuel[Fuel == "Other fuels [note 3][note 4]"] <- "Other fuels"
Fuel[Fuel == "Fossil fuels [Note 5]"] <- "Fossil fuels"
Fuel[Fuel == "Renewables [Note 6]"] <- "Renewables"

Fuel <- melt(Fuel)

Fuel <- Fuel %>%  separate(variable, c("Year", "Country"))

Fuel[Fuel == "Northern"] <- "Nothern Ireland"

write_csv(Fuel, "Output/Electricity Generation/RegionalGeneration.csv")

AllFuel <- Fuel[which(Fuel$`Generator type` == 'All generating companies'),]

ScotlandFuel <- AllFuel[which(AllFuel$`Country` == 'Scotland'),]
EWFuel <- AllFuel[which(AllFuel$`Country` %in% c('England', 'Wales')),]

ScotlandFuel <- dcast(ScotlandFuel, Year ~ Fuel)
EWFuel <-dcast(EWFuel, Year ~ Fuel, sum)

ScotlandFuel$'Low Carbon' <- ScotlandFuel$Renewables + ScotlandFuel$Nuclear + ScotlandFuel$`Pumped storage`

ScotlandFuel <- select(ScotlandFuel,
                       "Year",
                       "Hydro natural flow",
                       "Wind",
                       "Shoreline wave and tidal",
                       "Solar",
                       "Bioenergy",
                       "Renewables",
                       "Nuclear",
                       "Pumped storage",
                       "Low Carbon",
                       "Coal",
                       "Oil",
                       "Gas",
                       "Fossil fuels",
                       "Other fuels",
                       "Total all generating companies")


names(ScotlandFuel) <- c("Year",	"Hydro",	"Wind",	"Wave / tidal",	"Solar PV",	"Bioenergy and Waste",	"Renewables",	"Nuclear", "Pumped hydro",	"Low Carbon",	"Coal",	"Oil",	"Gas",	"Fossil Fuels",	"Other",	"Total")

EWFuel$'Low Carbon' <- EWFuel$Renewables + EWFuel$Nuclear + EWFuel$`Pumped storage`

EWFuel <- select(EWFuel,
                       "Year",
                       "Hydro natural flow",
                       "Wind",
                       "Shoreline wave and tidal",
                       "Solar",
                       "Bioenergy",
                       "Renewables",
                       "Nuclear",
                       "Pumped storage",
                       "Low Carbon",
                       "Coal",
                       "Oil",
                       "Gas",
                       "Fossil fuels", 
                       "Other fuels",
                       "Total all generating companies")


names(EWFuel) <- c("Year",	"Hydro",	"Wind",	"Wave / tidal",	"Solar PV",	"Bioenergy and Waste",	"Renewables",	"Nuclear","Pumped hydro",	"Low Carbon",	"Coal",	"Oil",	"Gas",	"Fossil Fuels",	"Other",	"Total")

write_csv(ScotlandFuel, "Output/Electricity Generation/ScotlandFuelElecGen.csv")
write_csv(EWFuel, "Output/Electricity Generation/EWFuelElecGen.csv")

ScotlandProportion <- ScotlandFuel

for(i in 2:16){
  ScotlandProportion[i] <- ScotlandProportion[i] / ScotlandProportion[16]
}

EWProportion <- EWFuel

for(i in 2:16){
  EWProportion[i] <- EWProportion[i] / EWProportion[16]
}

write_csv(ScotlandProportion, "Output/Electricity Generation/ScotlandFuelElecGenProportion.csv")
write_csv(EWProportion, "Output/Electricity Generation/EWFuelElecGenProportion.csv")
