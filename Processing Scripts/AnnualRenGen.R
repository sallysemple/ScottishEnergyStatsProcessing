library(readxl)
library(plyr)
library(dplyr)
library(tidyverse)
library(magrittr)

RenGen <- read_excel("Data Sources/Energy Trends/RenGenCap.xls", 
                    sheet = "Scotland- Annual", skip = 4)

names(RenGen)[1] <- "Fuel"

for (i in 2:ncol(RenGen)) {
names(RenGen)[i] <- substr(names(RenGen)[i],1,4)
}

RenGen <- RenGen[13:20,]

RenGen[2:ncol(RenGen)] %<>% lapply(function(x) as.numeric(as.character(x)))

RenGen <- as_tibble(RenGen[ , apply(RenGen, 2, function(x) !any(is.na(x)))])

RenGenPreviousYears <- read_csv("Data Sources/Energy Trends/RenGenPreviousYears.csv")

RenGen$Fuel <- c( "Wind", "Wave / tidal", "Solar PV", "Hydro", "Landfill Gas", "Sewage Gas",  "Other biofuels and co-firing", "Total"  )

RenGen <- merge(RenGenPreviousYears, RenGen)

write.table(RenGen,
            "Output/Renewable Generation/Annual.txt",
            sep = "\t",
            row.names = FALSE)