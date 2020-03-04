library(readxl)
library(readr)
library(tibble)

print("MarketShareSwitching")


MarketShare <- read_excel("Data Sources/Consumer Stats/MarketShareSwitching.xlsx", 
                                   skip = 2, n_max = 4, col_names = FALSE)
MarketShare <- as_tibble(t(MarketShare))

names(MarketShare) <- c("Region", "Large", "Medium", "Small")

MarketShare <- MarketShare[-1,]

write_csv(MarketShare, "Output/Consumers/MarketShare.csv")



MarketSwitching <- read_excel("Data Sources/Consumer Stats/MarketShareSwitching.xlsx", 
                          skip = 12)

names(MarketSwitching)[1] <- "Date"

MarketSwitching <- MarketSwitching[complete.cases(MarketSwitching),]

write_csv(MarketSwitching, "Output/Consumers/MarketSwitching.csv")