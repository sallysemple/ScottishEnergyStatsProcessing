library(readr)
library(readxl)
library(dplyr)

print("OilShelf")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source Data ###
OilShelf <- read_excel("Data Sources/OilShelf/Current.xlsx",
                       skip = 2)

### Create Subset where year is four characters long ###
OilShelf <- subset(OilShelf, nchar(OilShelf$Year) == 4)

### Export to CSV ###
write.table(
  OilShelf,
  "R Data Output/OilShelf.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)