library(shiny)

# Define UI for application 
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Positive cells for a selected probe:"),
  
  ### User input for probe and color ---------
  
  sidebarPanel(
    radioButtons("plotType", "Plot Type:", choices = c("Boxplot", "Cells")),
    textInput("probe", 
                "Probe:", 
                "cd3"),
    selectInput("color", 
                "Positive cell colour:", 
                choices = c("red","orange","green","blue","purple","black")),
    selectInput("line", 
                "Grid color", 
                choices = c("black", "white", "orange","red","blue","green","purple")),
    sliderInput("size", 
                "Cell size", 
                min = 0.2, max = 3, value = .8),
    sliderInput("density", 
                "Positive cell density", 
                min = 1, max = 99, value = 50),
    textInput("subProbe", 
                "Subset Probe:", 
                "dapi"),
    selectInput("subPos", 
                "Subset Pos / Neg:", 
                choices = c("+","-")),
    selectInput("subCol", 
                "subset Color", 
                choices = c("black", "white", "orange","red","blue","green","purple"))
  ),
  
  ### Show a plot of positive cells -------
  mainPanel(
    plotOutput("plotting", width = "100%", height = "600px")
  )
))