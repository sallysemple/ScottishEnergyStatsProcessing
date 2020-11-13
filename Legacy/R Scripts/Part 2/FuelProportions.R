### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Load Required Packages ###
library(readr)
library(zoo)
library(lubridate)
library(plyr)
library(dplyr)
library(data.table)

print("FuelProportions")


ScotlandHalfHourlyDemand <-
  fread(
    "J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/R Data Output/HalfHourlyDemand.csv"
  )


ScotlandHalfHourlyDemand$Period <-
  ymd_hms(ScotlandHalfHourlyDemand$Period)

ScotlandHalfHourlyDemand$Quarter <-
  as.yearqtr(ScotlandHalfHourlyDemand$Period)

ScotlandHalfHourlyDemand <-
  ScotlandHalfHourlyDemand %>% group_by(Quarter) %>%
  summarise(
    Biomass = sum(BiomassValue, na.rm = TRUE),
    Coal = sum(CoalValue, na.rm = TRUE),
    Gas = sum(GasValue, na.rm = TRUE),
    Hydro = sum(HydroValue, na.rm = TRUE),
    Imports = sum(ImportsValue, na.rm = TRUE),
    Nuclear = sum(NuclearValue, na.rm = TRUE),
    Other = sum(OtherValue, na.rm = TRUE),
    Solar = sum(SolarValue, na.rm = TRUE),
    Wind = sum(WindValue, na.rm = TRUE),
    Total = sum(Total, na.rm = TRUE)
  )

### Export to CSV ###
write.table(
  ScotlandHalfHourlyDemand,
  "R Data Output/QuarterlyFuelProportion.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)



GBHalfHourlyDemand <-
  fread(
    "J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/R Data Output/GBHalfHourlyDemand.csv"
  )


GBHalfHourlyDemand$Period <-
  ymd_hms(GBHalfHourlyDemand$Period)

GBHalfHourlyDemand$Quarter <-
  as.yearqtr(GBHalfHourlyDemand$Period)

GBHalfHourlyDemand <-
  GBHalfHourlyDemand %>% group_by(Quarter) %>%
  summarise(
    Biomass = sum(BiomassValue, na.rm = TRUE),
    Coal = sum(CoalValue, na.rm = TRUE),
    Gas = sum(GasValue, na.rm = TRUE),
    Hydro = sum(HydroValue, na.rm = TRUE),
    Imports = sum(ImportsValue, na.rm = TRUE),
    Nuclear = sum(NuclearValue, na.rm = TRUE),
    Other = sum(OtherValue, na.rm = TRUE),
    Solar = sum(SolarValue, na.rm = TRUE),
    Wind = sum(WindValue, na.rm = TRUE),
    Total = sum(Total, na.rm = TRUE)
  )

write.table(
  GBHalfHourlyDemand,
  "R Data Output/QuarterlyFuelProportionEW.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
