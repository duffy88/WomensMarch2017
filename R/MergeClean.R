# Merge and Clean geocodes for womens march
# Prepare data for shiny app

library(shiny)

march <- read.csv("data/MarchData(clean).csv", stringsAsFactors = F)
lonlat <- readRDS("data/MarchLocations.rds")


march$EstimateLow <- gsub(",","", march$EstimateLow)
march$EstimateHigh <- gsub(",","", march$EstimateHigh)


march$EstimateLow <- as.numeric(march$EstimateLow)
march$EstimateHigh <- as.numeric(march$EstimateHigh)

names(lonlat) <- c("FullLocation","lon","lat")

march <- merge(march, lonlat, by="FullLocation", all.x=T)

march <- march[ !duplicated(march$FullLocation),]
march <- march[ march$Place!="Total US",]

# Fix missing where one estimate avail
for(i in 1:nrow(march)){
  if(!is.na(march$EstimateLow[i]) & !is.na(march$EstimateHigh[i])){
    if(march$EstimateLow[i]=="" & march$EstimateHigh[i]!=""){
      march$EstimateLow[i]  <- march$EstimateHigh[i]
    }
    if(march$EstimateHigh[i]=="" & march$EstimateLow[i]!=""){
      march$EstimateHigh[i]  <- march$EstimateLow[i]
    }
    
  }
  
}


march$LowPtSize <-   (log(as.numeric(march$EstimateLow )) * 1.7)
march$LowPtSize[march$LowPtSize < 3] <- 3

march$HighPtSize <-   (log(as.numeric(march$EstimateHigh ))* 1.7)
march$HighPtSize[march$HighPtSize < 3] <- 3

for(i in c("EstimateLow","EstimateHigh","Source1","Source2","Source3",
           "Source1Link","Source2Link","Source3Link")){
  march[ is.na(march[, i]), i ] <- ""
}

# Take only links from sources
for(i in 1:nrow(march)){
  if(march$Source1Link[i]=="" &march$Source2Link[i]!=""){
    march$Source1Link[i]<-march$Source2Link[i]
    march$Source2Link[i]<-""
    
  }
  if(march$Source2Link[i]=="" &march$Source3Link[i]!=""){
    march$Source2Link[i]<-march$Source3Link[i]
    march$Source3Link[i]<-""
  }
  
}
# Need 2x to move 3->1
for(i in 1:nrow(march)){
  if(march$Source1Link[i]=="" &march$Source2Link[i]!=""){
    march$Source1Link[i]<-march$Source2Link[i]
    march$Source2Link[i]<-""
    
  }
  if(march$Source2Link[i]=="" &march$Source3Link[i]!=""){
    march$Source2Link[i]<-march$Source3Link[i]
    march$Source3Link[i]<-""
  }
  
}


# Make HTML for each point
march$HTML <- NA
for(i in 1:nrow(march)){
  if(march$Source3Link[i]!=""){
    march$HTML[i] <- paste(
      paste("<div style = 'text-align:center;margin-top: 5px;margin-bottom:0px'><h5 style = 'padding:0;margin:0'>",
            march$Location[i],"</div></h5>"),
      paste("<div style = 'text-align:left;margin-top: 5px;margin-bottom:0px'><p style = 'padding:0;margin:0;text-decoration:underline'>",
            "Attendance Estimates : ","</p>"),
      paste("<p style = 'padding:0;margin:0'>",
            "Low : ",formatC(as.numeric(march$EstimateLow[i]), format="d", big.mark=','),"</p>"),
      paste("<p style = 'padding:0;margin:0'>",
            "High : ",formatC(as.numeric(march$EstimateHigh[i]), format="d", big.mark=','),"</p></div>"),
      paste("<div style = 'text-align:left;margin-top: 5px;margin-bottom:0px'><p style = 'padding:0;margin:0;text-decoration:underline'>",
            "Sources : ","</p>"),
      a( href = march$Source1Link[i],
         target = "_blank",
         "Source 1"),
      a( href = march$Source2Link[i],
         target = "_blank",
         "Source 2"),
      a( href = march$Source3Link[i],
         target = "_blank",
         "Source 3")  
    )
    
  }else if(march$Source2Link[i]!=""){
    march$HTML[i] <- paste(
      paste("<div style = 'text-align:center;margin-top: 5px;margin-bottom:0px'><h5 style = 'padding:0;margin:0'>",
            march$Location[i],"</div></h5>"),
      paste("<div style = 'text-align:left;margin-top: 5px;margin-bottom:0px'><p style = 'padding:0;margin:0;text-decoration:underline'>",
            "Attendance Estimates : ","</p>"),
      paste("<p style = 'padding:0;margin:0'>",
            "Low : ",formatC(as.numeric(march$EstimateLow[i]), format="d", big.mark=','),"</p>"),
      paste("<p style = 'padding:0;margin:0'>",
            "High : ",formatC(as.numeric(march$EstimateHigh[i]), format="d", big.mark=','),"</p></div>"),
      paste("<div style = 'text-align:left;margin-top: 5px;margin-bottom:0px'><p style = 'padding:0;margin:0;text-decoration:underline'>",
            "Sources : ","</p>"),
      a( href = march$Source1Link[i],
         target = "_blank",
         "Source 1"),
      a( href = march$Source2Link[i],
         target = "_blank",
         "Source 2")
    )
    
  }else if(march$Source1Link[i]!=""){
    march$HTML[i] <- paste(
      paste("<div style = 'text-align:center;margin-top: 5px;margin-bottom:0px'><h5 style = 'padding:0;margin:0'>",
            march$Location[i],"</div></h5>"),
      paste("<div style = 'text-align:left;margin-top: 5px;margin-bottom:0px'><p style = 'padding:0;margin:0;text-decoration:underline'>",
            "Attendance Estimates : ","</p>"),
      paste("<p style = 'padding:0;margin:0'>",
            "Low : ",formatC(as.numeric(march$EstimateLow[i]), format="d", big.mark=','),"</p>"),
      paste("<p style = 'padding:0;margin:0'>",
            "High : ",formatC(as.numeric(march$EstimateHigh[i]), format="d", big.mark=','),"</p></div>"),
      paste("<div style = 'text-align:left;margin-top: 5px;margin-bottom:0px'><p style = 'padding:0;margin:0;text-decoration:underline'>",
            "Sources : ","</p>"),
      a( href = march$Source1Link[i],
         target = "_blank",
         "Source 1")
    )
    
  }else {
    march$HTML[i] <- paste(
      paste("<div style = 'text-align:center;margin-top: 5px;margin-bottom:0px'><h5 style = 'padding:0;margin:0'>",
            march$Location[i],"</div></h5>"),
      paste("<div style = 'text-align:left;margin-top: 5px;margin-bottom:0px'><p style = 'padding:0;margin:0;text-decoration:underline'>",
            "Attendance Estimates : ","</p>"),
      paste("<p style = 'padding:0;margin:0'>",
            "Low : ",formatC(as.numeric(march$EstimateLow[i]), format="d", big.mark=','),"</p>"),
      paste("<p style = 'padding:0;margin:0'>",
            "High : ",formatC(as.numeric(march$EstimateHigh[i]), format="d", big.mark=','),"</p></div>")
      
    )
    
  }
  
  
  
}


saveRDS(march, "data/MarchDataFinal.rds")
saveRDS(march, "WomensMarch2017/data/MarchDataFinal.rds")
