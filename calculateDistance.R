.getDistance <- function(X){
  x.dist <- abs(diff(c(X[1], X[3])))
  y.dist <- abs(diff(c(X[2], X[4])))
  result <- sqrt(x.dist**2 + y.dist**2)
  return(result)
}
calculateDistance <- function(data = NULL,
                              probe1 = NULL, 
                              probe2 = NULL,
                              maxDist = 0.01, 
                              posCel = "green",
                              plot = TRUE,
                              lineCol = "purple",
                              verbose = TRUE){
  
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop("data structure is not in the correct format.\n\n")
  } 
  if(is.null(probe1) == TRUE){
    cat("No probe name was given for plotting.\n ")
  }
  if(is.null(probe2) == TRUE){
    cat("No probe name was given for plotting.\n ")
  }
  
  probe1Column <- grep(colnames(data@assayData), pattern = probe1[1], ignore.case = TRUE, fixed = FALSE)
  probe2Column <- grep(colnames(data@assayData), pattern = probe2[1], ignore.case = TRUE, fixed = FALSE)
  subset1 <- subsetProbe(data = data, probe = probe1[1])
  subset2 <- subsetProbe(data = data, probe = probe2[1])
  subset1 <- subset1@xyData[subset1@posCellData[,probe1Column],]
  subset2 <- subset2@xyData[subset2@posCellData[,probe2Column],]
  
  result <- NULL
  if(verbose == TRUE){ 
    cat("\nCalculating the distance between the positive cells of", probe1[1], "and", probe2[1], ".\n")
  }
  pb <- txtProgressBar(min = 0, max = dim(subset1)[1], style = 3)
  for(i in 1:dim(subset1)[1]){
    cellPositions <- cbind(rep(as.numeric(subset1[i,1]), dim(subset2)[1]),
                           rep(as.numeric(subset1[i,2]), dim(subset2)[1]), 
                           as.numeric(subset2[,1]),
                           as.numeric(subset2[,2]))
    
    distance <- apply(X = cellPositions, FUN = .getDistance, MARGIN = 1) 
    result <- rbind(result, cbind(cellPositions, distance))
    setTxtProgressBar(pb, i)
  }         
  colnames(result) <- c(paste0("x.", probe1[1]), 
                        paste0("y.", probe1[1]),
                        paste0("x.", probe2[1]),
                        paste0("y.", probe2[1]),
                        "distance (mm)")
  result <- result[(as.numeric(result[,5]) < maxDist),]
  
  if(length(probe1) == 2){
    posCol <- probe1[2]
  } 
  if(length(probe2) == 2){
    subset1 <- c(probe2[1],"+",probe2[2])
  } else { 
    subset1 <- c(probe2[1],"+","red")
  }
  if(plot == TRUE){
    plotCells(data = data, 
              probe = probe1[1], 
              posCol = posCol, 
              subset1 = subset1)
    segments(x0 = result[,1], y0 = result[,2], 
             x1 = result[,3], y1 = result[,4],
             col = lineCol)
  }
  return(result)
}
