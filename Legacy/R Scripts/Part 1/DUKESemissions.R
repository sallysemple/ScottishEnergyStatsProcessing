library(readxl)
library (dplyr)
library (lubridate)

print("DUKESemissions")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source Data ###
DUKESemissions <-
  read_excel("Data Sources/DUKES Emissions/Current.xlsx",
             skip = 2,
             n_max = 4)

### Export to CSV ###
write.table(
  DUKESemissions,
  "R Data Output/DUKESemissions.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)