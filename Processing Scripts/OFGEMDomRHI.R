library(readxl)

OFGEM_RHIDom <- read_excel("Data Sources/MANUAL/OFGEM RHIDom.xlsx")

OFGEM_RHIDom <- OFGEM_RHIDom[c(1,2,4,3,5,6)]
  
names(OFGEM_RHIDom) <- c("Region", "Air Source - Accredited Applications", "Ground Source - Accredited Applications", "Biomass - Accredited Applications", "Solar Thermal - Accredited Applications", "Total - Accredited Applications")

write.table(OFGEM_RHIDom,
            "Output/RHI/OFGEMRHIDom.txt",
            sep = "\t",
            row.names = FALSE)