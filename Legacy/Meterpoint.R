library(readr)
library(readxl)
library(magrittr)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(lubridate)
library(writexl)
library(data.table)
library(tidyverse)

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

ElecMeterpoint <- read.csv("Data Sources/Meterpoint/CurrentElec.csv")

ElecMeterpoint <- distinct(ElecMeterpoint)

LACodes <- read_excel("Data Sources/Geography Codes/Current.xlsx", 
                        sheet = "S12_CA")[2:3]

names(LACodes) <- c("LAUA", "LAName")

ElecMeterpoint <- merge(ElecMeterpoint, LACodes, all = TRUE)

mytable <- table(ElecMeterpoint$PROFILE, ElecMeterpoint$LAUA)

mytable <- data.frame(rbind(mytable))

mytable <- setDT(mytable, keep.rownames = "Category")[]

write_csv(mytable, "R Data Output/ElecMeterpointLA.csv")

SCOT_GSP <- read_csv("J:/ENERGY BRANCH/Statistics/Meterpoint/SCOT_GSP/SCOT_GSP.csv")

ElecMeterpoint <- merge(ElecMeterpoint, SCOT_GSP, all = TRUE)

ElecMeterpoint$GSP_ID[is.na(ElecMeterpoint$GSP_ID)] <- "_Z"

mytable <- table(ElecMeterpoint$PROFILE, ElecMeterpoint$GSP_ID)

mytable <- data.frame(rbind(mytable))

mytable <- setDT(mytable, keep.rownames = "Category")[]

write_csv(mytable, "R Data Output/ElecMeterpointRegion.csv")

ElecMeterpoint$Amount <- 1

ElecMeterpoint <- ElecMeterpoint %>%  
  group_by(LAName, GSP_ID)  %>% 
  summarise(Amount = sum(Amount))

ElecMeterpoint <- dcast(ElecMeterpoint, LAName ~ GSP_ID)

ElecMeterpoint[is.na(ElecMeterpoint)] <- 0

write_csv(ElecMeterpoint, "R Data Output/ElecMeterpointLA&Region.csv")

#ElecMeterpointNonDom <- subset(ElecMeterpoint, PROFILE >= 3)

#write_xlsx(ElecMeterpointNonDom, "J:/ENERGY BRANCH/Statistics/Meterpoint/ScotlandElecNonDom.xlsx")
# 
# ElecMeterpoint$AGG_KWH <- as.numeric(ElecMeterpoint$AGG_KWH)
# ElecMeterpoint <- subset(ElecMeterpoint, ElecMeterpoint$AGG_KWH <0)
# 
# write_xlsx(ElecMeterpoint, "J:/ENERGY BRANCH/Statistics/Meterpoint/ElecNegatives.xlsx")
# 
# ElecMeterpoint <- subset(ElecMeterpoint, ElecMeterpoint$PROFILE == "A" | ElecMeterpoint$PROFILE == "B")
# 
# write_xlsx(ElecMeterpoint, "J:/ENERGY BRANCH/Statistics/Meterpoint/ElecWrongProfile.xlsx")
# 
# sum(ElecMeterpoint$AGG_KWH)

# 
# GasMeterpoint <- read_csv("J:/ENERGY BRANCH/Statistics/Meterpoint/SCOTLAND_GAS_2017 (1)/SCOTLAND_GAS_2017.txt")
# GasMeterpoint <- distinct(GasMeterpoint)
# 
# mytable <- table(GasMeterpoint$MS_CODE_DECC)
# 
# GasMeterpointNonDom <- subset(GasMeterpoint, MS_CODE_DECC == "C")
# 
# write_xlsx(GasMeterpointNonDom, "J:/ENERGY BRANCH/Statistics/Meterpoint/ScotlandGasNonDom.xlsx")


