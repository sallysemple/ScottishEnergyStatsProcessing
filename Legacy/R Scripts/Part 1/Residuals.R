library(readxl)
library(readr)
library(magrittr)
library(tidyr)
library(plyr)

print("Residuals")

### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Set the first year for which there is Data, for use in a loop ###
# This is unlikely to change from 2005

yearstart <- 2005

### Set the final year for the loop as the current year ###
yearend <- format(Sys.Date(), "%Y")

### Read Source Data for Header ###
Residuals <-
  read_csv("Data Sources/Sub-National Residuals/Header.csv")

### LOOP ###
for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    ### Read Source Data, tab of the current year ###
    ResidualsWorking <-
      read_excel(
        "Data Sources/Sub-National Residuals/Current.xlsx",
        sheet = paste(year),
        col_names = FALSE
      )
    
    ### Subset Country Level information ###
    ResidualsWorking <-
      subset(
        ResidualsWorking,
        X__2 == "TOTAL SCOTLAND" |
          X__2 == "Wales" |
          X__2 == "England" | X__2 == "UNITED KINGDOM"
      )
    
    ### Add Current Loop year to its own column ###
    ResidualsWorking$Year <- year
    
    ### Merge Data to master dataframe ###
    Residuals <-
      merge(Residuals, ResidualsWorking, all = TRUE)
    
    ### Print any errors from the loop to the console ###
    # This should only be the years for which there is no data. Other errors may require code to be adjusted
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })

  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    ### Read Source Data, tab of the current year ###
    ResidualsWorking <-
      read_excel(
        "Data Sources/Sub-National Residuals/Current.xlsx",
        sheet = paste(year, "r", sep=""),
        col_names = FALSE
      )
    
    ### Subset Country Level information ###
    ResidualsWorking <-
      subset(
        ResidualsWorking,
        X__2 == "TOTAL SCOTLAND" |
          X__2 == "Wales" |
          X__2 == "England" | X__2 == "UNITED KINGDOM"
      )
    
    ### Add Current Loop year to its own column ###
    ResidualsWorking$Year <- year
    
    ### Merge Data to master dataframe ###
    Residuals <-
      merge(Residuals, ResidualsWorking, all = TRUE)
    
    ### Print any errors from the loop to the console ###
    # This should only be the years for which there is no data. Other errors may require code to be adjusted
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
} # Loop End

### Remove uneeded columns ###
Residuals[10:20] <- list(NULL)

### Apply Column Names from first row ###
names(Residuals) <- as.matrix(Residuals[1,])

### Remove First Row ###
Residuals <- Residuals[-1,]


Residuals$Year <- as.numeric(as.character(Residuals$Year))

### Convert to kWh ###
Residuals[3:9] %<>% lapply(function(x) as.numeric(as.character(x))*11.63)


### Create Scottish Subset ###
ScotlandResiduals <-
  subset(Residuals, Country == "TOTAL SCOTLAND")

### Export Table ###
write.table(
  ScotlandResiduals,
  "R Data Output/ScotlandResiduals.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### Create English Subset ###
EnglandResiduals <-
  subset(Residuals, Country == "England")

### Export ###
write.table(
  EnglandResiduals,
  "R Data Output/EnglandResiduals.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### Welsh Subset ###
WalesResiduals <- subset(Residuals, Country == "Wales")

### Export ###
write.table(
  WalesResiduals,
  "R Data Output/WalesResiduals.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)

### UK subset ###
UKResiduals <-
  subset(Residuals, Country == "UNITED KINGDOM")

### Export ###
write.table(
  UKResiduals,
  "R Data Output/UKResiduals.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)