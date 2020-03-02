library(readxl)
library(readr)

print("MarketShareSwitching")


MarketShare <- read_excel("Data Sources/Consumer Stats/MarketShareSwitching.xlsx", 
                                   skip = 2, n_max = 3)

names(MarketShare)[1] <- "Size"

MarketShare[1,1] <- "Large"

write_csv(MarketShare, "Output/Consumers/MarketShare.csv")



MarketSwitching <- read_excel("Data Sources/Consumer Stats/MarketShareSwitching.xlsx", 
                          skip = 12)

names(MarketSwitching)[1] <- "Date"

MarketSwitching <- MarketSwitching[complete.cases(MarketSwitching),]

write_csv(MarketSwitching, "Output/Consumers/MarketSwitching.csv")