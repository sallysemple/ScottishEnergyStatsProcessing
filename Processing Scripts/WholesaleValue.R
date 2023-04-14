library(readr)
library(readr)

print("WholesaleValue")

source("Processing Scripts/Exports to GB.R")
source("Processing Scripts/Exports to NI.R")

ExportsGB <- read_delim("Output/Exports/ExportsGB.txt", 
                        "\t", escape_double = FALSE, trim_ws = TRUE)

ExportsNI <- read_delim("Output/Exports/ExportsNI.txt", 
                        "\t", escape_double = FALSE, trim_ws = TRUE)

Monthly_Electricity_Prices <- read_csv("Data Sources/Ofgem/Monthly Electricity Prices/Monthly Electricity Prices.csv")

names(Monthly_Electricity_Prices)[1] <- "Month Year"

Monthly_Electricity_Prices$`Month Year` <- format(dmy(Monthly_Electricity_Prices$`Month Year`), format = "%b %Y")

Monthly_Electricity_Prices$Price <- Monthly_Electricity_Prices$Price*1000

ExportPrices <- merge(merge(ExportsGB, ExportsNI), Monthly_Electricity_Prices)

ExportPrices$WholesaleValue <- (ExportPrices$`Exports to GB` + ExportPrices$`Exports to NI`) * (ExportPrices$Price)

write.table(ExportPrices,
            "Output/Exports/WholesaleValue.txt",
            sep = "\t",
            row.names = FALSE)
