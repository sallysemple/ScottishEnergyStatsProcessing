library(readODS)
library(readr)
library(readxl)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

### This script processes the ECUK End Tables into a machine readable format to be more easily used in calculations in other scripts. Also includes calculating the Industrial and Commercial proportions for Gas and Bioenergy###


# Function for returning whether a number is a whole number
is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol

# Load source data
End_Use_Table <- read_ods("Data Sources/ECUK/ECUK - End Use Tables.ods", sheet = 'Table_U2', skip = 4)

#Remove Notes Column

End_Use_Table$Notes <- NULL

names(End_Use_Table) <- c("Year", "Sector", "End use", "Gas", "Oil", "Solid fuel", "Electricity", "Heat sold", "Bioenergy & Waste", "Total")

# Melt the table into narrow format
End_Use_Table <- melt(End_Use_Table, id=c('Year','Sector', 'End use'))

# Remove incomplete data
End_Use_Table <- End_Use_Table[complete.cases(End_Use_Table),]

# Rename variables to match other R Scripts
End_Use_Table <- End_Use_Table %>% 
  mutate(`Sector` = replace(`Sector`, `Sector` == "Services", "Service")) 
  

# Create a lookup variable, combining year, sector, end use and variable name
End_Use_Table$Lookup <- paste0(End_Use_Table$Year,End_Use_Table$Sector,End_Use_Table$`End use`,End_Use_Table$variable)

# Rearrange to put the lookup variable before the value
End_Use_Table <- End_Use_Table[c(1,2,3,4,6,5)]

# Write to CSV
write.csv(
  End_Use_Table,
  "Output/ECUK/EndUseTable.csv"
)


x <- End_Use_Table

# Extract only Gas, the Industry and Service sectors, and the Overall total end use
GasSplit <- End_Use_Table[which(End_Use_Table$variable == "Gas" & End_Use_Table$Sector %in% c("Industry", "Service") & End_Use_Table$`End use` %in% c("Overall total")),]

# Cast Data to wide format (Year, industry and service being their own columns)
GasSplit <- dcast(GasSplit, Year ~ Sector)

# Divide Industry by the total of Industry and Service to get proportion that is Industry
GasSplit$Industry <- GasSplit$Industry / (GasSplit$Industry+GasSplit$Service)

# Get the inverse for the proportion that is Service
GasSplit$Service <- 1-GasSplit$Industry

# Name Columns
names(GasSplit) <- c("Year", "Gas - Industrial", "Gas - Commercial")







### Repeat for Bioenergy ###
BioenergySplit <- End_Use_Table[which(End_Use_Table$variable == "Bioenergy & Waste" & End_Use_Table$Sector %in% c("Industry", "Service") & End_Use_Table$`End use` %in% c("Overall total")),]

BioenergySplit <- dcast(BioenergySplit, Year ~ Sector)

BioenergySplit$Industry <- BioenergySplit$Industry / (BioenergySplit$Industry+BioenergySplit$Service)

BioenergySplit$Service <- 1-BioenergySplit$Industry

names(BioenergySplit) <- c("Year", "Bioenergy & Wastes - Industrial", "Bioenergy & Wastes - Commercial")

###

# Merge Bioenergy and Gas into one table

GasBioenergySplit <- merge(GasSplit, BioenergySplit)

# Combine with table with old years not in ECUK
OldGasBioenergySplit <- read_excel("Data Sources/Subnational Consumption/GasBioenergySplit.xlsx")
GasBioenergySplit <- bind_rows(OldGasBioenergySplit, GasBioenergySplit)

# Fill LACode (for Scotland) to each Row
GasBioenergySplit <- fill(GasBioenergySplit, `LA Code`, .direction = c("down"))

# Write to CSV
write_csv(GasBioenergySplit, "Output/Consumption/GasBioenergySplit.csv")


### Do it for Electricity

# Extract only Gas, the Industry and Service sectors, and the Overall total end use
ElectricitySplit <- End_Use_Table[which(End_Use_Table$variable == "Electricity" & End_Use_Table$Sector %in% c("Industry", "Service") & End_Use_Table$`End use` %in% c("Overall total")),]

# Cast Data to wide format (Year, industry and service being their own columns)
ElectricitySplit <- dcast(ElectricitySplit, Year ~ Sector)

# Divide Industry by the total of Industry and Service to get proportion that is Industry
ElectricitySplit$Industry <- ElectricitySplit$Industry / (ElectricitySplit$Industry+ElectricitySplit$Service)

# Get the inverse for the proportion that is Service
ElectricitySplit$Service <- 1-ElectricitySplit$Industry

# Name Columns
names(ElectricitySplit) <- c("Year", "Electricity - Industrial", "Electricity - Commercial")

# Combine with table with old years not in ECUK
OldElectricitySplit <- read_excel("Data Sources/Subnational Consumption/ElectricitySplit.xlsx")
ElectricitySplit <- bind_rows(OldElectricitySplit, ElectricitySplit)

# Fill LACode (for Scotland) to each Row
ElectricitySplit <- fill(ElectricitySplit, `LA Code`, .direction = c("down"))

# Write to CSV
write_csv(ElectricitySplit, "Output/Consumption/ElectricitySplit.csv")

