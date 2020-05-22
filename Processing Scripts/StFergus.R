library(readr)
library(zoo)
library(lubridate)

GasDistribution <- read_delim("Data Sources/Gas Daily/Supplies/GasDistribution.txt", 
                              "\t", escape_double = FALSE, trim_ws = TRUE)

GasDistribution$ScotProp <- GasDistribution$ScotDemand / GasDistribution$Fergus

GasDistribution$NIProp <- GasDistribution$NITransfer / GasDistribution$Fergus

GasDistribution$EnglandProp <- GasDistribution$EnglandTransfer / GasDistribution$Fergus

GasDistribution$FergusUKProp <- GasDistribution$Fergus / GasDistribution$GBTotal

StFergusFlowDaily <- GasDistribution[c(1,2,7,3,8,6,9,4,5, 10)]

write.table(StFergusFlowDaily,
            "Output/Gas Distribution/StFergusFlowDaily.txt",
            sep = "\t",
            row.names = FALSE)

StFergusFlowRolling <- StFergusFlowDaily

StFergusFlowRolling[2:10] <- rollmean(StFergusFlowRolling[2:10], 365, na.pad = TRUE, align = "right")

StFergusFlowRolling <- StFergusFlowRolling[which(ymd(StFergusFlowRolling$Date) == ymd((ceiling_date(StFergusFlowRolling$Date, unit = "month")-1))),]

StFergusFlowRolling <- StFergusFlowRolling[complete.cases(StFergusFlowRolling),]

write.table(StFergusFlowRolling,
            "Output/Gas Distribution/StFergusFlowRolling.txt",
            sep = "\t",
            row.names = FALSE)



