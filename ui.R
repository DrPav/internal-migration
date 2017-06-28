#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(leaflet)

LAs <- readRDS("local_authorities.rds")
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Net internal migration by local authority"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("LA", "Local Authority",
                   choices = LAs )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("timeSeriesPlot", width = "95%")
    )
  ),
  tags$hr(),
  tags$h1("Net internal migration by age group"),
  sidebarLayout(
    sidebarPanel(
      selectInput("ageGroup", "Age group",
                  choices = c("U18",
                              "18-25",
                              "26-35",
                              "36-55",
                              "O55") )
    ),
    # Show a map
    mainPanel(
      leafletOutput("map", height = 800, width = "95%")
    )
  )    
))
