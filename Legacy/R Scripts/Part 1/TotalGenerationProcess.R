library(readxl)


print("TotalGenerationProcess")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Load Regional generation Data
Generation <-
  read_excel(
    "Data Sources/Regional Generation/Current.xls",
    col_names = FALSE,
    sheet = "Generation & Supply"
  )

### Reverse column order so Latest Year is first ###
Generation <- Generation[, rev(seq_len(ncol(Generation)))]

### Export to CSV ###
write.table(
  Generation,
  "R Data Output/TotalGeneration.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
