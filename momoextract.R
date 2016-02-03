momoextract <- function(directory=character, csvf=character) {
        
        setwd(directory)        # Default directory = ~/Documents/TRADEX/MyProjects/MOMO
        l <- 0                                          # Line at which we are writing
        total <- 0
        depot <- c()
        paiement <- c()
        retrait <- c()
        date <- c()
        station <- c()
        codeClient <- c()
        MomoReport <- data.frame(depot=integer(), 
                                 paiement=integer(), 
                                 retrait=integer(), 
                                 date=character(),
                                 station=character(),
                                 codeClient=integer(),
                                 stringsAsFactors = FALSE)
        
        # READ CSV FILES
        CodeStation <- read.csv("ListeDesSS.csv", sep=",", stringsAsFactors = FALSE, header = TRUE)
        Dataset <- read.csv(csvf, sep = ",", skip = 4, stringsAsFactors = FALSE, na.strings = "NA")
        
        Dataset$Date.Time2 <- as.Date( as.character(Dataset$Date.Time), "%d-%m-%Y")
        Retailers <- as.list(unique(as.character(subset(Dataset, Dataset$Retailer != "TRADEX" & Dataset$Retailer != "")[ ,9])))
        Dates <- as.list(unique(as.Date( as.character(Dataset$Date.Time), "%d-%m-%Y")))
        Dates <- Dates[!is.na(Dates)]
        
        # This dates will be used for file name
        StartDate <- strftime(Dates[[1]], "%d-%m-%Y")
        EndDate <- strftime(Dates[[length(Dates)]], "%d-%m-%Y")
        
        Services <- list("DEPOT", "PAIEMENT", "RETRAIT")
        
        for(d in 1:length(Dates)) {
                for(r in 1:length(Retailers)) {
                        l <- l+1                               
                        MomoReport[l, 4] <- strftime(Dates[[d]], "%d/%m/%Y")
                        MomoReport[l, 5] <- Retailers[[r]]
                        for(s in 1:length(Services)) {
                                total <- sum(as.integer( sub(",", "", subset(Dataset, Dataset$Service == Services[[s]] & Dataset$Retailer == Retailers[[r]] & Dataset$Date.Time2 %in% Dates[[d]])[ ,7] )))
                                if(total > 0) {
                                        if(Services[[s]] == 'DEPOT') MomoReport[l, 1] <- total
                                        if(Services[[s]] == 'PAIEMENT') MomoReport[l, 2] <- total
                                        if(Services[[s]] == 'RETRAIT') MomoReport[l, 3] <- total
                                }
                        }
                         
                }
                
        }
        
        # Find the correspondance between station name and account code
        for(i in 1:nrow(MomoReport)) {
                for(s in 1:nrow(CodeStation)) {
                        if (MomoReport[i, 5] == CodeStation[s, 2]) {
                                MomoReport[i, 6] <- CodeStation[s, 1]
                                break
                        }
                }
        }
        ExportFilename <- paste("MomoReport_", StartDate, "-", EndDate, ".csv", sep="")
        write.csv(MomoReport, file = ExportFilename, row.names = FALSE, na = "0")
        #head(MomoReport, 200)
}
