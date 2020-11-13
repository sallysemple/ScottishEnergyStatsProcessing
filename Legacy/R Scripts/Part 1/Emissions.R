### Load Packages ###
library(readr)
library(readxl)
library(dplyr)

print("Emissions")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Load Greenhouse Gas Emissions Data ###
Emissions <-
  read_excel(
    "Data Sources/Greenhouse Gas Emissions/Current.xlsx",
    sheet = "Table B2",
    skip = 1
  )

### Reverse the order of the columns, so latest year is first ###
Emissions <- Emissions[, rev(seq_len(ncol(Emissions)))]

### Drop the unnecessary column ###
Emissions <- Emissions[-c(1:4)]

### Move the Source Sector colum to the start, for readability ###
Emissions <- select(Emissions, "Source Sector", everything())

### Export to CSV ###
write.table(
  Emissions,
  "R Data Output/Emissions.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)