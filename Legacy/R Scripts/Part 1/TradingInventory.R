# library(readxl)
# library(readr)
# library(magrittr)
# library(tidyr)
# library(plyr)
# 
# print("TradingInventory")
# 
# ### Set Working Directory ###
# setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")
# 
# ### Read Source Data ###
# TradingInventory <-
#   read_excel(
#     "Data Sources/Greenhouse Gas Charts/Current.xlsx",
#     sheet = "Charts C3 and C4 data",
#     skip = 1
#   )
# 
# ### Rename Second Column ###
# colnames(TradingInventory)[2] <- "Baseline"
# 
# ### Export to CSV ###
# write.table(
#   TradingInventory,
#   "R Data Output/TradingInventory.txt",
#   sep = "\t",
#   na = "0",
#   row.names = FALSE
# )