### Load Packages
library(readxl)

### Set Working Director
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("IndustryGVA")

### Read Source Data

IndustryGVA <- read_excel("Data Sources/Industry & Services GVA/Current.xlsx", 
                      sheet = "Table 1.1")

IndustryGVA <- subset(IndustryGVA, is.na(IndustryGVA[2]))

IndustryGVA <- IndustryGVA[which(IndustryGVA[19] >0 ),][c(1,19)]

names(IndustryGVA) <- c("Year", "Industry GVA")
### Export to CSV
write.table(
  IndustryGVA,
  "R Data Output/IndustryGVA.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

ServicesGVA <- read_excel("Data Sources/Industry & Services GVA/Current.xlsx", 
                          sheet = "Table 1.1")

ServicesGVA <- subset(ServicesGVA, is.na(ServicesGVA[2]))

ServicesGVA <- ServicesGVA[which(ServicesGVA[22] >0 ),][c(1,22)]

names(ServicesGVA) <- c("Year", "Services GVA")
### Export to CSV
write.table(
  ServicesGVA,
  "R Data Output/ServicesGVA.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


