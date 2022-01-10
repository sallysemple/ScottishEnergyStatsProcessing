start.time <- Sys.time()
library(httr)
library(jsonlite)
library(lubridate)
library(plyr)
library(dplyr)
library(tidyverse)
library(reshape2)


### Set Working Directory
if(file.exists("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/Master R Script.R")){
  setwd("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing")
}

if(file.exists("//scotland/DC2/SUB_MC1_EID_Pub2/ENERGY BRANCH/Statistics/Energy Statistics Processing/Master R Script.R")){
  setwd("//scotland/DC2/SUB_MC1_EID_Pub2/ENERGY BRANCH/Statistics/Energy Statistics Processing")
}
options(stringsAsFactors = FALSE)

Header <- read_csv("National Grid/Header.csv")
List <- list()
listpos <- 1

url <- "https://api.carbonintensity.org.uk"
path <- "/regional/intensity/"
initialdate <- ymd_hm("2018-05-01T00:00Z")
#initialdate <- ymd_hm("2018-12-25T00:00Z")
regionlist <- c("1","2","16","18", "15")
time <- "00:00"

#ScotJan <- fromJSON("https://api.carbonintensity.org.uk/regional/intensity/2019-01-02T12:35Z/2019-01-12T12:35Z/regionid/16")
#Scotdata <- as_data_frame(jsonlite::flatten(do.call(data.frame,ScotJan)))
#Scotdata <- Scotdata %>% unnest(data.data.generationmix)
for (x in 1:5){
  regionid <- regionlist[x]
  datefrom <- initialdate
  
  
  repeat{
    
    dateto <- datefrom + ddays(13)
    
    print(paste(regionid, "-", dateto))
    
    datefromstring <- substring(as.character(datefrom),1,10)
    datetostring <- substring(as.character(dateto),1,10)
    
    
    
    tryCatch({
      result <- fromJSON(paste(url, path, datefromstring,"T",time,"Z","/",datetostring,"T",time,"Z","/regionid/",regionid, sep =""))
      resultdata <- as_data_frame(jsonlite::flatten(do.call(data.frame,result)))
      resultdata <- resultdata %>% unnest(data.data.generationmix)
      datefrom <- dateto
      Header2 <- merge(Header, resultdata,all=TRUE)
      List[[listpos]] <- Header2
      listpos <- listpos+1
    },
    error=function(error_message) {
      {message(error_message)
        message(dateto)
        message(datefrom)}})
    

    
    if (datefrom > Sys.Date()) break
    
  }
}

# 
# ### Add in Missing Data
# 
# initialdate <- ymd_hm("2018-12-30T00:00Z")
# 
# for (x in 1:4){
#   regionid <- regionlist[x]
#   datefrom <- initialdate
#   
#   repeat{
#     
#     dateto <- datefrom + ddays(1)
#     
#     datefromstring <- substring(as.character(datefrom),1,10)
#     datetostring <- substring(as.character(dateto),1,10)
#     
#     
#     
#     tryCatch({
#       result <- fromJSON(paste(url, path, datefromstring,"T",time,"Z","/",datetostring,"T",time,"Z","/regionid/",regionid, sep =""))
#       resultdata <- as_data_frame(jsonlite::flatten(do.call(data.frame,result)))
#       resultdata <- resultdata %>% unnest(data.data.generationmix)
#       datefrom <- dateto
#       Header <- merge(Header, resultdata,all=TRUE)
#     },
#     error=function(error_message) {
#       {message(error_message)
#         message(dateto)
#         message(datefrom)}})
#     
#     
#     
#     
#     if (datefrom > ymd_hm("2019-01-15T00:00Z")) break
#     
#   }
# }


###
Header <- bind_rows(List)
Header <- Header %>% distinct
finalresult<- dcast(Header, data.regionid + data.dnoregion
                    + data.shortname + data.data.from + data.data.to + data.data.intensity.forecast + data.data.intensity.index ~ fuel)

finalresult2 <- Header %>% distinct
write_csv(
  finalresult,
  "National Grid/FullData2019.csv"
)

finalresult2 <- finalresult

FullData2018 <- read.csv("J:/ENERGY BRANCH/Statistics/Energy Statistics Processing/National Grid/FullData2018.csv")

finalresult <- rbind(finalresult, FullData2018)

finalresult <- finalresult[order(finalresult$data.data.from,finalresult$data.regionid),]

finalresult <- finalresult %>% distinct(data.regionid,data.data.from, .keep_all = TRUE)

finalresult <- subset(finalresult, ymd_hm(finalresult$data.data.from) < ymd(Sys.Date()) )


NorthScotland <- subset(finalresult, data.regionid == 1)
SouthScotland <- subset(finalresult, data.regionid == 2)
Scotland <- subset(finalresult, data.regionid == 16)
GB <- subset(finalresult, data.regionid == 18)
England <- subset(finalresult, data.regionid == 15)
write_csv(
  NorthScotland,
  "National Grid/NorthScotland.csv"
)
write_csv(
  SouthScotland,
  "National Grid/SouthScotland.csv"
)
write_csv(
  Scotland,
  "National Grid/AllScotland.csv"
)
write_csv(
  GB,
  "National Grid/GB.csv"
)

write_csv(
  England,
  "National Grid/England.csv"
)

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
