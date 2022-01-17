library(readxl)
library(tidyverse)

print("Oil Gas GVA")

QNAS_Supplementary <- read_excel("Data Sources/QNAS/QNAS_Supplementary.xlsx", 
                                 sheet = "10", skip = 5)

QNAS_Supplementary <- QNAS_Supplementary[which(is.na(QNAS_Supplementary$Quarter)),]

QNAS_Supplementary <- select(QNAS_Supplementary,
                             Year,
                             `B - Mining and Quarrying \r\n(SA)`,
                             'GDP Including a Geographical share of Extra-Regio (NSA)')

names(QNAS_Supplementary) <- c("Year", "Oil Gas GVA", "Share")

QNAS_Supplementary$Share <- QNAS_Supplementary$`Oil Gas GVA` / QNAS_Supplementary$Share 

QNAS_Supplementary$`Oil Gas GVA` <- QNAS_Supplementary$`Oil Gas GVA` / 1000

write_csv(QNAS_Supplementary, "Output/GVA/OilGasGVA.csv")
