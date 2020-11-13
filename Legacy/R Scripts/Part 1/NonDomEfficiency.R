library(readr)
library(readxl)
library(plyr)
library(dplyr)
library(reshape2)

print("NonDomEfficiency")

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

NonDomEfficiency <- read_excel("Data Sources/Non-Dom Energy Efficiency/Current.xlsx", 
                      sheet = "Figures 3 & 4", skip = 3, n_max = 16)

write.table(
  NonDomEfficiency,
  "R Data Output/NonDomEfficiency.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
