.getDistance <- function(cell1, cell2){
    x <- abs(diff(c(as.numeric(cell1[1]), as.numeric(cell2[1]))))
    y <- abs(diff(c(as.numeric(cell1[2]), as.numeric(cell2[2]))))
    result <- sqrt(x**2 + y**2)
  return(result)
}
calculateDistance <- function(data = NULL,
                              probe1 = NULL, 
                              probe2 = NULL,
                              maxDist = 0.3, 
                              plot = TRUE){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop("data structure is not in the correct format.\n\n")
  } 
  if(is.null(probe1) == TRUE){
    cat("No probe name was given for plotting.\n ")
  }
  if(is.null(probe2) == TRUE){
    cat("No probe name was given for plotting.\n ")
  }
  
  probe1Column <- grep(colnames(data@assayData), pattern = probe1, ignore.case = TRUE, fixed = FALSE)
  probe2Column <- grep(colnames(data@assayData), pattern = probe2, ignore.case = TRUE, fixed = FALSE)
  subset1 <- subsetProbe(data = data, probe = probe1)
  subset2 <- subsetProbe(data = data, probe = probe2)
  subset1 <- subset1@xyData[subset1@posCellData[,probe1Column],]
  subset2 <- subset2@xyData[subset2@posCellData[,probe2Column],]
  
  result <- NULL
  for(i in 1:dim(subset1)[1]){
      for(z in 1:dim(subset2)[1]){
          distance <- .getDistance(subset1[i,],
                                   subset2[z,])
          if(distance < 0.02){
            result <- rbind(result, c(subset1[i,],
                                      subset2[z,], 
                                      distance))
          }
        }         
  if(i %% 100 == 0){
    cat(i , "cells have been done.\n")
  }
}


  if(plot == TRUE){
    plotCells(data = data, probe = probe1, posCol = "blue", 
              subset1 = c(probe2,"+","red"))
    segments(x0 = as.numeric(result[,1]), y0 =  as.numeric(result[,2]), 
             x1 = as.numeric(result[,3]), y1 = as.numeric(result[,4]),
             col = "yellow")
  }
  return(result)
}
