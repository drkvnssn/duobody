.updateMPIFdata <- function(data = NULL){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  
  probes <- colnames(data@assayData)
  thresholds <- data@experimentData['threshold', ]
  
  for(p in 1:length(probes)){
    probeColumn <- grep(colnames(data@assayData), pattern = probes[p], ignore.case = TRUE, fixed = FALSE)
    
    data@experimentData['posMean', probeColumn] <- .cellAverage(x = data@assayData[,probeColumn], 
                                                                threshold = thresholds[p],
                                                                type = "pos", algorithm = "mean")
    data@experimentData['posMedian', probeColumn] <- .cellAverage(x = data@assayData[,probeColumn], 
                                                                  threshold = thresholds[p],
                                                                  type = "pos", algorithm = "median")
    data@experimentData['posMode', probeColumn] <- .cellAverage(x = data@assayData[,probeColumn], 
                                                                threshold = thresholds[p],
                                                                type = "pos", algorithm = "mode")
   
    data@experimentData['posCount', probeColumn] <- .cellCount(x = data@assayData[,probeColumn], 
                                                               threshold = thresholds[p],
                                                               type = "pos")
    data@experimentData['negCount', probeColumn] <- .cellCount(x = data@assayData[,probeColumn], 
                                                               threshold = thresholds[p],
                                                               type = "neg")
    data@posCellData[, probeColumn] <- data@assayData[, probeColumn] >= thresholds[p]
  }
  data@experimentData['totalCount', ] <- dim(data@assayData)[1]
  data@experimentData['posRatio', ] <- (100/data@experimentData['totalCount', ]) * data@experimentData['posCount', ]
  data@experimentData['negRatio', ] <- (100/data@experimentData['totalCount', ]) * data@experimentData['negCount', ]
  data@experimentData['totalRatio', ] <- data@experimentData['posRatio', ] + data@experimentData['negRatio', ]
  data@experimentData <- round(data@experimentData, digits = 2)
  
  return(data)
}