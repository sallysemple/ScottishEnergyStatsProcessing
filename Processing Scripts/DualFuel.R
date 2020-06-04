library(readxl)
library(plyr)
library(dplyr)
library(tidyverse)
library(data.table)
library(magrittr)

ElecTariff <- read_excel("Data Sources/Ofgem/Default Tariff/model_-_default_tariff_cap_level_v1.4.xlsx", 
                            sheet = "ElecSingle_nonSC_3100kWh", skip = 11)

ElecTariff <- tail(ElecTariff,-2)

ElecTariff <- ElecTariff[c(-1,-5,-6, -15)]

names(ElecTariff)[1:3] <- c("Category", "Specific", "Region")

ElecTariff$Specific <- substr(ElecTariff$Specific, 1, 5)

ElecTariff <- melt(ElecTariff, id.vars = c("Category", "Specific", "Region"))

names(ElecTariff) <- c("Category", "Specific", "Region", "Dates", "Value")

ElecTariff$Dates <- gsub('–', '-', ElecTariff$Dates)
ElecTariff$Dates <- gsub(' - ', '-', ElecTariff$Dates)
ElecTariff$Dates <- gsub(' -', '-', ElecTariff$Dates)
ElecTariff$Dates <- gsub('- ', '-', ElecTariff$Dates)
ElecTariff$Dates <- gsub('-', ' - ', ElecTariff$Dates)

ElecTariff$Dates <- factor(ElecTariff$Dates, levels = unique(ElecTariff$Dates))

ElecTariff$Value <- as.numeric(ElecTariff$Value)

ElecTariff$Value[is.na(ElecTariff$Value)] <- 0

ElecTariff <- ElecTariff %>% group_by(Category, Region, Dates) %>% 
  summarise(Value = sum(Value))

NSElecTariff <- ElecTariff[which(ElecTariff$Region == "Northern Scotland"),]

NSElecTariff <- dcast(NSElecTariff, Dates ~ Category, value.var = "Value")

NSElecTariff <- NSElecTariff[which(NSElecTariff$Total > 0),]

SSElecTariff <- ElecTariff[which(ElecTariff$Region == "Southern Scotland"),]

SSElecTariff <- dcast(SSElecTariff, Dates ~ Category, value.var = "Value")

SSElecTariff <- SSElecTariff[which(SSElecTariff$Total > 0),]

GasTariff <- read_excel("Data Sources/Ofgem/Default Tariff/model_-_default_tariff_cap_level_v1.4.xlsx", 
                        sheet = "Gas_nonSC_12000kWh", skip = 11)

GasTariff <- tail(GasTariff,-2)

GasTariff <- GasTariff[c(-1,-5,-6, -15)]

names(GasTariff)[1:3] <- c("Category", "Specific", "Region")

GasTariff$Specific <- substr(GasTariff$Specific, 1, 5)

GasTariff <- melt(GasTariff, id.vars = c("Category", "Specific", "Region"))

names(GasTariff) <- c("Category", "Specific", "Region", "Dates", "Value")

GasTariff$Value <- as.numeric(GasTariff$Value)

GasTariff$Value[is.na(GasTariff$Value)] <- 0

GasTariff <- GasTariff %>% group_by(Category, Region, Dates) %>% 
  summarise(Value = sum(Value))

NSGasTariff <- GasTariff[which(GasTariff$Region == "Northern Scotland"),]

NSGasTariff <- dcast(NSGasTariff, Dates ~ Category, value.var = "Value")

NSGasTariff <- NSGasTariff[which(NSGasTariff$Total > 0),]

SSGasTariff <- GasTariff[which(GasTariff$Region == "Southern Scotland"),]

SSGasTariff <- dcast(SSGasTariff, Dates ~ Category, value.var = "Value")

SSGasTariff <- SSGasTariff[which(SSGasTariff$Total > 0),]


NSDualFuel <- NSElecTariff

NSDualFuel[2:8] <- NSElecTariff[2:8] + NSGasTariff[2:8]

NSDualFuel$Total <- NSDualFuel$Total - NSDualFuel$Headroom

NSDualFuel$Headroom <- NULL

NSDualFuel <- NSDualFuel[c(1,7,3,5,4,2,6)]

NSDualFuel[,(2:7)] %<>% sapply(`/`,NSDualFuel[,7])

write.table(NSDualFuel,
            "Output/Energy Bills/NorthScotlandDualFuelBreakdown.txt",
            sep = "\t",
            row.names = FALSE)

SSDualFuel <- SSElecTariff

SSDualFuel[2:8] <- SSElecTariff[2:8] + SSGasTariff[2:8]

SSDualFuel$Total <- SSDualFuel$Total - SSDualFuel$Headroom

SSDualFuel$Headroom <- NULL

SSDualFuel <- SSDualFuel[c(1,7,3,5,4,2,6)]

SSDualFuel[,(2:7)] %<>% sapply(`/`,SSDualFuel[,7])

write.table(SSDualFuel,
            "Output/Energy Bills/SouthScotlandDualFuelBreakdown.txt",
            sep = "\t",
            row.names = FALSE)




