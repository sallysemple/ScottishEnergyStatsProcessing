### Load Required Packages ###
library(readxl)
library(readr)

print("EU Reneables")

### Load Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

###### GROSS RENEWABLE FINAL ENERGY CONSUMPTION ######

### Load Source Data ###
EURenewables <-
  read_excel(
    "Data Sources/EU Renewable Energy/Current.xls",
    sheet = "Data",
    skip = 8,
    n_max = 29
  )

### Rename EU and Germany to be consistent ###
EURenewables[1, 1] <- "EU (28)"
EURenewables[6, 1] <- "Germany"

### Load Targets Data ###
EUTargets <-
  read_csv("Data Sources/EU Renewable Energy/EUTargets.csv")

### Merge both Datasets ###
EURenewables <-
  merge(EUTargets,
        EURenewables,
        by = c("GEO/TIME"),
        all = TRUE)

write.table(
  EURenewables,
  "R Data Output/EURenewables.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Share of renewable energy in electricity ######

EUElecRenew <-
  read_excel(
    "Data Sources/EU Renewable Energy/Current.xls",
    sheet = "Data3",
    skip = 8,
    n_max = 29
  )

EUElecRenew[1, 1] <- "EU (28)"
EUElecRenew[6, 1] <- "Germany"

EUElecRenew <-
  merge(EUTargets,
        EUElecRenew,
        by = c("GEO/TIME"),
        all = TRUE)

write.table(
  EUElecRenew,
  "R Data Output/EUElecRenew.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Share of renewable energy in heating and cooling ######

EUHeatRenew <-
  read_excel(
    "Data Sources/EU Renewable Energy/Current.xls",
    sheet = "Data4",
    skip = 8,
    n_max = 29
  )



EUHeatRenew[1, 1] <- "EU (28)"
EUHeatRenew[6, 1] <- "Germany"

EUHeatRenew <-
  merge(EUTargets,
        EUHeatRenew,
        by = c("GEO/TIME"),
        all = TRUE)

write.table(
  EUHeatRenew,
  "R Data Output/EURenewHeat.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)



###### Consumption ######

EUConsumption <-
  read_excel(
    "Data Sources/EU Consumption/Current.xls",
    sheet = "Data",
    skip = 8,
    n_max = 30
  )



EUConsumption[1, 1] <- "EU (28)"
EUConsumption[7, 1] <- "Germany"


write.table(
  EUConsumption,
  "R Data Output/EUConsumption.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Wind ######

EUWind <-
  read_excel(
    "Data Sources/EU Wind Hydro/Current.xls",
    sheet = "Data2",
    skip = 10,
    n_max = 30
  )



EUWind[1, 1] <- "EU (28)"
EUWind[7, 1] <- "Germany"


write.table(
  EUWind,
  "R Data Output/EUWind.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Hydro ######

EUHydro <-
  read_excel(
    "Data Sources/EU Wind Hydro/Current.xls",
    sheet = "Data",
    skip = 10,
    n_max = 30
  )



EUHydro[1, 1] <- "EU (28)"
EUHydro[7, 1] <- "Germany"


write.table(
  EUHydro,
  "R Data Output/EUHydro.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

