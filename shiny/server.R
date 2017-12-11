library(shiny)

# 1. load/source the MIPF functions
# 2. read MIPF file into 'data' vector
#   * data <- readMPIFfile(file = files)
# 3. run Shiny....

# Define server logic and plot
shinyServer(function(input, output){
    output$plotting <- renderPlot({
      if (identical(input$plotType, "Cells")) {
      # generate the plot for cells
      plotCells(data = data, probe = input$probe, 
                posCol = input$color,
                cex = input$size,
                density = input$density,
                lineCol = input$line)
      } else {
        cellIntensity(data = data)
      }
    })
})
