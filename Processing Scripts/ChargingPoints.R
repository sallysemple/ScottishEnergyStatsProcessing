library(readODS)
library(readxl)
library(readr)
library(dplyr)
library(data.table)
library(stringr)

print("ChargingPoints")

ChargingPoints <- read_ods("Data Sources/ULEV Chargers/ChargePoints.ods", sheet = "EVCD_01a", skip = 6)

names(ChargingPoints) <- c("LACode", "Local Authority", "All Chargers", "All Chargers per 100,000 population")

ChargingPoints <- ChargingPoints[which(substr(ChargingPoints$LACode, 1, 1) == "S"),]

ChargingPoints <- ChargingPoints[1:3]

ChargingPointsRapid <- read_ods("Data Sources/ULEV Chargers/ChargePoints.ods", sheet = "EVCD_01b", skip = 6)

names(ChargingPointsRapid) <- c("LACode", "Local Authority", "Rapid Chargers", "Rapid Chargers per 100,000 population")

ChargingPointsRapid <- ChargingPointsRapid[which(substr(ChargingPointsRapid$LACode, 1, 1) == "S"),]


ChargingPointsRapid <- ChargingPointsRapid[1:3]

ChargingPoints <- merge(ChargingPoints,ChargingPointsRapid)

ChargingPointsYear <- names(read_ods("Data Sources/ULEV Chargers/ChargePoints.ods"))[1]

ChargingPointsYear <- substr(ChargingPointsYear, 46,str_length(ChargingPointsYear))

ChargingPoints$Year <- ChargingPointsYear

write.csv(ChargingPoints,
            "Output/Charging Points/Points.csv",
            row.names = FALSE)


library(readxl)

ChargingEvents <- read_excel("Data Sources/Scotland Transport/Environment.xlsx", 
                             sheet = "T13.13", skip = 2)

names(ChargingEvents)[1] <- "LA"

LALookup <- read_excel("LALookup.xlsx", sheet = "LA to Code")

ChargingEvents <- merge(ChargingEvents, LALookup, all.x = TRUE)


ChargingEvents <- ChargingEvents[c(1,10,2,5,8)]

ChargingEvents <- ChargingEvents[complete.cases(ChargingEvents),]

ChargingEvents$Rapid <- as.numeric(as.character(ChargingEvents$Rapid))

ChargingEvents$Fast <- as.numeric(as.character(ChargingEvents$Fast))

ChargingEvents$Slow <- as.numeric(as.character(ChargingEvents$Slow ))

ChargingEvents$Total <- ChargingEvents$Rapid + ChargingEvents$Fast + ChargingEvents$Slow

ChargingEvents <- ChargingEvents[order(substr(ChargingEvents$Code,1,2)),]

write.table(ChargingEvents,
            "Output/Charging Points/Events.txt",
            sep = "\t",
            row.names = FALSE)


ChargingAmountCharged <- read_excel("Data Sources/Scotland Transport/Environment.xlsx", 
                             sheet = "T13.13", skip = 2)

names(ChargingAmountCharged)[1] <- "LA"

ChargingAmountCharged <- merge(ChargingAmountCharged, LALookup, all.x = TRUE)


ChargingAmountCharged <- ChargingAmountCharged[c(1,10,3,6,9)]

names(ChargingAmountCharged) <- c("LA", "Code", "Rapid", "Fast", "Slow")

ChargingAmountCharged <- ChargingAmountCharged[complete.cases(ChargingAmountCharged),]

ChargingAmountCharged$Rapid <- as.numeric(as.character(ChargingAmountCharged$Rapid))

ChargingAmountCharged$Fast <- as.numeric(as.character(ChargingAmountCharged$Fast))

ChargingAmountCharged$Slow <- as.numeric(as.character(ChargingAmountCharged$Slow ))

ChargingAmountCharged$Total <- ChargingAmountCharged$Rapid + ChargingAmountCharged$Fast + ChargingAmountCharged$Slow

ChargingAmountCharged <- ChargingAmountCharged[order(substr(ChargingAmountCharged$Code,1,2)),]

write.table(ChargingAmountCharged,
            "Output/Charging Points/AmountCharged.txt",
            sep = "\t",
            row.names = FALSE)

