library(readxl)
library(tidyverse)

print("GrowthExports")

UKEnergyExports <- read_excel("Data Sources/Growth Sector Statistics/GS+database.xlsx", 
                              sheet = "Table 5.1", col_names = FALSE, 
                              skip = 6)

UKEnergyExports <- as_tibble(t(UKEnergyExports))[c(1,9)]

names(UKEnergyExports) <- c("Year", "UKExports")

UKEnergyExports$Year <- as.numeric(UKEnergyExports$Year)

UKEnergyExports$UKExports <- as.numeric(UKEnergyExports$UKExports)/1000

UKEnergyExports <- UKEnergyExports[complete.cases(UKEnergyExports),]


EUEnergyExports <- read_excel("Data Sources/Growth Sector Statistics/GS+database.xlsx", 
                          sheet = "Table 5.3", col_names = FALSE, 
                          skip = 6)

EUEnergyExports <- as_tibble(t(EUEnergyExports))[c(1,9)]

names(EUEnergyExports) <- c("Year", "EUExports")

EUEnergyExports$Year <- as.numeric(EUEnergyExports$Year)

EUEnergyExports$EUExports <- as.numeric(EUEnergyExports$EUExports)/1000

EUEnergyExports <- EUEnergyExports[complete.cases(EUEnergyExports),]

NonEUEnergyExports <- read_excel("Data Sources/Growth Sector Statistics/GS+database.xlsx", 
                              sheet = "Table 5.4", col_names = FALSE, 
                              skip = 6)

NonEUEnergyExports <- as_tibble(t(NonEUEnergyExports))[c(1,9)]

names(NonEUEnergyExports) <- c("Year", "NonEUExports")

NonEUEnergyExports$Year <- as.numeric(NonEUEnergyExports$Year)

NonEUEnergyExports$NonEUExports <- as.numeric(NonEUEnergyExports$NonEUExports)/1000

NonEUEnergyExports <- NonEUEnergyExports[complete.cases(NonEUEnergyExports),]

GrowthExports <- merge(UKEnergyExports, merge(EUEnergyExports, NonEUEnergyExports))

write.table(GrowthExports,
            "Output/Growth Exports/GrowthExports.txt",
            sep = "\t",
            row.names = FALSE)
