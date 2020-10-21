library(readxl)
library(plyr)
library(dplyr)
library(tidyverse)
library(data.table)
library(magrittr)

print("DualFuel")
ElecTariff <- read_excel("Data Sources/Ofgem/Default Tariff/default_tariff_cap_level_v1.7.xlsx", 
                            sheet = "ElecSingle_Other_3100kWh", skip = 11)

ElecTariff <- tail(ElecTariff,-2)

ElecTariff <- ElecTariff[c(-4,-5,-6, -14)]

names(ElecTariff)[1:3] <- c("Category", "Specific", "Region")

ElecTariff$Specific <- substr(ElecTariff$Specific, 1, 5)

ElecTariff <- melt(ElecTariff, id.vars = c("Category", "Specific", "Region"))

names(ElecTariff) <- c("Category", "Specific", "Region", "Dates", "Value")

ElecTariff$Dates <- gsub('–', '-', ElecTariff$Dates)
ElecTariff$Dates <- gsub(' - ', '-', ElecTariff$Dates)
ElecTariff$Dates <- gsub(' -', '-', ElecTariff$Dates)
ElecTariff$Dates <- gsub('- ', '-', ElecTariff$Dates)
ElecTariff$Dates <- gsub('-', ' - ', ElecTariff$Dates)

ElecTariff <- ElecTariff[which(substr(ElecTariff$Dates,1,1) %in% c("A", "O")),]

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

GasTariff <- read_excel("Data Sources/Ofgem/Default Tariff/default_tariff_cap_level_v1.7.xlsx", 
                        sheet = "Gas_Other_12000kWh", skip = 11)

GasTariff <- tail(GasTariff,-2)

GasTariff <- GasTariff[c(-4,-5,-6, -14)]

names(GasTariff)[1:3] <- c("Category", "Specific", "Region")

GasTariff$Specific <- substr(GasTariff$Specific, 1, 5)

GasTariff <- melt(GasTariff, id.vars = c("Category", "Specific", "Region"))

names(GasTariff) <- c("Category", "Specific", "Region", "Dates", "Value")

GasTariff$Value <- as.numeric(GasTariff$Value)

GasTariff$Value[is.na(GasTariff$Value)] <- 0

GasTariff <- GasTariff[which(substr(GasTariff$Dates,1,1) %in% c("A", "O")),]

GasTariff <- GasTariff %>% group_by(Category, Region, Dates) %>% 
  summarise(Value = sum(Value))

NSGasTariff <- GasTariff[which(GasTariff$Region == "Northern Scotland"),]

NSGasTariff <- dcast(NSGasTariff, Dates ~ Category, value.var = "Value")

NSGasTariff <- NSGasTariff[which(NSGasTariff$Total > 0),]

SSGasTariff <- GasTariff[which(GasTariff$Region == "Southern Scotland"),]

SSGasTariff <- dcast(SSGasTariff, Dates ~ Category, value.var = "Value")

SSGasTariff <- SSGasTariff[which(SSGasTariff$Total > 0),]


NSDualFuel <- NSElecTariff

NSDualFuel[2:9] <- NSElecTariff[2:9] + NSGasTariff[2:9]

NSDualFuel$Total <- NSDualFuel$Total - NSDualFuel$Headroom

NSDualFuel$Headroom <- NULL

NSDualFuel <- NSDualFuel[c(1,8,4,6,5,3,2,7)]

NSDualFuel[,(2:8)] %<>% sapply(`/`,NSDualFuel[,8])

NSDualFuel<- NSDualFuel[seq(dim(NSDualFuel)[1],1),]

write.table(NSDualFuel,
            "Output/Energy Bills/NorthScotlandDualFuelBreakdown.txt",
            sep = "\t",
            row.names = FALSE)

SSDualFuel <- SSElecTariff

SSDualFuel[2:9] <- SSElecTariff[2:9] + SSGasTariff[2:9]

SSDualFuel$Total <- SSDualFuel$Total - SSDualFuel$Headroom

SSDualFuel$Headroom <- NULL

SSDualFuel <- SSDualFuel[c(1,8,4,6,5,3,2,7)]

SSDualFuel[,(2:8)] %<>% sapply(`/`,SSDualFuel[,8])

SSDualFuel<- SSDualFuel[seq(dim(SSDualFuel)[1],1),]

write.table(SSDualFuel,
            "Output/Energy Bills/SouthScotlandDualFuelBreakdown.txt",
            sep = "\t",
            row.names = FALSE)




NSElecTariff$Total <- NSElecTariff$Total - NSElecTariff$Headroom

NSElecTariff$Headroom <- NULL

NSElecTariff <- NSElecTariff[c(1,8,4,6,5,3,2,7)]

NSElecTariff[,(2:8)] %<>% sapply(`/`,NSElecTariff[,8])

NSElecTariff<- NSElecTariff[seq(dim(NSElecTariff)[1],1),]

write.table(NSElecTariff,
            "Output/Energy Bills/NorthScotlandElecFuelBreakdown.txt",
            sep = "\t",
            row.names = FALSE)

SSElecFuel <- SSElecTariff

SSElecFuel[2:9] <- SSElecTariff[2:9] + SSGasTariff[2:9]

SSElecFuel$Total <- SSElecFuel$Total - SSElecFuel$Headroom

SSElecFuel$Headroom <- NULL

SSElecFuel <- SSElecFuel[c(1,8,4,6,5,3,2,7)]

SSElecFuel[,(2:8)] %<>% sapply(`/`,SSElecFuel[,8])

SSElecFuel<- SSElecFuel[seq(dim(SSElecFuel)[1],1),]

write.table(SSElecFuel,
            "Output/Energy Bills/SouthScotlandElecFuelBreakdown.txt",
            sep = "\t",
            row.names = FALSE)



NSGasTariff$Total <- NSGasTariff$Total - NSGasTariff$Headroom

NSGasTariff$Headroom <- NULL

NSGasTariff <- NSGasTariff[c(1,8,4,6,5,3,2,7)]

NSGasTariff[,(2:8)] %<>% sapply(`/`,NSGasTariff[,8])

NSGasTariff<- NSGasTariff[seq(dim(NSGasTariff)[1],1),]

write.table(NSGasTariff,
            "Output/Energy Bills/NorthScotlandGasFuelBreakdown.txt",
            sep = "\t",
            row.names = FALSE)

SSGasFuel <- SSGasTariff

SSGasFuel[2:9] <- SSGasTariff[2:9] + SSGasTariff[2:9]

SSGasFuel$Total <- SSGasFuel$Total - SSGasFuel$Headroom

SSGasFuel$Headroom <- NULL

SSGasFuel <- SSGasFuel[c(1,8,4,6,5,3,2,7)]

SSGasFuel[,(2:8)] %<>% sapply(`/`,SSGasFuel[,8])

SSGasFuel<- SSGasFuel[seq(dim(SSGasFuel)[1],1),]

write.table(SSGasFuel,
            "Output/Energy Bills/SouthScotlandGasFuelBreakdown.txt",
            sep = "\t",
            row.names = FALSE)











