### Load Packages ###
library(readr)
library(readxl)
library(dplyr)

print("GrowthSector")

GrowthSector <- list()

### Read Source File ###
GrowthSectorEmployment <-
  read_excel("Data Sources/Growth Sector Statistics/GS+database.xlsx",
             sheet = "Table 2.5",
             skip = 7,
             n_max = 11)


GrowthSectorEmployment[1] <- NULL

names(GrowthSectorEmployment)[1] <- "Category"

GrowthSectorEmployment <- GrowthSectorEmployment[which(GrowthSectorEmployment$Category == "Energy (including Renewables)"),]

GrowthSectorEmployment2 <- GrowthSectorEmployment

GrowthSectorEmployment[1,1] <- "NoPAYEOnly"

GrowthSectorEmployment[c(2,10:ncol(GrowthSectorEmployment))] <- NULL


GrowthSectorEmployment2[1,1] <- "WithPAYE"

GrowthSectorEmployment2[2:10] <- NULL

names(GrowthSectorEmployment2)[2] <- 2015


#GrowthSector <- merge(GrowthSector, GrowthSectorEmployment2, all = TRUE)

### Read Source File ###
GrowthSectorTurnover <-
  read_excel("Data Sources/Growth Sector Statistics/GS+database.xlsx",
             sheet = "Table 2.1 ",
             skip = 6,
             n_max = 11)


GrowthSectorTurnover[1] <- NULL

names(GrowthSectorTurnover)[1] <- "Category"

GrowthSectorTurnover <- GrowthSectorTurnover[which(substr(GrowthSectorTurnover$Category,1,6) == "Energy"),]

GrowthSectorTurnover[1,1] <- "Turnover"

#GrowthSector <- merge(GrowthSector, GrowthSectorTurnover, all = TRUE)

### Read Source File ###
GrowthSectorGVA <-
  read_excel("Data Sources/Growth Sector Statistics/GS+database.xlsx",
             sheet = "Table 2.2",
             skip = 6,
             n_max = 11)


GrowthSectorGVA[1] <- NULL

names(GrowthSectorGVA)[1] <- "Category"

GrowthSectorGVA <- GrowthSectorGVA[which(substr(GrowthSectorGVA$Category,1,6) == "Energy"),]

GrowthSectorGVA[1,1] <- "GVA"

#GrowthSector <- merge(GrowthSector, GrowthSectorTurnover, all = TRUE)

GrowthSectorExportsRUK <-
  read_excel("Data Sources/Growth Sector Statistics/GS+database.xlsx",
             sheet = "Table 5.1",
             skip = 6,
             n_max = 11)


GrowthSectorExportsRUK[1] <- NULL

names(GrowthSectorExportsRUK)[1] <- "Category"

GrowthSectorExportsRUK <- GrowthSectorExportsRUK[which(substr(GrowthSectorExportsRUK$Category,1,6) == "Energy"),]

GrowthSectorExportsRUK[1,1] <- "ExportsRUK"


#GrowthSector <- merge(GrowthSector, GrowthSectorExportsRUK, all = TRUE)

GrowthSectorExportsWorld <-
  read_excel("Data Sources/Growth Sector Statistics/GS+database.xlsx",
             sheet = "Table 5.2",
             skip = 6,
             n_max = 11)


GrowthSectorExportsWorld[1] <- NULL

names(GrowthSectorExportsWorld)[1] <- "Category"

GrowthSectorExportsWorld <- GrowthSectorExportsWorld[which(substr(GrowthSectorExportsWorld$Category,1,6) == "Energy"),]

GrowthSectorExportsWorld[1,1] <- "ExportsWorld"


#GrowthSector <- merge(GrowthSector, GrowthSectorExportsWorld, all = TRUE)

GrowthSector <- bind_rows(GrowthSectorEmployment,GrowthSectorEmployment2,GrowthSectorTurnover,GrowthSectorGVA,GrowthSectorExportsRUK,GrowthSectorExportsWorld)

GrowthSector <- GrowthSector[order(names(GrowthSector))]

GrowthSector <- GrowthSector[c(ncol(GrowthSector),1:ncol(GrowthSector)-1)]

GrowthSector <- as.data.frame(t(GrowthSector))

GrowthSector <- rownames_to_column(GrowthSector)

names(GrowthSector) <- GrowthSector[1,]

GrowthSector <- GrowthSector[-1,]

GrowthSector %<>% lapply(function(x) as.numeric(as.character(x)))

GrowthSector <- as_tibble(GrowthSector)

names(GrowthSector)[1] <- "Year"

write.csv(
  GrowthSector,
  "Output/Growth Sector/GrowthSector.csv",
  row.names = FALSE
)
