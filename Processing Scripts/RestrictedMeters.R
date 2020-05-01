library(readxl)

source("Processing Scripts/LACodeFunction.R")

RestrictedMeters <- read_excel("Data Sources/Restricted Meters/RestrictedMeters.xlsx", 
                               sheet = "Economy 7")


RestrictedMeters[nrow(RestrictedMeters),2] <- "S92000003"

RestrictedMeters[2,2] <- ""

RestrictedMeters <- RestrictedMeters[c(4:35,2,37),]

RestrictedMeters <- LACodeUpdate(RestrictedMeters)

write.table(RestrictedMeters,
            "Output/Restricted Meters/RestrictedMeters.txt",
            sep = "\t",
            row.names = FALSE)



RestrictedMetersProp <- read_excel("Data Sources/Restricted Meters/RestrictedMeters.xlsx", 
                               sheet = "Percentage")


RestrictedMetersProp[nrow(RestrictedMetersProp),2] <- "S92000003"

RestrictedMetersProp[2,2] <- ""

RestrictedMetersProp <- RestrictedMetersProp[c(4:35,2,37),]

RestrictedMetersProp <- LACodeUpdate(RestrictedMetersProp)

write.table(RestrictedMetersProp,
            "Output/Restricted Meters/RestrictedMetersProp.txt",
            sep = "\t",
            row.names = FALSE)

# for(i in 3:ncol(RestrictedMetersProp)){
#   
#   names(RestrictedMetersProp)[i] <- paste("Percentage", names(RestrictedMetersProp)[i])
# }


