plotCells <- function(data = NULL, probe = NULL, 
                      pch = 20, cex = 0.8,
                      posCol = "green", 
                      density = 80, magnification = 40,
                      bg = "#D3D3D3", gridBreaks = 3){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop("data structure is not in the correct format.\n\n")
  } 
  if(is.null(probe) == TRUE){
    cat("No probe name was given for plotting.\n ")
  }
  if(substr(posCol, 1, 1) != "#"){
    posCol <- .getColorHex(posCol)
  }
  
  ### PLOT TEXT, LABELS, COLORS
  sub.text.left <- paste("Total cells:", dim(data@xyData)[1])
  magnification.text <- paste0("Magnification: ", magnification,"x")
  if(is.null(probe) == TRUE){
    main.text <- paste(data@phenoData['samplename', 1])
  } else {
    probeColumn <- grep(colnames(data@assayData), pattern = probe, ignore.case = TRUE, fixed = FALSE)
    if(length(probeColumn) == 0){
      stop("Probe can not be found in data.\n")
    }
    main.text <- paste(data@phenoData['samplename', 1], ":",colnames(data@experimentData)[probeColumn])
    sub.text.middle <- paste("Positive Ratio:", round(data@experimentData['posRatio', probeColumn], digits = 1), "%")
    sub.text.right <- paste("Total positive cells:", data@experimentData['posCount', probeColumn])
    threshold.text <- paste("Threshold:", data@experimentData['threshold', probeColumn])
    posColor <- paste0(posCol, as.character(density))
    posColor <- rep(posColor, dim(data@assayData)[1])
    posCells <- data@posCellData[, probeColumn] 
  }
  ### CREATE EMPTY PLOT
  par(bg = bg)
  plot(data@xyData[,1], data@xyData[,2], 
       bty='n', col = bg, 
       main = main.text,
       xlab = colnames(data@xyData)[1],
       ylab = colnames(data@xyData)[2])
  mtext(magnification.text, side = 4 , adj = 0, cex = 0.8)
  mtext(sub.text.left, side = 3, adj = 0, cex = 0.8)
  
  ### PLOTTING THE CELLS
  points(data@xyData[,1], data@xyData[,2], 
         pch = pch, cex = cex,
         col = "#00000020",
         main = main.text)
  
  ### PLOTTING PROBE INFORMATION
  if(is.null(probe) == FALSE){
    points(x = data@xyData[posCells,1], y = data@xyData[posCells,2], 
           pch = pch, cex = cex,
           col = posColor[posCells])
    mtext(sub.text.middle, side = 3, cex = 0.8)
    mtext(sub.text.right, side = 3, adj = 1, cex = 0.8)
    mtext(threshold.text, side = 4 , adj = 1, cex = 0.8)
  }
  ### PLOT GRID
  .plotGrid(xyData = data@xyData, breaks = gridBreaks) 
}
