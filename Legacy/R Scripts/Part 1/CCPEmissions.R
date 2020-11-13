### Load Packages
library(readxl)

### Set Working Director
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("CCPEmissions")

### Read Source Data

CCPEmissions <- read_excel("Data Sources/CCP Emissions/Current.xlsx", 
                      sheet = "Sheet1", skip = 3)


### Export to CSV
write.table(
  CCPEmissions,
  "R Data Output/CCPEmissions.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)