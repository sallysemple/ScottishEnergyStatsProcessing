library(readr)
library(readxl)
library(dplyr)
library(tidyverse)
library(reshape2)
library("readODS")
library(tidyr)


print("FuelPovertyEPC")

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

FuelPovertyEPC <- read_excel("Data Sources/Fuel Poverty EPC/Current.xlsx", 
                               sheet = "Analysis",skip = 2, n_max = 7)

write.table(
  FuelPovertyEPC,
  "R Data Output/FuelPovertyEPC.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
