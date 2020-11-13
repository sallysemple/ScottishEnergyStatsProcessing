library(readr)
library(readxl)
library(dplyr)
library(tidyverse)
library(reshape2)
library("readODS")
library(tidyr)

print("ElecHEat")

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

ElecHeat <- read_excel("Data Sources/ECUK/Current.xlsx", 
                      sheet = "Table U2")

write.table(
  ElecHeat,
  "R Data Output/ElecHeat.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)