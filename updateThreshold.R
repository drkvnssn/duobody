updateThreshold <- function(data = NULL, probe = NULL, threshold = NULL, 
                            plot = TRUE, col = "red", write = FALSE,
                            verbose = TRUE){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  if(is.null(probe) == TRUE){
    stop("No probe name was given to update.\n ")
  }
  if(is.null(threshold) == TRUE){
    stop("No threshold data was given for update.\n ")
  }
  if(write == TRUE){
    probes <- colnames(data@experimentData)
    thresholds <- data@experimentData['threshold',]
    thresholdData <- matrix(data = cbind(probes, thresholds), 
                            ncol = 2, byrow = FALSE, 
                            dimnames = list(c(), c("probe", "threshold")))
    dateTime <- format(Sys.time(), "%Y%m%d-%H%M%S")
    filename <- paste0(dateTime,"_",data@phenoData['samplename',], "_thresholds.txt")
    outputFile <- file.path(data@phenoData['filepath',], filename)
    write.table(x = thresholdData, file = outputFile, sep = "\t", quote = FALSE, row.names = FALSE)
  }
  
  probeColumn <- grep(colnames(data@assayData), pattern = probe, ignore.case = TRUE, fixed = FALSE)
  data@experimentData['threshold', probeColumn] <- threshold
  
  data <- .updateMPIFdata(data = data)
  
  if(write == TRUE){
    probes <- colnames(data@experimentData)
    thresholds <- data@experimentData['threshold',]
    thresholdData <- matrix(data = cbind(probes, thresholds), 
                            ncol = 2, byrow = FALSE, 
                            dimnames = list(c(), c("probe", "threshold")))
    outputFile <- file.path(data@phenoData['filepath',], data@phenoData['thresholdfile',])
    write.table(x = thresholdData, file = outputFile, sep = "\t", quote = FALSE, row.names = FALSE)
  }
  
  if(plot == TRUE){
    plotCells(data = data, probe = probe, posCol = col)
  }
  
  return(data)
}