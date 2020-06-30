library(readr)
library(readxl)
library(tidyverse)
library(magrittr)
library(data.table)

NonDomUrbanRural <- read_excel("Data Sources/RHI/Latest.xlsx", 
                     sheet = "S1.2", col_names = FALSE, skip = 25, 
                     n_max = 13)

NonDomUrbanRural <- NonDomUrbanRural[c(1,2,3,6,7)]

names(NonDomUrbanRural) <- c("Tech", "Urban On-grid", "Urban off-grid", "Rural On-grid", "Rural off-grid")

NonDomUrbanRural$`Total Urban` <- NonDomUrbanRural$`Urban On-grid`+ NonDomUrbanRural$`Urban off-grid`

NonDomUrbanRural$`Total Rural`<- NonDomUrbanRural$`Rural On-grid` + NonDomUrbanRural$`Rural off-grid`

NonDomUrbanRural$`Total on-grid` <- NonDomUrbanRural$`Rural On-grid` +NonDomUrbanRural$`Urban On-grid`

NonDomUrbanRural$`Total off-grid`<-  NonDomUrbanRural$`Rural off-grid`+ NonDomUrbanRural$`Urban off-grid` 

NonDomUrbanRural$Total <- NonDomUrbanRural$`Total Urban` + NonDomUrbanRural$`Total Rural`

write.table(NonDomUrbanRural,
            "Output/RHI/NonDomUrbanRural.txt",
            sep = "\t",
            row.names = FALSE)

DomUrbanRural <- read_excel("Data Sources/RHI/Latest.xlsx", 
                               sheet = "S2.5", col_names = FALSE, skip = 18, 
                               n_max = 5)

DomUrbanRural <- DomUrbanRural[c(1,2,3,6,7)]

names(DomUrbanRural) <- c("Tech", "Urban On-grid", "Urban off-grid", "Rural On-grid", "Rural off-grid")

DomUrbanRural$`Total Urban` <- DomUrbanRural$`Urban On-grid`+ DomUrbanRural$`Urban off-grid`

DomUrbanRural$`Total Rural`<- DomUrbanRural$`Rural On-grid` + DomUrbanRural$`Rural off-grid`

DomUrbanRural$`Total on-grid` <- DomUrbanRural$`Rural On-grid` +DomUrbanRural$`Urban On-grid`

DomUrbanRural$`Total off-grid`<-  DomUrbanRural$`Rural off-grid`+ DomUrbanRural$`Urban off-grid` 

DomUrbanRural$Total <- DomUrbanRural$`Total Urban` + DomUrbanRural$`Total Rural`

write.table(DomUrbanRural,
            "Output/RHI/DomUrbanRural.txt",
            sep = "\t",
            row.names = FALSE)
