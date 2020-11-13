library(readr)
library(readxl)
library(plyr)
library(dplyr)
library(tidyverse)
library(reshape2)
library("readODS")
library(tidyr)

print("SHCS")

ColumnTimeSeries <- function(x,y) {
  
  if(names(x)[1] == "X__1"){names(x)[1] <- "Result"}
  
  x <- x %>% select(-contains("X_"))
  
  x[2:ncol(x)] <- lapply(x[2:ncol(x)], as.numeric)
  
  TimeSeries <- read_csv(paste("Data Sources/Scottish Household Condition Survey/Time Series/", y, ".csv", sep=""))
  
  x <- cbind(x, TimeSeries)
  
  x <- x[, !duplicated(colnames(x))]
  
  x <- x %>% select(-contains("X_"))
}


setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

EnergyMonitor <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 43",
    skip = 3
  )

EnergyMonitor <- ColumnTimeSeries(EnergyMonitor, "EnergyMonitor")

write.table(
  EnergyMonitor,
  "R Data Output/EnergyMonitor.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)

EnergyMonitorDevices <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 44",
    skip = 2
  )

write.table(
  EnergyMonitorDevices,
  "R Data Output/EnergyMonitorDevices.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)

FuelPoverty <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 29",
    skip = 2
  )

write.table(
  FuelPoverty,
  "R Data Output/FuelPoverty.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

CavityWallInsulation <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 11",
    skip = 2
  )
CavityWallInsulation <- head(CavityWallInsulation, 4)
CavityWallInsulation <- tail(CavityWallInsulation,-1)

CavityWallInsulation <- ColumnTimeSeries(CavityWallInsulation, "CavityWallInsulation")

write.table(
  CavityWallInsulation,
  "R Data Output/CavityWallInsulation.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


SolidWallInsulation <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 12",
    skip = 2
  )


SolidWallInsulation <- head(SolidWallInsulation, 4)
SolidWallInsulation <- tail(SolidWallInsulation,-1)

SolidWallInsulation <- ColumnTimeSeries(SolidWallInsulation,"SolidWallInsulation")

write.table(
  SolidWallInsulation,
  "R Data Output/SolidWallInsulation.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

LoftInsulation <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 9",
    skip = 2
  )

LoftInsulation <- head(LoftInsulation,-3)

LoftInsulation <- ColumnTimeSeries(LoftInsulation, "LoftInsulation")
write.table(
  LoftInsulation,
  "R Data Output/LoftInsulation.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

Boilers <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 14",
    skip = 2
  )
Boilers <- tail(Boilers,-1)
Boilers <- head(Boilers,-1)

Boilers <- ColumnTimeSeries(Boilers, "Boilers")

write.table(
  Boilers,
  "R Data Output/Boilers.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

EERSAP2009 <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 15",
    skip = 2,
    n_max = 2
  )

EERSAP2009[1] <- NULL

EERSAP2009 <- EERSAP2009[2, ]

EERSAP2009 <- ColumnTimeSeries(EERSAP2009, "EERSAP2009")

### Export to CSV ###
write.table(
  EERSAP2009,
  "R Data Output/EERSAP2009.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
EERSAP2012 <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 17",
    skip = 2,
    n_max = 2
  )

EERSAP2012[1] <- NULL

EERSAP2012 <- EERSAP2012[2, ]

EERSAP2012 <- ColumnTimeSeries(EERSAP2012, "EERSAP2012")

### Export to CSV ###
write.table(
  EERSAP2012,
  "R Data Output/EERSAP2012.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

EPCSAP2009 <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 16",
    skip = 2,
    n_max = 9
  )

EPCSAP2009 <- EPCSAP2009[-1, ]

EPCSAP2009 <- ColumnTimeSeries(EPCSAP2009, "EPCSAP2009")

### Export to CSV ###
write.table(
  EPCSAP2009,
  "R Data Output/EPCSAP2009.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


EPCSAP2012 <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 18",
    skip = 3,
    n_max = 9
  )

EPCSAP2012 <- EPCSAP2012[-1, ]

EPCSAP2012 <- ColumnTimeSeries(EPCSAP2012, "EPCSAP2012")

### Export to CSV ###
write.table(
  EPCSAP2012,
  "R Data Output/EPCSAP2012.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)




### Read Source Data
HeatingFuel <-
  read_excel("Data Sources/Scottish Household Condition Survey/Current.xlsx",
             sheet = "Table 5",
             skip = 1)

### Write CSV
write.table(
  HeatingFuel,
  "R Data Output/HeatingFuel.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### Read Source Data ###
PrimaryFuel <-
  read_excel(
    "Data Sources/Scottish Household Condition Survey/Current.xlsx",
    sheet = "Table 36",
    skip = 2
  )
### Remove unecessary rows ###
PrimaryFuel <- PrimaryFuel[-c(1:14, 24:38),-1]

PrimaryFuel[10, 1] <- "Total"


### Export to CSV ###
write.table(
  PrimaryFuel,
  "R Data Output/PrimaryFuel.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

Impact <-
  read_excel(
    "Data Sources/Impact of Measures/Current.xlsx",
    sheet = "Table C1",
    col_names = FALSE,
    skip = 5
  )

year = as.numeric(Impact[1, 3])
Impact <- Impact[complete.cases(Impact),]

Impact$Year <- NA
for (row in 1:nrow(Impact)) {
  if (Impact[row, 'X__1'] == "Cavity wall insulation") {
    Impact$Year[row] <- year
    year <- year + 1
  }
}

Impact <- fill(Impact, Year)

names(Impact) <-
  c("Insulation",
    "Average",
    "Sample",
    "% saving",
    "Reduction",
    "Year")

Impact$Reduction <- as.numeric(Impact$Reduction)

Impact$`% saving` <- as.numeric(Impact$`% saving`)

ImpactConReduct <-
  subset(Impact,
         Average == "Median",
         select = c('Year', 'Insulation', 'Reduction'))


ImpactConReduct <- dcast(ImpactConReduct, Year ~ Insulation, sum)

write.table(
  ImpactConReduct,
  "R Data Output/ImpactReduction.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)



ImpactPercentage <-
  subset(Impact,
         Average == "Median",
         select = c('Year', 'Insulation', '% saving'))


ImpactPercentage <- dcast(ImpactPercentage, Year ~ Insulation, sum)

write.table(
  ImpactPercentage,
  "R Data Output/ImpactPercentage.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

