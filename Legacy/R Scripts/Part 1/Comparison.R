### Ensure no excel files are open when running this script ###

### Load Required Packages ###
library(plyr)
library(dplyr)
library(readxl)
library(readr)
library("writexl")
library(tidyr)

print("Comparison")

### Set working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")


### Open Excel File and Extract Relevant Data ###

## read_excel reads .xlsx files, read_csv reads .csv files. ##
## If using csv file directly from the website, include the skip argument to remove excess lines at the top. ##

CurrentData <- read_excel("Data Sources/REPD/Current.xlsx",
                          sheet = "Database",
                          skip = 5)

# CurrentData <- read_csv("Data Sources/REPD/Current.csv", skip = 6)

show(CurrentData)

### Rename Variables ###
CurrentData <-
  plyr::rename(
    CurrentData,
    c(
      "Technology Type" = "TechType",
      "Development Status (short)" = "Status",
      "No. of Turbines" = "TurbineAmount",
      "Installed Capacity (MWelec)" = "Capacity",
      "Old Ref ID" = "OldRef",
      "Ref ID" = "Ref",
      "Operator (or Applicant)" = "Operator",
      "Site Name" = "Site",
      "County" = "County",
      "Address" = "Address",
      "Post Code" = "PostCode",
      "Planning Authority" = "Authority"
    )
  )

### Create Scottish Subset ###
ScotlandCurrent <- subset(
  CurrentData,
  Country == "Scotland",
  select = c(
    "OldRef",
    "Ref",
    "TechType",
    "Status",
    "Capacity",
    "TurbineAmount",
    "Operator",
    "Site",
    "County",
    "Address",
    "PostCode",
    "Authority",
    "Country"
  )
)


### Create Under Construction Subset ###
ScotlandUnderConstruction <-
  subset(ScotlandCurrent, Status == "Under Construction")

### Reorganise Columns ###
ScotlandUnderConstruction <-
  select(
    ScotlandUnderConstruction,
    "TechType",
    "Site",
    "Address",
    "Authority",
    "Capacity",
    "County",
    "Ref",
    everything()
  )

### Drop Extra columns ###
ScotlandUnderConstruction <-
  within(
    ScotlandUnderConstruction,
    rm(
      "OldRef",
      "Status",
      "TurbineAmount",
      "Operator",
      "Country",
      "PostCode"
    )
  )

### Export CSV ###
write.table(
  ScotlandUnderConstruction,
  "R Data Output/ScotlandUnderConstruction.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### Read all Sheets of Excel File - Function ###

read_excel_allsheets <- function(filename, tibble = FALSE) {
  # I prefer straight data.frames
  # but if you like tidyverse tibbles (the default with read_excel)
  # then just pass tibble = TRUE
  sheets <- readxl::excel_sheets(filename)
  x <-
    lapply(sheets, function(X)
      readxl::read_excel(filename, sheet = X))
  if (!tibble)
    x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}


### Read all Sheets ###
DECCsheets <-
  read_excel_allsheets("Data Sources/DECC/CurrentDECC.xlsx")

### Merge Datasets together ###
DECCsheets <- rbind_list(DECCsheets)


DECCsheets[is.na(DECCsheets)] <- 0
### Reorganise Columns ###
DECCsheets <-
  select(DECCsheets,
         "RenewableArea",
         "ProjectName",
         "SiteName",
         "Country",
         everything())

### Remove Extra Columns ###
DECCsheets <-
  within(
    DECCsheets,
    rm(
      "RESTATS Ref",
      "ROC Ref",
      "Operational Month (0=previous years)",
      "Survey",
      "CAPACITY END of last year",
      "CAPACITY END of last"
    )
  )

####################################################################################################################
####### THis Code retains the most recent capacity column, and removes rows that have 0 capacity.            #######
####### This is particularly sensitive to changes in the format of the spreadsheet.                          #######
####### The code will still run if column names are not exact matches but capacity and 0s will not be tidied #######
####################################################################################################################

### Code for Q4 commented. Repeat for other Quarters ###

if ("Capacity Q4" %in% colnames(DECCsheets)) # Checks if there is a Capacity Q4 column in the data
{
  if (sum(as.numeric(DECCsheets$`Capacity Q4`), na.rm = TRUE) > 0) # Checks if the sum of that column is more than 0
  {
    DECCsheets$Capacity <- DECCsheets$`Capacity Q4` # Uses Q4 as the Capacity Column
    DECCsheets$'Capacity Q4' <- NULL # Removes other Columns
    DECCsheets$'Capacity Q3' <- NULL
    DECCsheets$'Capacity Q2' <- NULL
    DECCsheets$'Capacity Q1' <- NULL

  } else {
    DECCsheets$'Capacity Q4' <- NULL # If Column exists but is 0, then removes column and checks Column 3.
  }
}

if ("Capacity Q3" %in% colnames(DECCsheets))
{
  if (sum(as.numeric(DECCsheets$`Capacity Q3`), na.rm = TRUE) > 0)
  {
    DECCsheets$Capacity <- DECCsheets$`Capacity Q3`
    DECCsheets$'Capacity Q3' <- NULL
    DECCsheets$'Capacity Q2' <- NULL
    DECCsheets$'Capacity Q1' <- NULL

  } else {
    DECCsheets$'Capacity Q3' <- NULL
  }
}

if ("Capacity Q2" %in% colnames(DECCsheets))
{
  if (sum(as.numeric(DECCsheets$`Capacity Q2`), na.rm = TRUE) > 0)
  {
    DECCsheets$Capacity <- DECCsheets$`Capacity Q2`
    DECCsheets$'Capacity Q2' <- NULL
    DECCsheets$'Capacity Q1' <- NULL

  } else {
    DECCsheets$'Capacity Q2' <- NULL
  }
}

if ("Capacity Q1" %in% colnames(DECCsheets))
{
  if (sum(as.numeric(DECCsheets$`Capacity Q1`), na.rm = TRUE) > 0)
  {
    DECCsheets$Capacity <- DECCsheets$`Capacity Q1`

    DECCsheets$'Capacity Q1' <- NULL

  } else {
    DECCsheets$'Capacity Q1' <- NULL
  }
}

### If a capacity Column is created above, rearrange columns to place it as required ###

if ("Capacity" %in% colnames(DECCsheets)) {
  DECCsheets <-
    select(
      DECCsheets,
      "RenewableArea",
      "ProjectName",
      "SiteName",
      "Country",
      "Capacity",
      everything()
    )

  DECCsheets[DECCsheets == 0] <- NA # Set all 0 values to NA

  DECCsheets <- DECCsheets %>% drop_na(Capacity) # Remove rows where Capacity has an NA Value
}

###

#########################################################################################################



### Export to CSV ###
write.table(
  DECCsheets,
  "R Data Output/DECCOutput.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)


