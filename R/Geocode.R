# Geocode March Cities

# Load Packages
library(ggmap)

march <- read.csv("data/MarchData(clean).csv", stringsAsFactors = F)

march <- march[ order(march$Place),]

for( i in 1:nrow(march)){
  
  if(!is.na(march$FullLocation[i])){
    lonlat <- geocode(march$FullLocation[i]) 
  }
  # Compile output of locations
  if(i ==1){
    temp2 <- cbind(march$FullLocation[i], lonlat)
    print(i)
  }else {
    temp2 <- rbind(temp2, cbind(march$FullLocation[i], lonlat))
    print(i)
  }
  
  if(i ==nrow(march)){
    saveRDS(temp2, "data/MarchLocations.rds")
    
  }
  
}
