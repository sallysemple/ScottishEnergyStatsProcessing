### Load Packages ###

library(readr)
library(readxl)
library(dplyr)

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("Biofuels")

### Load Tab 6 of the Hydrocarbon Oils Bulletin into R, skipping top 8 rows ###

Oils <-
  read_excel(
    "Data Sources/Hydrocarbon Oils Bulletin/Current.xls",
    sheet = "6",
    col_names = FALSE,
    skip = 8
  )

### Read a seperate CSV file that has the Column headings for the Data ###
OilsHeader <-
  read_csv("Data Sources/Hydrocarbon Oils Bulletin/Header.csv",
           col_names = FALSE)

### Convert to a format that R can apply to column headings  ###
OilsHeader <- sapply(OilsHeader, paste, collapse = "")

### Apply the new headings ###
names(Oils) <- OilsHeader

### Remove Columns with no data ###
Oils <-
  Oils[, grep("^(NA)", names(Oils), value = TRUE, invert = TRUE)]

### Create a subset containing only calendar year ###
# The data has three formats of time for Time period: Calendar Year, Financial Year, and Monthly.
# Calendar Year is exactly Four Characters, so the code creates a subset where the Time Period
# is exactly 4 characters long.
Oils <- subset(Oils, nchar(Oils$'Time Period') == 4)

### Reverse the order of the rows so the most recent year is the first line of Data.
Oils <- Oils[nrow(Oils):1, ]

##Output to CSV
write.table(
  Oils,
  "R Data Output/Oils.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
