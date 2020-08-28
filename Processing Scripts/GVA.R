library(readxl)

print("GDP")


### Load Accounts Data ###
GDP <-
  read_excel(
    "Data Sources/QNAS/QNAS.xlsx",
    sheet = "Table A",
    skip = 4
  )
### Create Subset with only relevant data ###
# is.na(GDP$Quarter2) means that only the rows where there is nothing in that column are extracted.
# This corresponds to GDP in Calendar years.
GDP <-
  subset(
    GDP,
    is.na(GDP$Quarter)
  )

### Remove excess rows from the bottom ###
GDP <- head(GDP[c(1,3,9)],-10)


names(GDP) <- c("Year", "GVA", "GDP at Market Prices")

### Export to CSV ###
write.table(
  GDP,
  "Output/GVA/GVA.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
