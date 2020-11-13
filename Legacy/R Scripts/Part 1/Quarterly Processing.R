### Start ###
library(readxl)
library(dplyr)


print("Quarterly Processing")
### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Load Column Headers ###
CapacityHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Scotland - Qtr",
    col_names = FALSE,
    skip = 4,
    n_max = 2
  )

### Add extra Column headers, so data will be the same shape later for merging ###
CapacityHeaderExtra <- c("Capacity", "Technology")

### Add extra column to the Header Data  ###
CapacityHeader$Capacity <- CapacityHeaderExtra

### Rerrange Columns to line up with the data ###
CapacityHeader <- select(CapacityHeader, Capacity, everything())

### Merge the two Header lines into a format that can be applied to datasets ###
CapacityHeader <- sapply(CapacityHeader, paste, collapse = " - ")

### Load Energy Trends Data ###
# sheet, skip and n_max dictate which section is loaded,in this case Quarterly Generation
CapacityData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Scotland - Qtr",
    col_names = FALSE,
    skip = 7,
    n_max = 13
  )

### Apply the Data Headers to the Data ###
names(CapacityData) <- CapacityHeader

### Reverse Column order so latest years are first ###
CapacityData <- CapacityData[, rev(seq_len(ncol(CapacityData)))]

### Move Technology Column to the start for readability ###
CapacityData <-
  select(CapacityData, "Capacity - Technology", everything())

### Export to CSV ###
write.table(
  CapacityData,
  "R Data Output/CapacityOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat Process for Generation ######


GenerationHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Scotland - Qtr",
    col_names = FALSE,
    skip = 4,
    n_max = 2
  )
GenerationHeaderExtra <- c("Generation", "Technology")
GenerationHeader$Generation <- GenerationHeaderExtra
GenerationHeader <-
  select(GenerationHeader, Generation, everything())
GenerationHeader <-
  sapply(GenerationHeader, paste, collapse = " - ")


GenerationData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Scotland - Qtr",
    col_names = FALSE,
    skip = 22,
    n_max = 9
  )

names(GenerationData) <- GenerationHeader

names(GenerationData) <- GenerationHeader

GenerationData <-
  GenerationData[, rev(seq_len(ncol(GenerationData)))]
GenerationData <-
  select(GenerationData, "Generation - Technology", everything())

write.table(
  GenerationData,
  "R Data Output/GenerationOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat for Annual Capacity ######

AnnualCapacityHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Scotland- Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 4,
    n_max = 1
  )
AnnualCapacityHeaderExtra <- c("Capacity - Technology")
AnnualCapacityHeader$Capacity <- AnnualCapacityHeaderExtra
AnnualCapacityHeader <-
  select(AnnualCapacityHeader, Capacity, everything())
AnnualCapacityHeader <-
  sapply(AnnualCapacityHeader, paste, collapse = "")


AnnualCapacityData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Scotland- Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 7,
    n_max = 8
  )

names(AnnualCapacityData) <- AnnualCapacityHeader

AnnualCapacityData <-
  AnnualCapacityData[, rev(seq_len(ncol(AnnualCapacityData)))]
AnnualCapacityData <-
  select(AnnualCapacityData, "Capacity - Technology", everything())

write.table(
  AnnualCapacityData,
  "R Data Output/AnnualCapacityOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat for Annual Generation ######

AnnualGenerationHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Scotland- Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 4,
    n_max = 1
  )
AnnualGenerationHeaderExtra <- c("Generation - Technology")
AnnualGenerationHeader$Generation <- AnnualGenerationHeaderExtra
AnnualGenerationHeader <-
  select(AnnualGenerationHeader, Generation, everything())
AnnualGenerationHeader <-
  sapply(AnnualGenerationHeader, paste, collapse = "")


AnnualGenerationData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Scotland- Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 17,
    n_max = 8
  )

names(AnnualGenerationData) <- AnnualGenerationHeader

AnnualGenerationData <-
  AnnualGenerationData[, rev(seq_len(ncol(AnnualGenerationData)))]
AnnualGenerationData <-
  select(AnnualGenerationData, "Generation - Technology", everything())

write.table(
  AnnualGenerationData,
  "R Data Output/AnnualGenerationOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat for UK ######
### UK Quarterly Generation ###

UKGenerationHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Quarter",
    col_names = FALSE,
    skip = 4,
    n_max = 2
  )
UKGenerationHeaderExtra <- c("Generation", "Technology")
UKGenerationHeader$Generation <- UKGenerationHeaderExtra
UKGenerationHeader <-
  select(UKGenerationHeader, Generation, everything())
UKGenerationHeader <-
  sapply(UKGenerationHeader, paste, collapse = " - ")


UKGenerationData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Quarter",
    col_names = FALSE,
    skip = 23,
    n_max = 13
  )

names(UKGenerationData) <- UKGenerationHeader

