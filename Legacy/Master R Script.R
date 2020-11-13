##################################################################################
## This Script brings together the other scripts used to process the tables and ##
## datasets for the Quarterly Targets publication. These output CSV files that  ##
## are linked to an excel file for the final calculations, tables and charts.   ##
##                                                                              ##
## Splitting the scripts in this way allows the code to be more readable, and   ##
## any changes that are required should be easier to implement in the specific  ##
## R Script. This makes testing easier too.                                     ##
##################################################################################
start.time <- Sys.time()
library(readr)
library(readxl)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(lubridate)
library(writexl)
library(data.table)
library(tidyverse)
library(plotly)
### Set the Working Directory for the Scripts ###

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

###### Run all scripts in /R scripts Folder #######

### Create List of Scripts, including filepath ###
Scripts <- list.files("R Scripts", full.names=TRUE,recursive = TRUE)

### Pass Each list item to Source() command ###

sapply(Scripts, source)

### All done ###

ElecDemandHalfHourly <- fread("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/R Data Output/ElecDemandHalfHourly.csv")

names(ElecDemandHalfHourly) <- c("sd", "sp", "DEMAND", "Quarter")

ElecDemandHalfHourly <- ElecDemandHalfHourly[complete.cases(ElecDemandHalfHourly), ]

Midnight <- ymd_hms("01/01/01 00:00:00")
HalfHour <- hms("00:30:00")

ElecDemandHalfHourly$Time <- ((ElecDemandHalfHourly$sp - 1) * HalfHour)+ Midnight

ElecDemandHalfHourly$Time <- substring(ElecDemandHalfHourly$Time, 12, 20)


ElecDemandHalfHourly$Time <- paste(ElecDemandHalfHourly$sd,ElecDemandHalfHourly$Time)

ElecDemandHalfHourly$Time <- ymd_hms(ElecDemandHalfHourly$Time)

ElecDemandHalfHourly <- ElecDemandHalfHourly[order(ElecDemandHalfHourly$Time),]

plot_ly(ElecDemandHalfHourly, x = ~ Time, y = ~ DEMAND, mode = "lines", type = "scatter"  )

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken