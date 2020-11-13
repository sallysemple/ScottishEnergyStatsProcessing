library(readxl)

print("GDP")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Load Accounts Data ###
GDP <-
  read_excel(
    "Data Sources/Quarterly National Accounts/Current.xlsx",
    sheet = "Table A",
    skip = 4
  )
### Create Subset with only relevant data ###
# is.na(GDP$Quarter2) means that only the rows where there is nothing in that column are extracted.
# This corresponds to GDP in Calendar years.
GDP <-
  subset(
    GDP,
    is.na(GDP$Quarter),
    select = c(
      'Year',
      'Total Gross Value Added (GVA)',
      'Gross Domestic Product (GDP) at market prices__2'
    )
  )

### Remove excess rows from the bottom ###
GDP <- head(GDP,-10)


### Export to CSV ###
write.table(
  GDP,
  "R Data Output/GDP.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
