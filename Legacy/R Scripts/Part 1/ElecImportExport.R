### Load Packages ###
library(readxl)
library(readr)
library(magrittr)
library(tidyr)

print("ElecImportExport")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read source file ###
ImportExport <-
  read_excel(
    "Data Sources/Electricity Imports and Exports/Current.xls",
    sheet = "Quarter",
    col_names = FALSE,
    skip = 2
  )

### Combine first two columns into a new column called Time ###
ImportExport <-
  unite(ImportExport,
        Time,
        # New Column
        X__1,
        X__2,
        sep = " ",
        remove = TRUE)

ImportExport$Time <- substr(ImportExport$Time,1,7)

### Export to CSV ###
write.table(
  ImportExport,
  "R Data Output/ElecImportExport.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
) 