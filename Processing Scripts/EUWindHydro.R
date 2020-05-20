library(readxl)
library(tidyverse)

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


write.table(
  EUHydro,
  "Output/EU Wind Hydro/EUHydro.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)