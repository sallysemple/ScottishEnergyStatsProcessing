library(readODS)
library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol


End_Use_Table <- read_ods("Data Sources/ECUK/ECUK - End Use Tables.ods", sheet = 'Table_U2', skip = 2)

End_Use_Table$Year <- End_Use_Table$Electricity*as.numeric(is.wholenumber(End_Use_Table$Electricity))

End_Use_Table$Year[End_Use_Table$Year == 0] <- NA

End_Use_Table <- fill(End_Use_Table, c(Year, Sector), .direction = 'down')

End_Use_Table[is.na(End_Use_Table)] <- 0

End_Use_Table$'End use'[End_Use_Table$'End use' == 0] <- NA

End_Use_Table <- End_Use_Table[c(10,1:9)]

End_Use_Table$Sector <- str_replace_all(End_Use_Table$Sector, "[:digit:]", "")

End_Use_Table <- melt(End_Use_Table, id=c('Year','Sector', 'End use'))

End_Use_Table <- End_Use_Table[complete.cases(End_Use_Table),]

End_Use_Table$Lookup <- paste0(End_Use_Table$Year,End_Use_Table$Sector,End_Use_Table$`End use`,End_Use_Table$variable)

End_Use_Table <- End_Use_Table[c(1,2,3,4,6,5)]

write.csv(
  End_Use_Table,
  "Output/ECUK/EndUseTable.csv"
)
