library(readxl)
library(plyr)
library(dplyr)

ECOMeasuresHouseholds <- read_excel("Data Sources/ECO/Current.xlsx", 
                                    sheet = "T4.1", skip = 2)

ECOMeasuresHouseholds <- ECOMeasuresHouseholds[which(ECOMeasuresHouseholds$`Area Codes` == "S92000003"),]

write.table(ECOMeasuresHouseholds,
            "Output/ECO/ECOMeasuresHouseholds.txt",
            sep = "\t",
            row.names = FALSE)

ECOMeasuresTotals <- read_excel("Data Sources/ECO/Current.xlsx", 
                                sheet = "T3.3", skip = 2)


ECOMeasuresTotals <- fill(ECOMeasuresTotals, Obligation, .direction = "down")

ECOMeasuresTotals <- ECOMeasuresTotals[which(ECOMeasuresTotals$`Area Codes` == "S92000003"),]

write.table(ECOMeasuresTotals,
            "Output/ECO/ECOMeasuresTotals.txt",
            sep = "\t",
            row.names = FALSE)
