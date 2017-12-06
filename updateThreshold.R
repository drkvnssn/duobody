updateThreshold <- function(data = NULL, probe = NULL, threshold = NULL, 
                            plot = TRUE, col = "red", verbose = TRUE){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  if(is.null(probe) == TRUE){
      stop("No probe name was given to update.\n ")
  }
  if(is.null(threshold) == TRUE){
    stop("No threshold data was given for update.\n ")
  }
  
    probeColumn <- grep(colnames(assayData), pattern = probe, ignore.case = TRUE, fixed = FALSE)
    #thresholdRow <- grep(threshold.data[,1],  pattern = probe, ignore.case = TRUE, fixed = FALSE)
    #experimentColumn <- grep(colnames(assayData), pattern = probe, ignore.case = TRUE, fixed = FALSE)
    
    data@experimentData['posMean', probeColumn] <- .cellAverage(x = data@assayData[,probeColumn], 
                                                            threshold = threshold,
                                                            type = "pos", algorithm = "mean")
    data@experimentData['posMedian', probeColumn] <- .cellAverage(x = data@assayData[,probeColumn], 
                                                                  threshold = threshold,
                                                                  type = "pos", algorithm = "median")
    data@experimentData['posMode', probeColumn] <- .cellAverage(x = data@assayData[,probeColumn], 
                                                                threshold = threshold,
                                                                type = "pos", algorithm = "mode")
    
    data@experimentData['threshold', probeColumn] <- threshold
    data@experimentData['posCount', probeColumn] <- .cellCount(x = data@assayData[,probeColumn], 
                                                               threshold = threshold,
                                                              type = "pos")
    data@experimentData['negCount', probeColumn] <- .cellCount(x = data@assayData[,probeColumn], 
                                                               threshold = threshold,
                                                              type = "neg")
    data@posCellData[, probeColumn] <- data@assayData[, probeColumn] >= threshold
  
    data@experimentData['posRatio', ] <- (100/data@experimentData['totalCount', ]) * data@experimentData['posCount', ]
    data@experimentData['negRatio', ] <- (100/data@experimentData['totalCount', ]) * data@experimentData['negCount', ]
    data@experimentData['totalRatio', ] <- data@experimentData['posRatio', ] + data@experimentData['negRatio', ]
    data@experimentData <- round(data@experimentData, digits = 2)
  
    if(plot == TRUE){
      plotCells(data = data, probe = probe, posCol = col)
    }
    
  return(data)
}