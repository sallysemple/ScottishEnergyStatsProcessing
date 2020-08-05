library(readxl)
library(readr)

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