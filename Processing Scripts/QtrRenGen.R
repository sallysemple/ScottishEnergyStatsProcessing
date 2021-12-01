library(tidyverse)
library(plyr)
library(dplyr)
library(magrittr)
library(lubridate)
library(zoo)
library(readxl)

print("QTRRenGen")


#Read Source Data
RenElecGen <- read_excel("Data Sources/Energy Trends/RenGenCap.xlsx", 
                        sheet = "Scotland - Qtr", col_names = FALSE, 
                        skip = 6, n_max = 27)
#Transpose Data Frame
RenElecGen <- as.data.frame(t(RenElecGen))

#Name Columns based on first row
names(RenElecGen) <- unlist(RenElecGen[1,])

#Name First COlumn Y
names(RenElecGen)[1] <- c("Y")

#Extract Year and Quarter into own column (source data has invisible symbols in the first column)
RenElecGen$Quarter <- paste0(substr(RenElecGen$Y,1,4), " Q", substr(RenElecGen$Y,8,8))

#Convert all but the first and last columns to numeric
RenElecGen[2:27] %<>% lapply(function(x) as.numeric(as.character(x)))

#Convert Data Frame to Tibble, keeping only important columns
RenElecGen <- as_tibble(RenElecGen[c(28,17:25)])

#Drop Rows without Data
RenElecGen <- RenElecGen[complete.cases(RenElecGen),]

#Convert Quartr Column to time format
RenElecGen$Quarter <- as.yearqtr(RenElecGen$Quarter)

#Give Columns final names
names(RenElecGen) <- c("Quarter", "Onshore Wind", "Offshore Wind", "Shoreline wave / tidal", "Solar photovoltaics", "Hydro", "Landfill gas", "Sewage sludge digestion", "Other Biomass", "Total")

#Export
write.csv(RenElecGen,
            "Output/Renewable Generation/QTRGenScotland.csv",
            row.names = FALSE)

RenElecGenQTR <- RenElecGen


RenElecGen$Year <- as.numeric(substr(RenElecGen$Quarter,1,4))

RenElecGen$Quarter <- substr(RenElecGen$Quarter,6,7)

RenElecYearMax<- max(RenElecGen[which(RenElecGen$Quarter == "Q4"),]$Year)

RenElecGen <- RenElecGen[which(RenElecGen$Year <= RenElecYearMax),]

RenElecGen <- RenElecGen[2:11] %>% group_by(Year) %>% summarise_all(sum)

write.csv(RenElecGen, 
          "Output/Renewable Generation/RenElecGenAnnualTgt.csv",
          row.names = FALSE)
