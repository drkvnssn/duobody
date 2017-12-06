plotCells <- function(data = NULL, probe = NULL, 
                      pch = 20, cex = 0.8, 
                      posCol = "green", density = 80, magnification = 40){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop("data structure is not in the correct format.\n\n")
  } 
  if(is.null(probe) == TRUE){
    stop("No probe name was given for plotting.\n ")
  }
  if(substr(posCol, 1, 1) != "#"){
    posCol <- GetColorHex(posCol)
  }
  
  probeColumn <- grep(colnames(data@assayData), pattern = probe, ignore.case = TRUE, fixed = FALSE)
  if(length(probeColumn) == 0){
    stop("Probe can not be found in data.\n")
  }
  main.text <- paste(data@phenoData['samplename', 1] , ":",colnames(data@experimentData)[probeColumn])
  sub.text.left <- paste("Total cells:", data@experimentData['totalCount', probeColumn])
  sub.text.middle <- paste("Positive Ratio:", round(data@experimentData['posRatio', probeColumn]), digits = 2)
  sub.text.right <- paste("Total positive cells:", data@experimentData['posCount', probeColumn])
  magnification.text <- paste0("Magnification: ", magnification,"x")
  
  plot(data@xyData[,1], data@xyData[,2], 
       pch = 20, cex = cex,
       col = "#00000020",
       main = main.text,
       xlab = colnames(data@xyData)[1],
       ylab = colnames(data@xyData)[2])
  mtext(sub.text.left, side = 3, adj = 0, cex = 0.8)
  mtext(sub.text.middle, side = 3, cex = 0.8)
  mtext(sub.text.right, side = 3, adj = 1, cex = 0.8)
  mtext(magnification.text, side = 4 , adj = 0, cex = 0.8)
  
  posColor <- paste0(posCol, as.character(density))
  posColor <- rep(posColor, dim(data@assayData)[1])
  posCells <- data@posCellData[, probeColumn] 
  points(x = data@xyData[posCells,1], y = data@xyData[posCells,2], 
         pch = pch, cex = cex,
         col = posColor[posCells])
}