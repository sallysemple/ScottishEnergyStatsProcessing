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
                         skip = 6, n_max = 33)
#Transpose Data Frame
UKRenElecGen <- as.data.frame(t(UKRenElecGen))

#Name Columns based on first row
names(UKRenElecGen) <- unlist(UKRenElecGen[1,])

#Name First COlumn Y
names(UKRenElecGen)[1] <- c("Y")

#Extract Year and Quarter into own column (source data has invisible symbols in the first column)
UKRenElecGen$Quarter <- paste0(substr(UKRenElecGen$Y,1,4), " Q", substr(UKRenElecGen$Y,8,8))

#Convert all but the first and last columns to numeric
UKRenElecGen[2:33] %<>% lapply(function(x) as.numeric(as.character(x)))

#Convert Data Frame to Tibble, keeping only important columns
UKRenElecGen <- as_tibble(UKRenElecGen[c(34,20:33)])

#Drop Rows without Data
UKRenElecGen <- UKRenElecGen[complete.cases(UKRenElecGen),]

#Convert Quartr Column to time format
UKRenElecGen$Quarter <- as.yearqtr(UKRenElecGen$Quarter)

#Give Columns final names
names(UKRenElecGen) <- c("Quarter", "Onshore Wind", "Offshore Wind", "Shoreline wave / tidal", "Solar photovoltaics", "Hydro", "Landfill gas", "Sewage sludge digestion", "Energy from Waste","Co-firing with fossil fuels", "Animal Biomass", "Anaerobic Digestion", "Plant Biomass", "Liquid Biofuels", "Total")

#Export
write.csv(UKRenElecGen,
          "Output/Renewable Generation/QTRGenUK.csv",
          row.names = FALSE)

###Scotland Proportion

source("Processing Scripts/QtrRenGen.R")

RenElecGen$Wind <- RenElecGen$`Onshore Wind` + RenElecGen$`Offshore Wind`

UKRenElecGen$`Other Biomass` <- UKRenElecGen$`Energy from Waste`+UKRenElecGen$`Co-firing with fossil fuels`+UKRenElecGen$`Animal Biomass`+UKRenElecGen$`Anaerobic Digestion`+UKRenElecGen$`Plant Biomass`

UKRenElecGen$Wind <- UKRenElecGen$`Onshore Wind` + UKRenElecGen$`Offshore Wind`

GBRenElecGen <- UKRenElecGen

UKRenElecGen$Year <- substr(UKRenElecGen$Quarter,1,4)

UKRenElecGen$Quarter <- NULL

UKRenElecGen <- select(UKRenElecGen, names(RenElecGen))



UKRenElecGen <- UKRenElecGen %>% group_by(Year) %>%  summarise_all(sum)

UKRenElecGen <- UKRenElecGen[which(UKRenElecGen$Year %in% RenElecGen$Year),]


ScottishRenPropofUK <- RenElecGen

ScottishRenPropofUK[2:11] <- ScottishRenPropofUK[2:11] / UKRenElecGen[2:11]


write_csv(ScottishRenPropofUK, "Output/Renewable Generation/ScotPropofUKRenGen.csv")


### GB Proportions



#Read Source Data
NIRenElecGen <- read_excel("Data Sources/Energy Trends/RenGenCap.xlsx", 
                           sheet = "Northern Ireland - Qtr", col_names = FALSE, 
                           skip = 6, n_max = 33)
#Transpose Data Frame
NIRenElecGen <- as.data.frame(t(NIRenElecGen))

#Name Columns based on first row
names(NIRenElecGen) <- unlist(NIRenElecGen[1,])

#Name First COlumn Y
names(NIRenElecGen)[1] <- c("Y")

#Extract Year and Quarter into own column (source data has invisible symbols in the first column)
NIRenElecGen$Quarter <- paste0(substr(NIRenElecGen$Y,1,4), " Q", substr(NIRenElecGen$Y,8,8))

#Convert all but the first and last columns to numeric
NIRenElecGen[2:33] %<>% lapply(function(x) as.numeric(as.character(x)))

#Convert Data Frame to Tibble, keeping only important columns
NIRenElecGen <- as_tibble(NIRenElecGen[c(34,19:26)])

#Drop Rows without Data
NIRenElecGen <- NIRenElecGen[complete.cases(NIRenElecGen),]

#Convert Quartr Column to time format
NIRenElecGen$Quarter <- as.yearqtr(NIRenElecGen$Quarter)

#Give Columns final names
names(NIRenElecGen) <- c("Quarter", "Onshore Wind", "Offshore Wind", "Shoreline wave / tidal", "Solar photovoltaics", "Hydro", "Landfill gas", "Sewage sludge digestion", "Other Biomass", "Total")

#Calculate NI Wind
NIRenElecGen$Wind <- NIRenElecGen$`Onshore Wind` + NIRenElecGen$`Offshore Wind`

#Keep only quarters that are also in NI's data
GBRenElecGen <- GBRenElecGen[which(GBRenElecGen$Quarter %in% NIRenElecGen$Quarter),]

#Select only columns also in NI, to make dataframes match
GBRenElecGen <- select(GBRenElecGen, names(NIRenElecGen))

#Take NI figures away from UK figures, to give GB figures
GBRenElecGen[2:10] <- GBRenElecGen[2:10] - NIRenElecGen[2:10]


#Export
write.csv(GBRenElecGen,
          "Output/Renewable Generation/QTRGenGB.csv",
          row.names = FALSE)
