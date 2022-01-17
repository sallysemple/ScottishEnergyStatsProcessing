library(readxl)

###SOURCE DATA NEEDS TO BE UPDATED MANUALLY

EnergyComplaintsDistrict <- read_excel("Data Sources/MANUAL/EnergyComplaints.xlsx", sheet = "District")

write.table(EnergyComplaintsDistrict,
            "Output/Consumers/EnergyComplaintsDistrict.csv",
            sep = "\t",
            row.names = FALSE)

EnergyComplaintsOutcomes <- read_excel("Data Sources/MANUAL/EnergyComplaints.xlsx", sheet = "Outcomes")

write.table(EnergyComplaintsOutcomes,
            "Output/Consumers/EnergyComplaintsOutcomes.csv",
            sep = "\t",
            row.names = FALSE)

EnergyComplaintsType <- read_excel("Data Sources/MANUAL/EnergyComplaints.xlsx", sheet = "ComplaintType")

write.table(EnergyComplaintsType,
            "Output/Consumers/EnergyComplaintsType.csv",
            sep = "\t",
            row.names = FALSE)

EnergyComplaintsScotProp <- read_excel("Data Sources/MANUAL/EnergyComplaints.xlsx", sheet = "ScotProp")

write.table(EnergyComplaintsScotProp,
            "Output/Consumers/EnergyComplaintsScotProp.csv",
            sep = "\t",
            row.names = FALSE)
