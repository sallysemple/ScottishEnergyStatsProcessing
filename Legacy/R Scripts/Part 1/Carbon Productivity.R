### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("Carbon Productivity")

### Load Required Packages ###
library(readxl)

### Load Carbon Spreadsheet ###
Carbon <-
  read_excel(
    "Data Sources/Greenhouse Gas Emissions/Current.xlsx",
    sheet = "Table B2",
    skip = 1
  )

### Export to CSV ###
write.table(
  Carbon,
  "R Data Output/Carbon.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)