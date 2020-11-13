library(readxl)

print("LARenewables")

#Set Starting year for Loop
yearstart <- 2014

#Set Current Year to be loop end
yearend <- format(Sys.Date(), "%Y")


### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

### Loop to extract year sheets from source Data ###
for (year in yearstart:yearend) {
  # TryCatch allows the code to continue when there is an error.
  # This is used when there is no data for the corresponding year in the loop.
  
  tryCatch({
    #Allow Code to continue running even if there are errors ###
    
    ### Read Source Data ###
    LARenewables <-
      read_excel(
        "Data Sources/LA Renewables/Current.xlsx",
        sheet = paste("LA - Generation, ", year, sep = ""),
        skip = 2
      )
    
    ### Scottish Subset ###
    LARenewables <- subset(LARenewables, Country == "Scotland")
    
    ### Add Current Loop Year as Column ###
    LARenewables$Year <- year
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
  tryCatch({
    #Allow Code to continue running even if there are errors ###
    
    ### Read Source Data ###
    LARenewables <-
      read_excel(
        "Data Sources/LA Renewables/Current.xlsx",
        sheet = paste("LA - Generation, ", year, "r", sep = ""),
        skip = 2
      )
    
    ### Scottish Subset ###
    LARenewables <- subset(LARenewables, Country == "Scotland")
    
    ### Add Current Loop Year as Column ###
    LARenewables$Year <- year
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
}

### Export to CSV ###
write.table(
  LARenewables,
  "R Data Output/LARenewables.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)