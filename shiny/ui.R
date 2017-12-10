library(shiny)

# Define UI for application 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Positive cells for a selected probe:"),
  
  # User input for probe and color
  sidebarPanel(
    selectInput("probe", 
                "Probe:", 
                choices = c("PD1","CD163","CD3","CD8","PDL1","PAX5")),
    selectInput("color", 
                "Colour:", 
                choices = c("red","orange","green","blue","purple","black"))
  ),
  
  # Show a plot of positive cells
  mainPanel(
    plotOutput("plotting")
  )
))