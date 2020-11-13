library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)

print("Population")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source Excel Sheet, skipping unecessary rows from top ###
Population <- read_excel("Data Sources/Population/Current.xls",
                         sheet = "MYE4 ",
                         skip = 5)

### Rename First Column Year ###
colnames(Population)[1] <- "Year"

### Extract the 4 characters that represent the year ###
Population$Year <- substring(Population$Year, 5, 8)

### Remove Last Two Rows from Data ###
Population <- head(Population, -2)

### Export to CSV ###
write.table(
  Population,
  "R Data Output/Population.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)