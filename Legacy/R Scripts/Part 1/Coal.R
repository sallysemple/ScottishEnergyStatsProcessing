### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Load Required Packages ###
library(readxl)

print("Coal")

### Load Carbon Spreadsheet ###
Coal <-
  read_excel(
    "Data Sources/Coal/Current.xlsx",
    skip = 3
  )


Coal <- subset(Coal, X__2 == "Scotland" | X__2 == "Total")

Coal <- Coal[c(5:6, 11:12),]
### Export to CSV ###
write.table(
  Coal,
  "R Data Output/Coal.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