names(UKGenerationData) <- UKGenerationHeader

UKGenerationData <-
  UKGenerationData[, rev(seq_len(ncol(UKGenerationData)))]
UKGenerationData <-
  select(UKGenerationData, "Generation - Technology", everything())

write.table(
  UKGenerationData,
  "R Data Output/UKGenerationOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### UK generation Annual ###


UKAnnualGenerationHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Annual",
    col_names = FALSE,
    skip = 4,
    n_max = 1
  )
UKAnnualGenerationHeaderExtra <- c("Generation - Technology")
UKAnnualGenerationHeader$Generation <- UKAnnualGenerationHeaderExtra
UKAnnualGenerationHeader <-
  select(UKAnnualGenerationHeader, Generation, everything())
UKAnnualGenerationHeader <-
  sapply(UKAnnualGenerationHeader, paste, collapse = "")


UKAnnualGenerationData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Annual",
    col_names = FALSE,
    skip = 23,
    n_max = 13
  )

names(UKAnnualGenerationData) <- UKAnnualGenerationHeader

UKAnnualGenerationData <-
  UKAnnualGenerationData[, rev(seq_len(ncol(UKAnnualGenerationData)))]
UKAnnualGenerationData <-
  select(UKAnnualGenerationData, "Generation - Technology", everything())

write.table(
  UKAnnualGenerationData,
  "R Data Output/UKAnnualGenerationOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### England


### Load Column Headers ###
CapacityHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "England - Qtr",
    col_names = FALSE,
    skip = 4,
    n_max = 2
  )

### Add extra Column headers, so data will be the same shape later for merging ###
CapacityHeaderExtra <- c("Capacity", "Technology")

### Add extra column to the Header Data  ###
CapacityHeader$Capacity <- CapacityHeaderExtra

### Rerrange Columns to line up with the data ###
CapacityHeader <- select(CapacityHeader, Capacity, everything())

### Merge the two Header lines into a format that can be applied to datasets ###
CapacityHeader <- sapply(CapacityHeader, paste, collapse = " - ")

### Load Energy Trends Data ###
# sheet, skip and n_max dictate which section is loaded,in this case Quarterly Generation
CapacityData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "England - Qtr",
    col_names = FALSE,
    skip = 7,
    n_max = 13
  )

### Apply the Data Headers to the Data ###
names(CapacityData) <- CapacityHeader

### Reverse Column order so latest years are first ###
CapacityData <- CapacityData[, rev(seq_len(ncol(CapacityData)))]

### Move Technology Column to the start for readability ###
CapacityData <-
  select(CapacityData, "Capacity - Technology", everything())

### Export to CSV ###
write.table(
  CapacityData,
  "R Data Output/EnglandCapacityOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat Process for Generation ######


GenerationHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "England - Qtr",
    col_names = FALSE,
    skip = 4,
    n_max = 2
  )
GenerationHeaderExtra <- c("Generation", "Technology")
GenerationHeader$Generation <- GenerationHeaderExtra
GenerationHeader <-
  select(GenerationHeader, Generation, everything())
GenerationHeader <-
  sapply(GenerationHeader, paste, collapse = " - ")


GenerationData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "England - Qtr",
    col_names = FALSE,
    skip = 22,
    n_max = 9
  )

names(GenerationData) <- GenerationHeader

names(GenerationData) <- GenerationHeader

GenerationData <-
  GenerationData[, rev(seq_len(ncol(GenerationData)))]
GenerationData <-
  select(GenerationData, "Generation - Technology", everything())

write.table(
  GenerationData,
  "R Data Output/EnglandGenerationOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat for Annual Capacity ######

AnnualCapacityHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "England - Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 4,
    n_max = 1
  )
AnnualCapacityHeaderExtra <- c("Capacity - Technology")
AnnualCapacityHeader$Capacity <- AnnualCapacityHeaderExtra
AnnualCapacityHeader <-
  select(AnnualCapacityHeader, Capacity, everything())
AnnualCapacityHeader <-
  sapply(AnnualCapacityHeader, paste, collapse = "")


AnnualCapacityData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "England - Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 7,
    n_max = 8
  )

names(AnnualCapacityData) <- AnnualCapacityHeader

AnnualCapacityData <-
  AnnualCapacityData[, rev(seq_len(ncol(AnnualCapacityData)))]
AnnualCapacityData <-
  select(AnnualCapacityData, "Capacity - Technology", everything())

write.table(
  AnnualCapacityData,
  "R Data Output/EnglandAnnualCapacityOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat for Annual Generation ######

AnnualGenerationHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "England - Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 4,
    n_max = 1
  )
AnnualGenerationHeaderExtra <- c("Generation - Technology")
AnnualGenerationHeader$Generation <- AnnualGenerationHeaderExtra
AnnualGenerationHeader <-
  select(AnnualGenerationHeader, Generation, everything())
