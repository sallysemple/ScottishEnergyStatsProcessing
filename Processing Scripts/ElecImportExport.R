### Load Packages ###
library(readxl)
library(readr)
library(magrittr)
library(tidyr)

print("ElecImportExport")

### Read source file ###
ImportExport <- read_excel("Data Sources/Imports Exports/ET_5.6.xls", 
                sheet = "Quarter",
                col_names = FALSE,
                skip = 2)

### Combine first two columns into a new column called Time ###
ImportExport <-
  unite(ImportExport,
        Time,
        # New Column
        ...1,
        ...2,
        sep = " ",
        remove = TRUE)

ImportExport$Time <- substr(ImportExport$Time,1,7)

names(ImportExport) <- c("Quarter", "France - UK Imports", "France - UK Exports", "Ireland - NI Imports", "Ireland - NI Exports", "Netherlands - UK Imports", "Netherlands - UK Exports", "Ireland - Wales Imports", "Ireland - Wales Exports", "Belgium - UK Imports", "Belgium - UK Exports", "Total UK Imports", "Total UK Exports", "Scotland - England Exports", "Scotland - England Imports", "Scotland - NI Exports", "Scotland - NI Imports")

ImportExport <- ImportExport[which(substr(ImportExport$Quarter,6,6) == "Q"),]

ImportExport[2:17] %<>% lapply(function(x) as.numeric(as.character(x)))

ImportExport[is.na(ImportExport)] <- 0

### Export to CSV ###
write_csv(ImportExport, "Output/Imports and Exports/ImportsExports.csv")