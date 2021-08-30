library(readr)
library(readxl)
library(plyr)
library(dplyr)
library(magrittr)
library(tidyverse)


RenElecLAList <- list()

yearstart <- 2013

yearend <- format(Sys.Date(), "%Y")

for (year in yearstart:yearend) {
  
  tryCatch({
    RenewableElecSitesLA <- read_excel("Data Sources/Renewable Generation/RenewableElecLA.xlsx", 
                                     sheet = paste0("LA - Sites ", year), skip = 1)
    
    RenewableElecSitesLA$Year <- year
    
    RenElecLAList[[year]] <- RenewableElecSitesLA
    
  }, error = function(e) {
    cat("ERROR :", conditionMessage(e), "\n")
  })
}

RenewableElecSitesLA <-bind_rows(RenElecLAList)

names(RenewableElecSitesLA)[1] <- "LACode"

RenewableElecSitesLA <- RenewableElecSitesLA[which(substr(RenewableElecSitesLA$LACode,1,2)== "S1"),]

RenewableElecSitesLA[3:5] <- NULL

RenewableElecSitesLA[3:15] %<>% lapply(function(x) as.numeric(as.character(x)))

Scotland <- RenewableElecSitesLA[3:16] %>% group_by(Year) %>% summarise_all(sum)

Scotland$LACode <- "S92000003"

Scotland$`Local Authority Name` <- "Scotland"
  
RenewableElecSitesLA <- rbind(RenewableElecSitesLA, Scotland)
write.table(RenewableElecSitesLA,
            "Output/Renewable Sites/LAOperationalRenSites.txt",
            sep = "\t",
            row.names = FALSE)