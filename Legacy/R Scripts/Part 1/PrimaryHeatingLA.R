library(readr)
library(readxl)
library(dplyr)
library(tidyverse)
library(reshape2)
library("readODS")
library(tidyr)

print("PrimaryHeatingLA")

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

PrimaryHeatingLA <- read_excel("Data Sources/Primary Heating LA/Current.xlsx", 
                      sheet = "analysis", n_max = 35)

write.table(
  PrimaryHeatingLA,
  "R Data Output/PrimaryHeatingLA.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
