library(readr)
library(readxl)
library(tidyverse)
library(reshape2)
library(readr)
library(lubridate)
library(zoo)
library("writexl")

print("OperationalCapBySize")


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

DECCsheets <-
  read_excel_allsheets("Data Sources/RESTATS/ScotlandCapacity.xlsx")

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


DECCsheets <- DECCsheets %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Anaerobic Digestion", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Photovoltaics", "Solar Photovoltaics")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Small Hydro", "Hydro")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Large Hydro", "Hydro")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Wind Onshore", "Wind Onshore")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Wind Offshore", "Wind Offshore")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Landfill Gas", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Landfill gas", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Sewage Sludge Digestion", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Biomass", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Poultry Litter", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Municipal Solid Waste Combustion", "Biomass and Waste")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Shoreline Wave", "Shoreline wave / tidal")) %>% 
  mutate(`RenewableArea` = replace(`RenewableArea`, `RenewableArea` == "Tidal", "Shoreline wave / tidal")) 

DECCsheets <- DECCsheets[1:5]

DECCsheets$CapacityBand <- "50MW +"

DECCsheets[which(DECCsheets$`Capacity` < 50),]$CapacityBand <- "10-50MW"
DECCsheets[which(DECCsheets$`Capacity` < 10),]$CapacityBand <- "5 - 10MW"
DECCsheets[which(DECCsheets$`Capacity` < 5),]$CapacityBand <- "<5MW"

DECCsheets[which(substr(DECCsheets$ProjectName,1,4) == "FIT-"),]$CapacityBand <- "<5MW"

DECCsheets <- DECCsheets %>%  group_by(`RenewableArea`,   CapacityBand) %>% 
  summarise(`Capacity` = sum(`Capacity`, na.rm = TRUE))

Table <- dcast(DECCsheets, `RenewableArea` ~ CapacityBand, value.var = "Capacity")

Table[is.na(Table)] <- 0

Table$Total <- Table$`10-50MW`+Table$`5 - 10MW`+Table$`50MW +`+Table$`<5MW`

Table <- Table[order(-Table$Total),]

names(Table)[1] <- "Technology Type"

###




QTRCapacityScotland <- read_delim("Output/Quarter Capacity/QTRCapacityScotland.txt", 
                                  "\t", escape_double = FALSE, trim_ws = TRUE)

QTRCapacityScotland <- tail(QTRCapacityScotland,1)

Table[which(Table$`Technology Type` == "Wind Onshore"),]$Total <- QTRCapacityScotland$`Onshore Wind`
Table[which(Table$`Technology Type` == "Wind Offshore"),]$Total <- QTRCapacityScotland$`Offshore Wind`
Table[which(Table$`Technology Type` == "Hydro"),]$Total <- QTRCapacityScotland$`Small scale Hydro` + QTRCapacityScotland$`Large scale Hydro`
Table[which(Table$`Technology Type` == "Solar Photovoltaics"),]$Total <- QTRCapacityScotland$`Solar photovoltaics`
Table[which(Table$`Technology Type` == "Biomass and Waste"),]$Total <-  QTRCapacityScotland$`Anaerobic Digestion` + 
                                                                        QTRCapacityScotland$`Landfill gas` + 
                                                                        QTRCapacityScotland$`Sewage sludge digestion` + 
                                                                        QTRCapacityScotland$`Energy from waste` + 
                                                                        QTRCapacityScotland$`Animal Biomass (non-AD)`  + 
                                                                        QTRCapacityScotland$`Plant Biomass`
Table[which(Table$`Technology Type` == "Shoreline wave / tidal"),]$Total <- QTRCapacityScotland$`Shoreline wave / tidal`

Table$`<5MW` <- Table$Total - Table$`50MW +` - Table$`10-50MW` - Table$`5 - 10MW`

x <-as_tibble(t(as.data.frame(colSums(Table[2:6], na.rm=TRUE))))
x$`Technology Type` <- "All Technologies"

Table <- rbind(Table,x)

write.table(Table[c(1,2,4,3,5,6)],
          "Output/Capacity by Size/CapacitySizeTech.txt",
          sep = "\t",
          row.names = FALSE)


