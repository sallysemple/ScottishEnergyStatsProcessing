### Load Packages
library(readxl)

print("Household Numbers")

### Set Working Director
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Read Source Data
Household <-
  read_excel(
    "Data Sources/Household Projections/Current.xlsx",
    sheet = "401",
    col_names = FALSE,
    skip = 6
  )

### Remove Last Twelve Rows
Household <- head(Household,-12)

### Remove Columns
Household <- Household[-c(8:9)]

### Rename Columns
names(Household) <-
  c(
    "Year",
    "England",
    "Wales",
    "Scotland",
    "Great Britain",
    "Northern Ireland",
    "United Kingdom"
  )

### Export to CSV
write.table(
  Household,
  "R Data Output/Household.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


### NRS Numbers

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

HouseholdNRS <- read_excel("Data Sources/Households in Scotland/Current.xlsx", 
                      sheet = "Table 1", skip = 2, n_max = 34)

HouseholdNRS <- HouseholdNRS[complete.cases(HouseholdNRS),]

### Export to CSV
write.table(
  HouseholdNRS,
  "R Data Output/HouseholdNRS.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
