start.time <- Sys.time()
library(readr)
library(readxl)
library(magrittr)
library(tidyr)
library(dplyr)
library(reshape2)
library(lubridate)

setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")

Header <- read_excel("J:/ENERGY BRANCH/Statistics/Planning Statistics database/Header.xlsx")

files <- list.files(path="J:/ENERGY BRANCH/Statistics/Planning Statistics database/Data/New Data (Dec 14 - present)/", pattern="*.csv", full.names=TRUE, recursive=FALSE)

ListLength <- length(files)

for (i in 1:ListLength){

data <- read_csv(files[i], col_names = FALSE)

if (is.na(data[1,1])){ 
  data[1:2] <- NULL
  data <- tail(data,-2)
}

if (is.na(data[1,2])){
  data <- tail(data, -4)
}
names(data) <- data[1,]
data$Time <- substring(as.character(files[i]),98, 120)

data$Time <- unlist(strsplit(data$Time, split='.', fixed=TRUE))[1]
data$Time <- sub("_", " ", data$Time)
data <- data[,colSums(is.na(data))<nrow(data)]


data <- subset(data, Country == "Scotland", select = c("Installed Capacity (MWelec)", "Development Status (short)", "Time"))
names(data) <- c("Capacity", "Status", "Time")
Header <- merge(Header, data, all = TRUE)
}

Header$Time <- paste("01 ", Header$Time, sep="")

Header$Time <- as.Date(Header$Time, format = "%d %B %Y")

Header <- group_by(Header, Time, Status)
Header <- dplyr::summarise(Header, Capacity = sum(as.numeric(Capacity), na.rm = TRUE))

Header <- dcast(Header, Time ~ Status)

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken

write.table(
  Header,
  "R Data Output/REPDTime.txt",
  sep = "\t",
  na = "0",
  row.names = FALSE
)