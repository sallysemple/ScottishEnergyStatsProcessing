library(readxl)
library(readr)

print("ConsumerDebt")


PSR <- read_excel("Data Sources/Consumer Stats/Debt.xlsx", 
                   sheet = "PriorityServicesRegister", skip = 1)

names(PSR) <- c("Year", "ElecEngland", "ElecScotland", "ElecWales", "GasEngland", "GasScotland", "GasWales")

write_csv(PSR, "Output/Consumers/PriorityServicesRegister.csv")

RepaymentArrangement <- read_excel("Data Sources/Consumer Stats/Debt.xlsx", 
                  sheet = "RepaymentArrangement", skip = 1)

names(RepaymentArrangement) <- c("Year", "ElecEngland", "ElecScotland", "ElecWales", "GasEngland", "GasScotland", "GasWales")

write_csv(RepaymentArrangement, "Output/Consumers/RepaymentArrangement.csv")

Arrears <- read_excel("Data Sources/Consumer Stats/Debt.xlsx", 
                  sheet = "Arrears", skip = 1)

names(Arrears) <- c("Year", "ElecEngland", "ElecScotland", "ElecWales", "GasEngland", "GasScotland", "GasWales")

write_csv(Arrears, "Output/Consumers/ArrearsOnly.csv")

DebtRepayment <- read_excel("Data Sources/Consumer Stats/Debt.xlsx", 
                  sheet = "DebtRepayment", skip = 1)

names(DebtRepayment) <- c("Year", "ElecEngland", "ElecScotland", "ElecWales", "GasEngland", "GasScotland", "GasWales")

write_csv(DebtRepayment, "Output/Consumers/DebtRepayment.csv")