AnnualGenerationHeader <-
  sapply(AnnualGenerationHeader, paste, collapse = "")


AnnualGenerationData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "England - Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 17,
    n_max = 8
  )

names(AnnualGenerationData) <- AnnualGenerationHeader

AnnualGenerationData <-
  AnnualGenerationData[, rev(seq_len(ncol(AnnualGenerationData)))]
AnnualGenerationData <-
  select(AnnualGenerationData, "Generation - Technology", everything())

write.table(
  AnnualGenerationData,
  "R Data Output/EnglandAnnualGenerationOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Wales


### Load Column Headers ###
CapacityHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Wales - Qtr",
    col_names = FALSE,
    skip = 4,
    n_max = 2
  )

### Add extra Column headers, so data will be the same shape later for merging ###
CapacityHeaderExtra <- c("Capacity", "Technology")

### Add extra column to the Header Data  ###
CapacityHeader$Capacity <- CapacityHeaderExtra

### Rerrange Columns to line up with the data ###
CapacityHeader <- select(CapacityHeader, Capacity, everything())

### Merge the two Header lines into a format that can be applied to datasets ###
CapacityHeader <- sapply(CapacityHeader, paste, collapse = " - ")

### Load Energy Trends Data ###
# sheet, skip and n_max dictate which section is loaded,in this case Quarterly Generation
CapacityData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Wales - Qtr",
    col_names = FALSE,
    skip = 7,
    n_max = 13
  )

### Apply the Data Headers to the Data ###
names(CapacityData) <- CapacityHeader

### Reverse Column order so latest years are first ###
CapacityData <- CapacityData[, rev(seq_len(ncol(CapacityData)))]

### Move Technology Column to the start for readability ###
CapacityData <-
  select(CapacityData, "Capacity - Technology", everything())

### Export to CSV ###
write.table(
  CapacityData,
  "R Data Output/WalesCapacityOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat Process for Generation ######


GenerationHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Wales - Qtr",
    col_names = FALSE,
    skip = 4,
    n_max = 2
  )
GenerationHeaderExtra <- c("Generation", "Technology")
GenerationHeader$Generation <- GenerationHeaderExtra
GenerationHeader <-
  select(GenerationHeader, Generation, everything())
GenerationHeader <-
  sapply(GenerationHeader, paste, collapse = " - ")


GenerationData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Wales - Qtr",
    col_names = FALSE,
    skip = 22,
    n_max = 9
  )

names(GenerationData) <- GenerationHeader

names(GenerationData) <- GenerationHeader

GenerationData <-
  GenerationData[, rev(seq_len(ncol(GenerationData)))]
GenerationData <-
  select(GenerationData, "Generation - Technology", everything())

write.table(
  GenerationData,
  "R Data Output/WalesGenerationOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat for Annual Capacity ######

AnnualCapacityHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Wales- Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 4,
    n_max = 1
  )
AnnualCapacityHeaderExtra <- c("Capacity - Technology")
AnnualCapacityHeader$Capacity <- AnnualCapacityHeaderExtra
AnnualCapacityHeader <-
  select(AnnualCapacityHeader, Capacity, everything())
AnnualCapacityHeader <-
  sapply(AnnualCapacityHeader, paste, collapse = "")


AnnualCapacityData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Wales- Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 7,
    n_max = 8
  )

names(AnnualCapacityData) <- AnnualCapacityHeader

AnnualCapacityData <-
  AnnualCapacityData[, rev(seq_len(ncol(AnnualCapacityData)))]
AnnualCapacityData <-
  select(AnnualCapacityData, "Capacity - Technology", everything())

write.table(
  AnnualCapacityData,
  "R Data Output/WalesAnnualCapacityOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

###### Repeat for Annual Generation ######

AnnualGenerationHeader <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Wales- Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 4,
    n_max = 1
  )
AnnualGenerationHeaderExtra <- c("Generation - Technology")
AnnualGenerationHeader$Generation <- AnnualGenerationHeaderExtra
AnnualGenerationHeader <-
  select(AnnualGenerationHeader, Generation, everything())
AnnualGenerationHeader <-
  sapply(AnnualGenerationHeader, paste, collapse = "")


AnnualGenerationData <-
  read_excel(
    "Data Sources/Energy Trends/Current.xls",
    sheet = "Wales- Annual",
    # This Sheet may be Renamed to 'Scotland - Annual'
    col_names = FALSE,
    skip = 17,
    n_max = 8
  )

names(AnnualGenerationData) <- AnnualGenerationHeader

AnnualGenerationData <-
  AnnualGenerationData[, rev(seq_len(ncol(AnnualGenerationData)))]
AnnualGenerationData <-
  select(AnnualGenerationData, "Generation - Technology", everything())

write.table(
  AnnualGenerationData,
  "R Data Output/WalesAnnualGenerationOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)