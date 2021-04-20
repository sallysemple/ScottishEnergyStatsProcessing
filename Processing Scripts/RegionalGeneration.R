library(readxl)

Regional_Generation <- read_excel("Data Sources/Regional Generation/Regional Generation.xlsx", 
                                        sheet = "Electricity generation by fuel")

Range <- max(as.numeric(Regional_Generation[2,]), na.rm = TRUE) - min(as.numeric(Regional_Generation[2,]), na.rm = TRUE)

for(i in 1:Range){
  
  Regional_Generation[2,(5*i)-2] <- as.character(i+2003)
  Regional_Generation[2,(5*i)-1] <- as.character(i+2003)
  Regional_Generation[2,(5*i)] <- as.character(i+2003)
  Regional_Generation[2,(5*i)+1] <- as.character(i+2003)
  Regional_Generation[2,(5*i)+2] <- as.character(i+2003)

}

Regional_Generation <- tail(Regional_Generation, -1)

Regional_Generation <- head(Regional_Generation, -11)

Regional_Generation[2] <- c("Year", "Country", 
                            "Major - Coal", "Major - Oil", "Major - Gas", "Major - Nuclear", "Major - Hydro flow", "Major - Wind", "Major - Solar", "Major Bioenergy", "Major - Other Fuels" )
