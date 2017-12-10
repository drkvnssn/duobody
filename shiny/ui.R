library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Positive cells for a selected probe:"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    selectInput("probe", 
                "Probe:", 
                choices = c("PD1","CD163","CD3","CD8","PDL1","PAX5")),
    selectInput("color", 
                "Colour:", 
                choices = c("red","orange","green","blue","purple","black"))
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("plotCells")
  )
))