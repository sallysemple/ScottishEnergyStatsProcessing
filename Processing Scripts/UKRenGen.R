library(tidyverse)
library(plyr)
library(dplyr)
library(magrittr)
library(lubridate)
library(zoo)
library(readxl)

print("QTRRenGen")


#Read Source Data
UKRenElecGen <- read_excel("Data Sources/Energy Trends/RenGenCap.xlsx", 
                         sheet = "Quarter", col_names = FALSE, 
                         skip = 6, n_max = 32)
#Transpose Data Frame
UKRenElecGen <- as.data.frame(t(UKRenElecGen))

#Name Columns based on first row
names(UKRenElecGen) <- unlist(UKRenElecGen[1,])

#Name First COlumn Y
names(UKRenElecGen)[1] <- c("Y")

#Extract Year and Quarter into own column (source data has invisible symbols in the first column)
UKRenElecGen$Quarter <- paste0(substr(UKRenElecGen$Y,1,4), " Q", substr(UKRenElecGen$Y,8,8))

#Convert all but the first and last columns to numeric
UKRenElecGen[2:31] %<>% lapply(function(x) as.numeric(as.character(x)))

#Convert Data Frame to Tibble, keeping only important columns
UKRenElecGen <- as_tibble(UKRenElecGen[c(32,18:30)])

#Drop Rows without Data
UKRenElecGen <- UKRenElecGen[complete.cases(UKRenElecGen),]

#Convert Quartr Column to time format
UKRenElecGen$Quarter <- as.yearqtr(UKRenElecGen$Quarter)

#Give Columns final names
names(UKRenElecGen) <- c("Quarter", "Onshore Wind", "Offshore Wind", "Shoreline wave / tidal", "Solar photovoltaics", "Hydro", "Landfill gas", "Sewage sludge digestion", "Energy from Waste","Co-firing with fossil fuels", "Animal Biomass", "Anaerobic Digestion", "Plant Biomass", "Total")

#Export
write.csv(UKRenElecGen,
          "Output/Renewable Generation/QTRGenUK.csv",
          row.names = FALSE)

###Scotland Proportion

source("Processing Scripts/QtrRenGen.R")

RenElecGen$Wind <- RenElecGen$`Onshore Wind` + RenElecGen$`Offshore Wind`

UKRenElecGen$Year <- substr(UKRenElecGen$Quarter,1,4)

UKRenElecGen$Quarter <- NULL

UKRenElecGen$`Other Biomass` <- UKRenElecGen$`Energy from Waste`+UKRenElecGen$`Co-firing with fossil fuels`+UKRenElecGen$`Animal Biomass`+UKRenElecGen$`Anaerobic Digestion`+UKRenElecGen$`Plant Biomass`

UKRenElecGen$Wind <- UKRenElecGen$`Onshore Wind` + UKRenElecGen$`Offshore Wind`

UKRenElecGen <- select(UKRenElecGen, names(RenElecGen))

UKRenElecGen <- UKRenElecGen %>% group_by(Year) %>%  summarise_all(sum)

UKRenElecGen <- UKRenElecGen[which(UKRenElecGen$Year %in% RenElecGen$Year),]


ScottishRenPropofUK <- RenElecGen

ScottishRenPropofUK[2:11] <- ScottishRenPropofUK[2:11] / UKRenElecGen[2:11]


write_csv(ScottishRenPropofUK, "Output/Renewable Generation/ScotPropofUKRenGen.csv")