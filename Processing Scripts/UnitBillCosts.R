library(readxl)

print("UnitBillCosts")

ElectricityUnit <- read_excel("Data Sources/Energy Bills/ElectricityUnit.xlsx", 
                              sheet = "2019 Standard Electricity", skip = 4)[c(1,2,3,5,6,8,9,11,12)]

names(ElectricityUnit) <- c("Region", "Credit - Average variable unit price (£/kWh)", "Credit - Average fixed cost (£/year)", "Direct debit - Average variable unit price (£/kWh)", "Direct debit - Average fixed cost (£/year)", "Prepayment - Average variable unit price (£/kWh)", "Prepayment - Average fixed cost (£/year)", "Total - Average variable unit price (£/kWh)", "Total - Average fixed cost (£/year)")

ElectricityUnit <- ElectricityUnit[which(ElectricityUnit$Region %in% c("North Scotland", "South Scotland")),]

write.csv(ElectricityUnit, "Output/Energy Bills/ElecUnitCost.csv", row.names = FALSE)



GasUnit <- read_excel("Data Sources/Energy Bills/GasUnit.xlsx", 
                              sheet = "2019 Gas", skip = 4)[c(1,2,3,5,6,8,9,11,12)]

names(GasUnit) <- c("Region", "Credit - Average variable unit price (£/kWh)", "Credit - Average fixed cost (£/year)", "Direct debit - Average variable unit price (£/kWh)", "Direct debit - Average fixed cost (£/year)", "Prepayment - Average variable unit price (£/kWh)", "Prepayment - Average fixed cost (£/year)", "Total - Average variable unit price (£/kWh)", "Total - Average fixed cost (£/year)")

GasUnit <- GasUnit[which(GasUnit$Region %in% c("North Scotland", "South Scotland")),]

write.csv(GasUnit, "Output/Energy Bills/GasUnitCost.csv", row.names = FALSE)
