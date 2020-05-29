library(readr)
library(lubridate)
library(zoo)

DomesticSuppliers <- read_csv("Data Sources/Ofgem/Domestic Suppliers/Domestic Sales.csv")

names(DomesticSuppliers)[c(1,4)] <- c("Date", "Dual")

DomesticSuppliers$Date <- dmy(paste0("01-",DomesticSuppliers$Date))


write.table(DomesticSuppliers,
            "Output/Domestic Sales/DomesticSuppliers.txt",
            sep = "\t",
            row.names = FALSE)
