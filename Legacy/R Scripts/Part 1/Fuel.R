library(readxl)

print("Fuel")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Load Regional generation Data
Fuel <- read_excel(
  "Data Sources/Regional Generation/Current.xls",
  col_names = FALSE,
  sheet = "Fuel Used"
)

### Reverse column order so Latest Year is first ###
Fuel <- Fuel[, rev(seq_len(ncol(Fuel)))]

### Export to CSV ###
write.table(
  Fuel,
  "R Data Output/Fuel.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)