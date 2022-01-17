library(readxl)
library(plyr)
library(dplyr)
library(tidyverse)
library(data.table)
library(magrittr)

print("FixedTariffs")

###Gas

#Read Source Data
GasPaymentMethod <- read_excel("Data Sources/Energy Bills/GasPaymentMethod.xlsx", 
                               sheet = "2.5.2 (Fixed Quarterly)", skip = 13)

#Keep Useful Columns
GasPaymentMethod <- select(GasPaymentMethod,
                           Quarter,
                           Region,
                           "All payment types (%)"
                           )

names(GasPaymentMethod) <- c(Quarter, Region, "Fixed Tariff Proportion")

GasPaymentMethod <- dcast(GasPaymentMethod, Quarter ~ Region)

GasPaymentMethod[2:ncol(GasPaymentMethod)] %<>% lapply(function(x) as.numeric(as.character(x))/100)

write_csv(GasPaymentMethod, "Output/Energy Bills/GasFixedTariff.csv")