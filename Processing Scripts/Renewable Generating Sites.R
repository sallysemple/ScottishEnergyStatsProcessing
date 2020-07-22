library(magrittr)


yearstart <- 2003


yearend <- format(Sys.Date(), "%Y")

RenewableList <- list()

for (year in yearstart:yearend) {

  
  tryCatch({

    
    Renewable_Sites <- read_excel("Data Sources/Renewable Generation/Renewable Sites.xls", 
                                  sheet = paste0("# ", year), skip = 2)
    
    names(Renewable_Sites)[1] <- "Region"
    
    Renewable_Sites <- Renewable_Sites[which(Renewable_Sites$Region == "Scotland"),] 
    
    Renewable_Sites %<>% lapply(function(x) as.numeric(as.character(x)))

    Renewable_Sites$Year <- year
    
    RenewableList[[year]] <- Renewable_Sites

  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
  
}

Renewable_Sites <- bind_rows(RenewableList)

Renewable_Sites$Region <- NULL

Renewable_Sites[is.na(Renewable_Sites)] <- 0

Renewable_Sites$Wind <- Renewable_Sites$Wind2 

Renewable_Sites$`Bioenergy and Waste` <- Renewable_Sites$`Landfill gas` + Renewable_Sites$`Other bioenergy3`  + Renewable_Sites$`Sewage gas` + Renewable_Sites$AD + Renewable_Sites$`Biomass and waste3`

Renewable_Sites <- select(Renewable_Sites, "Year", "Wind", "Hydro", "Wave and tidal", "Solar PV", "Bioenergy and Waste", "Total")

