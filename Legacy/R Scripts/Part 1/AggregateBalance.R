library(readr)
library(readxl)
library(dplyr)
library(data.table)

print("AggregateBalance")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

yearstart <- 1990

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")

DataList <- list()


for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    ### Load the Data from Sub-National total final energy Consumption, from the corresponding Year tab ###
    # If the Year does not have an associated tab, an error will be printed in the console, and
    # and the rest of the code WITHIN the loop will not be ran. Code after the loop will still be executed.
    # skip and n_max allow only the necessary data to be extracted
    
Data <- read_excel("Data Sources/Aggregate energy balance/Current.xls", 
                      sheet = paste(year), skip = 2)
names(Data)[c(1,3,6,7)] <- c("Type", "Manufactured Fuels", "Natural Gas", "Bioenergy & waste")

Data <- subset(Data, Type == "Industry" | Type == "Commercial")

Data <- Data[2:11]

Data[3,] <- Data[1,] + Data[2,]

Data[3,] <- Data[1,] / Data[3,]

Data <- Data[3,]

Data$Year <- year

DataList[[length(DataList)+1]] <- Data[c(11,1:10)]

### Print any errors from the loop to the console ###
# This should only be the years for which there is no data. Other errors may require code to be adjusted
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
}

IndustryPropotion <- bind_rows(DataList)

### Export to CSV
write.table(
  IndustryPropotion,
  "R Data Output/AggBalanceIndustryPropotion.txt",
  sep = "\t",
  na = " ",
  row.names = FALSE
)
