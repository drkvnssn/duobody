plotCells <- function(data = NULL, probe = NULL, 
                      pch = 20, cex = 0.8,
                      posCol = "green", 
                      density = 80, magnification = 40,
                      bg = "#D3D3D3", gridBreaks = 3,
                      lineCol = "black",
                      subset = NULL){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop("data structure is not in the correct format.\n\n")
  } 
  if(is.null(probe) == TRUE){
    cat("No probe name was given for plotting.\n ")
  }
  if(substr(posCol, 1, 1) != "#"){
    posCol <- .getColorHex(posCol)
  }
  if(substr(lineCol, 1, 1) != "#"){
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
    if(is.character(subset) == TRUE & length(subset) == 3){
      main.text <- paste0(main.text, " / ",subset[1],subset[2])
    }
    sub.text.middle <- paste(probe,"+  Ratio:", round(data@experimentData['posRatio', probeColumn], digits = 1), "%")
    sub.text.right <- paste0(probe,"+ : ", data@experimentData['posCount', probeColumn])
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
  
  ### PLOTTING Positive cells
  if(is.null(probe) == FALSE){
    points(x = data@xyData[posCells,1], y = data@xyData[posCells,2], 
           pch = pch, cex = cex,
           col = posColor[posCells])
    
  }
  ### PLOTTING THE SUBSET
  if(is.character(subset) == TRUE & length(subset) == 3){
    if(substr(subset[3], 1, 1) != "#"){
      subsetCol <- .getColorHex(subset[3])
    }
    subProbeColumn <- grep(colnames(data@assayData), pattern = subset[1], ignore.case = TRUE, fixed = FALSE)
    data.subset <- subsetProbe(data = data, probe = probe)
    subsetCol <- paste0(subsetCol, as.character(density))
    subsetCol <- rep(subsetCol, dim(data.subset@assayData)[1])
    
    if(tolower(subset[2]) == "pos" | tolower(subset[2]) == "+"){
      subsetCells <- data.subset@posCellData[, subProbeColumn] 
    } else {
      subsetCells <- !data.subset@posCellData[, subProbeColumn] 
    }
    points(x = data.subset@xyData[subsetCells,1], y = data.subset@xyData[subsetCells,2], 
           pch = pch, cex = (cex*0.5),
           col = subsetCol[subsetCells])
    sub.text.right <- paste0(sub.text.right, " / ", paste0(subset[1],subset[2]),": ", sum(subsetCells))
  }
  
  ### PLOT GRID
  mtext(sub.text.middle, side = 3, cex = 0.8)
  mtext(sub.text.right, side = 3, adj = 1, cex = 0.8)
  mtext(threshold.text, side = 4 , adj = 1, cex = 0.8)
  .plotGrid(xyData = data@xyData, breaks = gridBreaks,
            lineCol = lineCol) 
}