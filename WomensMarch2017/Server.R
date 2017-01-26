# Server for Womens March 2017
# By Doug Duffy 2016

# Load Packages
library(shiny)
library(leaflet)


# Load prepared dataset
march <- readRDS("data/MarchDataFinal.rds")

#
# Shiny Server
#

server <- function(input, output, session) {
  
  
  # Build main body of leaflet map, basic tiles only, points added later
  output$map <- renderLeaflet({
    
    leaflet(march) %>% addProviderTiles("CartoDB.Positron")
  })
  
  
  # Observe the addition and removal of points based on filtered data #3
  observe({
    
    data <- march[ !is.na(march$lon) & !is.na(march$lat),]
    
    # Remove points if null
    if(is.null(data)  ){ 
      leafletProxy("map", data = data) %>% clearMarkers()
      # If not null remove points and add new points
    }else {
      
      map2 <- leafletProxy("map", data = data) %>%
        clearMarkers() 
      
      if(nrow(data)>0){
        map2 %>% addCircleMarkers(radius = ~LowPtSize,  stroke = NA, color = "pink",
                                  fillOpacity = 0.7, layerId = ~FullLocation ,popup = ~HTML) %>%
          fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat))
      }
      
      
    }
    
  })
  
  
  # Add highlighting around point being clicked
  observe({
    click <- input$map_marker_click
    data <- march[ !is.na(march$lon) & !is.na(march$lat),]
    
    if(!is.null(click)  ){
      # Identify point clicked
      hl <- subset(data, FullLocation==click$id)
      # Remove previous highlighting
      lp <- leafletProxy("map", data = hl) %>% 
        removeMarker( layerId = "add") 
      
      # Add new highlighting only if there is a point to add
      if(nrow(hl) >0){
        lp %>% addCircleMarkers(radius = ~LowPtSize,  stroke = TRUE, color = "pink",weight=4,
                                fillOpacity = 0,opacity=1, layerId = "add")
      }
      
    }
    
  })
  
}