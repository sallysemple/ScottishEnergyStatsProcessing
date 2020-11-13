library(readr)
library(readxl)
library(dplyr)

print("SnapSatellite")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source Data ###
OffshoreExports <-
  read_excel("Data Sources/SNAPSatellite/Current.xlsx",
             sheet = "Table 3",
             skip = 3)

### Remove Fourth Column ###
OffshoreExports[4] <- NULL

### Remove Last Row
OffshoreExports <- head(OffshoreExports,-1)

### Export to CSV ###
write.table(
  OffshoreExports,
  "R Data Output/OffshoreExports.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)