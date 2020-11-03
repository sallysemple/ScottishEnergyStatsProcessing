library(readxl)
library(readr)
library(plyr)
library(dplyr)
library(reshape2)

RenHeatCapOutput <- read_excel("Data Sources/MANUAL/RenHeatCapOutput.xlsx")

RenHeatCapOutput <- RenHeatCapOutput[c(8,1:7)]

write.table(RenHeatCapOutput,
            "Output/Renewable Heat/RenHeatCapOutput.txt",
            sep = "\t",
            row.names = FALSE)


RenHeatEnergyFromWaste <- read_excel("Data Sources/MANUAL/RenHeatEnergyFromWaste.xlsx")

RenHeatEnergyFromWaste <- RenHeatEnergyFromWaste[c(6,1:5)]

write.table(RenHeatEnergyFromWaste,
            "Output/Renewable Heat/RenHeatEnergyFromWaste.txt",
            sep = "\t",
            row.names = FALSE)

RenHeatSize <- read_excel("Data Sources/MANUAL/RenHeatSize.xlsx")

RenHeatSize <- RenHeatSize[c(8,1:7)]

write.table(RenHeatSize,
            "Output/Renewable Heat/RenHeatSize.txt",
            sep = "\t",
            row.names = FALSE)

RenHeatLA <- read_excel("Data Sources/MANUAL/RenHeatCapLA.xlsx")

RenHeatLA <- melt(RenHeatLA)

write.table(RenHeatLA,
            "Output/Renewable Heat/RenHeatLA.txt",
            sep = "\t",
            row.names = FALSE)
