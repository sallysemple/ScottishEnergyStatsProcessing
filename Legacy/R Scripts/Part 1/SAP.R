### Set Working Directory ###
setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

print("SAP")

### Load Required Packages ###
library(readxl)

EERSAP2009 <- read_excel("Data Sources/Scottish Household Condition Survey/Current.xlsx", 
                          sheet = "Table 15", skip = 1, n_max = 2)

EERSAP2009[1:2] <- NULL

EERSAP2009 <- EERSAP2009[2,] 

### Export to CSV ###
write.table(
  EERSAP2009,
  "R Data Output/EERSAP2009.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)
  EERSAP2012 <- read_excel("Data Sources/Scottish Household Condition Survey/Current.xlsx", 
                           sheet = "Table 17", skip = 1, n_max = 2)
  
  EERSAP2012[1:2] <- NULL
  
  EERSAP2012 <- EERSAP2012[2,] 
  
  ### Export to CSV ###
  write.table(
    EERSAP2012,
    "R Data Output/EERSAP2012.txt",
    sep = "\t",
    na = "0",
    row.names = FALSE
  )
  
  EPCSAP2009 <- read_excel("Data Sources/Scottish Household Condition Survey/Current.xlsx", 
                           sheet = "Table 16", skip = 1, n_max = 9)
  
  EPCSAP2009 <- EPCSAP2009[-1,]
  
  ### Export to CSV ###
  write.table(
    EPCSAP2009,
    "R Data Output/EPCSAP2009.txt",
    sep = "\t",
    na = "0",
    row.names = FALSE
  )
  
  
  EPCSAP2012 <- read_excel("Data Sources/Scottish Household Condition Survey/Current.xlsx", 
                           sheet = "Table 18", skip = 1, n_max = 9)
  
  EPCSAP2012 <- EPCSAP2012[-1,]
  
  ### Export to CSV ###
  write.table(
    EPCSAP2012,
    "R Data Output/EPCSAP2012.txt",
    sep = "\t",
    na = "0",
    row.names = FALSE
  )
  
  