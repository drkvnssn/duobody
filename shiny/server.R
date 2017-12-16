# install.packages("//vumc.nl/onderzoek$/s4e-gpfs1/pa-tgac-01/analisten/Dirk/r_scripts/DuoBody_Analysis/shiny_1.0.5.zip", repos = NULL, type = "win.binary", lib = "N:/Documenten/R/win-library/3.2")
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
                lineCol = input$line,
                subset = c(input$subProbe,input$subPos,input$subCol))
      } else {
        plotCellIntensity(data = data)
      }
    })
})
