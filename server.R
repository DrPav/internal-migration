#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(leaflet)
library(rgdal)


df <- readRDS("flow-by-LA-year-age.rds")
shpfile <- readOGR("shapefile/Local_Authority_Districts_December_2014_Super_Generalised_Clipped_Boundaries_in_Great_Britain.shp", layer = "Local_Authority_Districts_December_2014_Super_Generalised_Clipped_Boundaries_in_Great_Britain" ) %>%
  spTransform(CRSobj=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$timeSeriesPlot <- renderPlotly({
    
    # select data based on input selected
    x <- df %>% filter(Area == input$LA)
    
    # Make the plot
    gg <- ggplot(x, aes(x = year, y = netMigration, colour = ageGroup)) + geom_line(size = 1) + theme_minimal() +
      geom_hline(yintercept = 0, + scale_colour_brewer(palette = "Set1")) 
    ggplotly(gg)
    
  })
  
  output$map <- renderLeaflet({
    x <- df %>% filter(year == 2015) %>% filter(ageGroup == input$ageGroup)
    s <- shpfile
    s@data <- left_join(s@data, x, by = c("lad14cd" = "LACode"))
    
    MAX <- abs(s$netMigration) %>% max(na.rm = T)
    pal <- colorNumeric(
      palette = "PuOr",
      domain = c(-MAX, MAX)
    )
    
    map <- leaflet(s) %>% addProviderTiles("CartoDB.Positron") %>%
      addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 0.8,
                  color = ~pal(netMigration)
      ) %>%
      addLegend("topright", pal = pal, values = ~netMigration,
                title = "Net internal migration",
                #labFormat = labelFormat(prefix = "$"),
                opacity = 0.95
      )
    map
  })
  
})
