### CHECK THRESHOLDS

library(shiny)

# Define UI for application 
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Positive cells for a selected probe:"),
  
  ### User input for probe and color ---------
  
  sidebarPanel(
    textInput("probe", 
                "Probe:", 
                "dapi"),
    selectInput("color", 
                "Positive cell colour:", 
                choices = c("red","orange","green","blue","purple","black")),
    sliderInput("threshold", 
                "Threshold", 
                min = 0, max = 110, value = 30),
    sliderInput("size", 
                "Cell size", 
                min = 0.2, max = 3, value = .8),
    sliderInput("density", 
                "Positive cell density", 
                min = 1, max = 99, value = 50)
  ),
  
  ### Show a plot of positive cells -------
  mainPanel(
    plotOutput("plotting", width = "100%", height = "600px")
  )
))