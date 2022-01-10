library(readxl)
library(plyr)
library(dplyr)
library(readr)
library("writexl")
library(lubridate)
library(reshape2)
library(tidyverse)

print("PipelineProjectsByTech")

source("Processing Scripts/OperationalCorrectionsREPD.R")

names(REPD) <- c("Ref", "County", "Authority", "Tech", "Status", "Operational", "Capacity", "Turbines", "LA", "LACode")

REPD <- REPD  %>% 
  mutate(`Tech` = replace(`Tech`, `Tech` == "Tidal Barrage and Tidal Stream", "Shoreline wave / tidal")) %>% 
  mutate(`Tech` = replace(`Tech`, `Tech` == "Shoreline Wave", "Shoreline wave / tidal")) %>% 
  mutate(`Tech` = replace(`Tech`, `Tech` == "Advanced Conversion Technologies", "Bioenergy and Waste")) %>% 
  mutate(`Tech` = replace(`Tech`, `Tech` == "Anaerobic Digestion", "Bioenergy and Waste")) %>% 
  mutate(`Tech` = replace(`Tech`, `Tech` == "Biomass (dedicated)", "Bioenergy and Waste")) %>% 
  mutate(`Tech` = replace(`Tech`, `Tech` == "EfW Incineration", "Bioenergy and Waste")) %>% 
  mutate(`Tech` = replace(`Tech`, `Tech` == "Landfill Gas", "Bioenergy and Waste")) 

REPD$Capacity <- 1

REPD <- REPD %>% dplyr::group_by(Tech, Status) %>% summarise(Capacity = sum(Capacity)) %>% dcast(Tech ~ Status)

REPD$Operational <- NULL

REPD[is.na(REPD)] <- 0

REPD$Total <- REPD$`Application Submitted` + REPD$`Awaiting Construction` + REPD$`Under Construction`

REPD <- REPD[which(REPD$Total > 0),]

names(REPD)[1:2] <- c("Type", "In Planning")

REPD <- REPD[order(REPD$Total),]

REPD <- REPD[c(1,5)]

PipelineProjects <- REPD

write_csv(PipelineProjects, "Output/REPD (Operational Corrections)/PipelineProjectsbyTech.csv")
