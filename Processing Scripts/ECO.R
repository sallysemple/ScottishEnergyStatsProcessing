library(readxl)
library(plyr)
library(dplyr)
library(tidyverse)
library(magrittr)
library(reshape2)

print("ECO")
ECOMeasuresHouseholds <- read_excel("Data Sources/ECO/Current.xlsx", 
                                    sheet = "T4.1", skip = 0)

names(ECOMeasuresHouseholds) <- ECOMeasuresHouseholds[2,]

ECOMeasuresHouseholds <- ECOMeasuresHouseholds[which(ECOMeasuresHouseholds$`Area Codes` == "S92000003" | ECOMeasuresHouseholds$`Area Codes` == "Area Codes"),]

ECOMeasuresHouseholds <- as_tibble(t(ECOMeasuresHouseholds))

names(ECOMeasuresHouseholds) <- c("Quarter", "Households")

ECOMeasuresHouseholdsCumulative <- head(ECOMeasuresHouseholds,-4)

ECOMeasuresHouseholdsCumulative$`Households` <- as.numeric(ECOMeasuresHouseholdsCumulative$`Households`)

ECOMeasuresHouseholdsCumulative <- ECOMeasuresHouseholdsCumulative[complete.cases(ECOMeasuresHouseholdsCumulative),]

ECOMeasuresHouseholdsCumulative <- ECOMeasuresHouseholdsCumulative %>% mutate(Households = cumsum(Households))

ECOMeasuresHouseholdsCumulative <- rbind(ECOMeasuresHouseholdsCumulative, ECOMeasuresHouseholds[nrow(ECOMeasuresHouseholds),])

write.table(ECOMeasuresHouseholdsCumulative,
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

ECOMeasuresTotals <- read_excel("Data Sources/ECO/Current.xlsx", 
                                    sheet = "T3.3", skip = 0)

names(ECOMeasuresTotals) <- ECOMeasuresTotals[2,]

ECOMeasuresTotals <- fill(ECOMeasuresTotals, Obligation, .direction = "down")

ECOMeasuresTotals <- ECOMeasuresTotals[which(ECOMeasuresTotals$`Area Codes` == "S92000003" | ECOMeasuresTotals$`Area Codes` == "Area Codes"),]

ECOMeasuresTotals <- as_tibble(t(ECOMeasuresTotals))

names(ECOMeasuresTotals) <- c("Quarter",
                                        "CERO",
                                        "CERO Rural",
                                        "CSCO",
                                        "CSCO Rural",
                                        "Affordable Warmth",
                                        "Rural",
                                        "Total"
)
ECOMeasuresTotalsCumulative <- head(ECOMeasuresTotals,-4)


ECOMeasuresTotalsCumulative[2:8] %<>% lapply(function(x) as.numeric(as.character(x)))

ECOMeasuresTotalsCumulative <- tail(ECOMeasuresTotalsCumulative, -3)

ECOMeasuresTotalsCumulative[is.na(ECOMeasuresTotalsCumulative)] <- 0

ECOMeasuresTotalsCumulative <- ECOMeasuresTotalsCumulative %>% mutate(`CERO` = cumsum(`CERO`),
                                                                      `CERO Rural` = cumsum(`CERO Rural`),
                                                                      `CSCO` = cumsum(`CSCO`),
                                                                      `CSCO Rural` = cumsum(`CSCO Rural`),
                                                                      `Affordable Warmth` = cumsum(`Affordable Warmth`),
                                                                      `Rural` = cumsum(`Rural`),
                                                                      `Total` = cumsum(`Total`))

ECOMeasuresTotalsCumulative <- rbind(ECOMeasuresTotalsCumulative, ECOMeasuresTotals[nrow(ECOMeasuresTotals),])

write.table(ECOMeasuresTotalsCumulative,
            "Output/ECO/ECOMeasuresTotals.txt",
            sep = "\t",
            row.names = FALSE)



ECOMeasuresLA <- read_excel("Data Sources/ECO/Current.xlsx", 
                                    sheet = "T3.4", skip = 2)

ECOMeasuresLA[1,1:4] <- list("Code", "Country", "Region", "Local Authority")
names(ECOMeasuresLA) <- ECOMeasuresLA[1,]



ECOMeasuresLA <- ECOMeasuresLA[which(substr(ECOMeasuresLA$`Code`,1,2) == "S1"),]

ECOMeasuresLA[c(2:4, 9:10)] <- NULL

ECOMeasuresLA <- melt(ECOMeasuresLA, id.vars = "Code")

ECOMeasuresLA <- merge(ECOMeasuresLA, read_excel("LALookup.xlsx", sheet = "Code to LA"), all.x = TRUE)

write.table(ECOMeasuresLA[c(1,4,2,3)],
            "Output/ECO/ECOMeasuresLA.txt",
            sep = "\t",
            row.names = FALSE)




