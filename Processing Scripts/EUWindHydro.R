library(readxl)
library(tidyverse)
library(magrittr)

print("EUWindHydro")

###### Wind ######

EUWind <- 
  read_excel(
    "Data Sources/Eurostat/EUWindHydro.xls",
    sheet = "Data2",
    skip = 10
  )




EUWind[1, 1] <- "EU (27)"
EUWind[2, 1] <- "EU (28)"
EUWind[3, 1] <- "Euro Area"
EUWind[8, 1] <- "Germany"
EUWind[40, 1] <- "Kosovo"

EUWind[2:ncol(EUWind)] %<>% lapply(function(x) as.numeric(as.character(x)))

source("Processing Scripts/AnnualRenGen.R")

RenGen[is.na(RenGen)] <- 0

RenGen$Wind <- RenGen$`Onshore Wind` +RenGen$`Offshore Wind`

RenGen <- select(RenGen,
                 Year,
                 Wind)

RenGen$`GEO/TIME` <- "SCOTLAND"

EUYearMax <-  max(as.numeric(names(EUWind)), na.rm = TRUE)

RenGen <- RenGen[which(RenGen$Year <= EUYearMax),]

EUWindScotland <- dcast(RenGen, `GEO/TIME` ~ Year, value.var = 'Wind')
EUWind <- bind_rows(EUWind, EUWindScotland)

if(is.na(EUWind[1,ncol(EUWind)])){
  EUWind[ncol(EUWind)] <- NULL
}

#EUWind$`2020` <- NULL

EUWind <- EUWind[complete.cases(EUWind[1], EUWind[ncol(EUWind)]),]

EUWind[is.na(EUWind)] <- 0

EUWind[which(EUWind$`GEO/TIME` == "United Kingdom"),][2:ncol(EUWind)] <- EUWind[which(EUWind$`GEO/TIME` == "United Kingdom"),][2:ncol(EUWind)] - EUWind[which(EUWind$`GEO/TIME` == "SCOTLAND"),][2:ncol(EUWind)]

write.table(
  EUWind,
  "Output/EU Wind Hydro/EUWind.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Hydro ######

EUHydro <- 
  read_excel(
    "Data Sources/Eurostat/EUWindHydro.xls",
    sheet = "Data",
    skip = 10
  )




EUHydro[1, 1] <- "EU (27)"
EUHydro[2, 1] <- "EU (28)"
EUHydro[3, 1] <- "Euro Area"
EUHydro[8, 1] <- "Germany"
EUHydro[40, 1] <- "Kosovo"

EUHydro[2:ncol(EUHydro)] %<>% lapply(function(x) as.numeric(as.character(x)))

source("Processing Scripts/AnnualRenGen.R")

RenGen[is.na(RenGen)] <- 0

RenGen <- select(RenGen,
                 Year,
                 Hydro)

RenGen$`GEO/TIME` <- "SCOTLAND"

EUYearMax <-  max(as.numeric(names(EUWind)), na.rm = TRUE)

RenGen <- RenGen[which(RenGen$Year <= EUYearMax),]

EUHydroScotland <- dcast(RenGen, `GEO/TIME` ~ Year, value.var = 'Hydro')
EUHydro <- bind_rows(EUHydro, EUHydroScotland)

if(is.na(EUHydro[1,ncol(EUHydro)])){
  EUHydro[ncol(EUHydro)] <- NULL
}

#EUHydro$`2020` <- NULL

EUHydro <- EUHydro[complete.cases(EUHydro[1], EUHydro[ncol(EUHydro)]),]

EUHydro[is.na(EUHydro)] <- 0

EUHydro[which(EUHydro$`GEO/TIME` == "United Kingdom"),][2:ncol(EUHydro)] <- EUHydro[which(EUHydro$`GEO/TIME` == "United Kingdom"),][2:ncol(EUHydro)] - EUHydro[which(EUHydro$`GEO/TIME` == "SCOTLAND"),][2:ncol(EUHydro)]

write.table(
  EUHydro,
  "Output/EU Wind Hydro/EUHydro.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

