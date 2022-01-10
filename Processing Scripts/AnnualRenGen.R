library(readxl)
library(plyr)
library(dplyr)
library(tidyverse)
library(magrittr)
library(data.table)

print("AnnualRenGen")

source("Processing Scripts/RenElecTgt.R")

OldAnnualRenGen <- read_csv("Data Sources/MANUAL/OldAnnualRenGen.csv")


RenGen <- merge(OldAnnualRenGen, RenElecGen, all = TRUE)

write_csv(RenGen,
            "Output/Renewable Generation/Annual.csv")
