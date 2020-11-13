### Load Packages
library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)

print("HeatingFuel")

### Set Working Directory
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source Data
HeatingFuel <-
  read_excel("Data Sources/Scottish Household Condition Survey/Current.xlsx",
             sheet = "Table 5")

### Write CSV
write.table(
  HeatingFuel,
  "R Data Output/HeatingFuel.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
