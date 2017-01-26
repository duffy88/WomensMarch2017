# Scrape Womens March data
# Data compiled by Jeremy Pressman, UConn
# https://docs.google.com/spreadsheets/d/1xa0iLqYKz8x9Yc_rfhtmSOJQ2EGgeUVjvV4A8LsIaxY/htmlview?sle=true

library(gsheet)

url <- "https://docs.google.com/spreadsheets/d/1xa0iLqYKz8x9Yc_rfhtmSOJQ2EGgeUVjvV4A8LsIaxY/htmlview?sle=true"

march <- gsheet2tbl(url)

march <- march[ 7:nrow(march),1:10]

names(march) <- c("Place","State","Country","EstimateLow","EstimateHigh","Estimate3",
                  "DiffDate","Source1","Source2","Source3")


march <- march[ march$Place!="\n", ]


march$temp <- strsplit(march$Place,", ")
for( i in 1:nrow(march)){
  march$Place[i] <- march$temp[[i]][1]
  
}
march$temp <- NULL
march$Country <- gsub("US","United States", march$Country)
march$Country <- gsub("UK","United Kingdom", march$Country)

states <- c("Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut",
            "Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa",
            "Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota",
            "Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico",
            "New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania",
            "Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia",
            "Washington","West Virginia","Wisconsin","Wyoming","District of Columbia","Virgin Islands")
statesAbbv <- c("AL","AK","AZ","AR","CA","CO","CT",
                "DE","FL","GA","HI","ID","IL","IN","IA",
                "KS","KY","LA","ME","MD","MA","MI","MN",
                "MS","MO","MT","NE","NV","NH","NJ","NM",
                "NY","NC","ND","OH","OK","OR","PA",
                "RI","SC","SD","TN","TX","UT","VT","VA",
                "WA","WV","WI","WY","DC","VI")
# Replace Abbreviations with full State names
for(i in 1:nrow(march)){
  for(j in 1:length(states)){
    if(march$State[i]==statesAbbv[j]){
      march$State[i] <- states[j]
    }
    
  }
  
}

# Compose full location info to geocode later and location to write out in pop up
march$FullLocation <-march$Location <- NA
for(i in 1:nrow(march)){
  if(march$Country[i]=="United States"){
    march$FullLocation[i] <- paste(march$Place[i],march$State[i],march$Country[i], sep=", ")
    march$Location[i] <- paste(march$Place[i],march$State[i], sep=", ")
  }else if(march$Country[i]!=""){
    march$FullLocation[i] <- paste(march$Place[i],march$Country[i], sep=", ")
    march$Location[i] <- paste(march$Place[i],march$Country[i], sep=", ")
  }
  
  
}

# Organize source info btw link and source description
march$Source1Link <- march$Source2Link <- march$Source3Link <- NA
for(i in 1:nrow(march)){
  if(march$Source1[i]!=""){
    if(grepl("http", march$Source1[i])){
      march$Source1Link[i] <- march$Source1[i]
      march$Source1[i] <- "Source 1"
      
    }else {
      march$Source1[i] <- paste("Source 1 : ",march$Source1[i])
    }
  }else {
    march$Source1[i] <- NA
  }
  
  if(march$Source2[i]!=""){
    if(grepl("http", march$Source2[i])){
      march$Source2Link[i] <- march$Source2[i]
      march$Source2[i] <- "Source 2"
      
    }else {
      march$Source2[i] <- paste("Source 2 : ",march$Source2[i])
    }
  }else {
    march$Source2[i] <- NA
  }
  
  
  if(march$Source3[i]!=""){
    if(grepl("http", march$Source3[i])){
      march$Source3Link[i] <- march$Source3[i]
      march$Source3[i] <- "Source 3"
      
    }else {
      march$Source3[i] <- paste("Source 3 : ",march$Source3[i])
    }
    
  }else {
    march$Source3[i] <- NA
  }
  
  
}



write.csv(march,"data/MarchData(clean).csv", row.names = F)


