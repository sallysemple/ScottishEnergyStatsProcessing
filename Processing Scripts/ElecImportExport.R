### Load Packages ###
library(readxl)
library(readr)
library(magrittr)
library(tidyr)

print("ElecImportExport")

### Read source file ###
ImportExport <- read_excel("Data Sources/Imports Exports/ET_5.6.xlsx", 
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

ImportExport$Time <- paste0(substr(ImportExport$Time,1,4)," Q",substr(ImportExport$Time,14,14))

names(ImportExport) <- c("Quarter", 
                        "Imports (France to UK)",
                        "Exports (UK to France)",
                        "Net imports (France to UK)",
                        "Imports (Ireland to NI)",
                        "Exports (NI to Ireland)",
                        "Net imports (Ireland to NI)",
                        "Imports (Netherlands to UK)",
                        "Exports (UK to Netherlands)",
                        "Net imports (Netherlands to UK)",
                        "Imports (Ireland to Wales)",
                        "Exports (Wales to Ireland)",
                        "Net imports (Ireland to Wales)",
                        "Imports (Belgium to UK)",
                        "Exports (UK to Belgium)",
                        "Net imports (Belgium to UK)",
                        "Imports (Norway to UK)",
                        "Exports (UK to Norway)",
                        "Net imports (Norway to UK)",
                        "UK total imports",
                        "UK total exports",
                        "UK total net imports",
                        "Transfers (Scotland to England)",
                        "Transfers (England to Scotland)",
                        "Net transfers (Scotland to England)",
                        "Transfers (Scotland to NI)",
                        "Transfers (NI to Scotland)",
                        "Net transfers (Scotland to NI)")



ImportExport[2:28] %<>% lapply(function(x) as.numeric(as.character(x)))

ImportExport <- ImportExport[which(ImportExport$`Imports (France to UK)` > 0),]

ImportExport[is.na(ImportExport)] <- 0

### Export to CSV ###
write_csv(ImportExport, "Output/Imports and Exports/ImportsExports.csv")
