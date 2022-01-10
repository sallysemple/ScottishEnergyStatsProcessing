library(readxl)
library(plyr)
library(dplyr)
library(readr)
library("writexl")
library(lubridate)
library(reshape2)
library(tidyverse)

print("PipelineByTech")

source("Processing Scripts/PipelineCapbyTech.R")

REPD <- REPD[c(1,5)]

PipelineMultipliers <- read_csv("Data Sources/MANUAL/PipelineMultipliers.csv")[1:2]

names(PipelineMultipliers) <- c("Type", "PipelineGen")

PipelineGen <- merge(REPD, PipelineMultipliers, all.x = TRUE)

PipelineGen$PipelineGen <- PipelineGen$Total * PipelineGen$PipelineGen

write_csv(PipelineGen, "Output/REPD (Operational Corrections)/PipelineGenbyTech.csv")

