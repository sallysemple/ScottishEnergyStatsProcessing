library(readxl)

ChargingPoints <- read_excel("Data Sources/Scotland Transport/Environment.xlsx", 
                          sheet = "T13.11", skip = 2)

LALookup <- read_excel("LALookup.xlsx")

names(ChargingPoints)[1] <- "LA"

ChargingPoints <- merge(ChargingPoints, LALookup, all.x = TRUE)

ChargingPoints <- ChargingPoints[order(substr(ChargingPoints$Code,1,2)),]

ChargingPoints <- ChargingPoints[c(1, ncol(ChargingPoints),2:(ncol(ChargingPoints)-1))]

write.table(ChargingPoints,
            "Output/Charging Points/Points.txt",
            sep = "\t",
            row.names = FALSE)


library(readxl)

ChargingEvents <- read_excel("Data Sources/Scotland Transport/Environment.xlsx", 
                             sheet = "T13.13", skip = 2)

names(ChargingEvents)[1] <- "LA"

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
