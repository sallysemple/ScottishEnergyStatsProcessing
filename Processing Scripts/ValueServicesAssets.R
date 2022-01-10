library(readxl)
library(tidyverse)

print("ValueServicesAssets")

FossilFuels <- read_excel("Data Sources/Natural Capital/referencetables.xlsx", 
                                   sheet = "Fossil fuels", col_names = FALSE, 
                                   skip = 2)

FossilFuels <-  as_tibble(t(FossilFuels))

FossilFuels <- FossilFuels[c(1,4,6)]

names(FossilFuels) <- c("Year", "Annual", "Asset")

FossilFuels$Year <- as.numeric(FossilFuels$Year)
FossilFuels$Annual <- as.numeric(FossilFuels$Annual)/1000
FossilFuels$Asset <- as.numeric(FossilFuels$Asset)/1000

FossilFuels <- FossilFuels[complete.cases(FossilFuels),]

write.table(FossilFuels,
            "Output/Services and assets/FossilFuels.txt",
            sep = "\t",
            row.names = FALSE)


Renewables <- read_excel("Data Sources/Natural Capital/referencetables.xlsx", 
                              sheet = "Renewables", col_names = FALSE, 
                              skip = 2)

Renewables <-  as_tibble(t(Renewables))

Renewables <- Renewables[c(1,4,6)]

names(Renewables) <- c("Year", "Annual", "Asset")

Renewables$Year <- as.numeric(Renewables$Year)
Renewables$Annual <- as.numeric(Renewables$Annual)
Renewables$Asset <- as.numeric(Renewables$Asset)/1000

Renewables <- Renewables[complete.cases(Renewables),]

Renewables <- Renewables[which(Renewables$Annual != 0),]

write.table(Renewables,
            "Output/Services and assets/Renewables.txt",
            sep = "\t",
            row.names = FALSE)