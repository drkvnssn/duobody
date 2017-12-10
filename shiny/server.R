library(shiny)
functions.path <- "/Users/dirkvanessen/Documents/coding/R/duobody"
source(file.path(functions.path,"sourceDir.R"))
sourceDir(functions.path)

# Define server logic and plot
shinyServer(function(input, output){
  data.path <- "/Users/dirkvanessen/Documents/coding/R/duobody data daniella/data"
  files <- list.files(path = data.path, pattern = ".xlsx", full.names = TRUE)
  data <- readMPIFfile(file = files[1], verbose = FALSE)
    output$plotting <- renderPlot({
      # generate the plot for cells
      plotCells(data = data, probe = input$probe, posCol = input$color)
    })


})
