# UI for Womens March 2017
# By Doug Duffy 2016


# Load packages
library(shiny)
library(leaflet)

#
# Shiny UI function
#



shinyUI(fluidPage(
  
  # Leaflet Map output
  leafletOutput("map", width =1000, height = 600),
  absolutePanel(top = 532, left = 815, width = 250,
                div(style="background:white; opacity:0.7",
                    a( href = "http://dougduffy.com/",target = "_blank",
                       img(src = "Logo.png", width = "40px", height= "35px")),
                    a( href = "http://dougduffy.com/",target = "_blank",
                       img(src = "Header.png",width = "155px", height= "35px"))),
                    # Div for main styling
                    
                    div(style = "text-align:left; background-color:white; opacity:0.7;font-size: 12px;padding-right:4px;padding-left:8px", 
                        "Source :", 
                        a( href = "https://docs.google.com/spreadsheets/d/1xa0iLqYKz8x9Yc_rfhtmSOJQ2EGgeUVjvV4A8LsIaxY/htmlview?sle=true",
                           style ="text-decoration:none",target = "_blank",
                           "Pressman & Chenoweth")
                )
  )
  
)
)