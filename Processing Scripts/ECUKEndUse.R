library(readODS)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

### This script processes the ECUK End Tables into a machine readable format to be more easily used in calculations in other scripts. Also includes calculating the Industrial and Commercial proportions for Gas and Bioenergy###


# Function for returning whether a number is a whole number
is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol

# Load source data
End_Use_Table <- read_ods("Data Sources/ECUK/ECUK - End Use Tables.ods", sheet = 'Table_U2', skip = 2)

# The year for each section is included in the electricity column. This code checks if each number is a whole number (only the year should be), and multiplies it by 1 if it is, and 0 if it is not. This creates a column with only the years and 0s in it.
End_Use_Table$Year <- End_Use_Table$Electricity*as.numeric(is.wholenumber(End_Use_Table$Electricity))

# Replaces the 0 years with NA
End_Use_Table$Year[End_Use_Table$Year == 0] <- NA

# Fills down the year column so that the year is in every row.
End_Use_Table <- fill(End_Use_Table, c(Year, Sector), .direction = 'down')

# Replaces NAs with 0 across the whole dataset.
End_Use_Table[is.na(End_Use_Table)] <- 0

# Replaces 0s in the End Use column with NA
End_Use_Table$'End use'[End_Use_Table$'End use' == 0] <- NA

# Rearrange dataset
End_Use_Table <- End_Use_Table[c(10,1:9)]

# Remove numbers from the Sector labels, leaving only the text 
End_Use_Table$Sector <- str_replace_all(End_Use_Table$Sector, "[:digit:]", "")

# Melt the table into narrow format
End_Use_Table <- melt(End_Use_Table, id=c('Year','Sector', 'End use'))

# Remove incomplete data
End_Use_Table <- End_Use_Table[complete.cases(End_Use_Table),]

# Create a lookup variable, combining year, sector, end use and variable name
End_Use_Table$Lookup <- paste0(End_Use_Table$Year,End_Use_Table$Sector,End_Use_Table$`End use`,End_Use_Table$variable)

# Rearrange to put the lookup variable before the value
End_Use_Table <- End_Use_Table[c(1,2,3,4,6,5)]

# Write to CSV
write.csv(
  End_Use_Table,
  "Output/ECUK/EndUseTable.csv"
)


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
