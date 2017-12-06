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
  
  probeColumn <- grep(colnames(data@assayData), pattern = probe, ignore.case = TRUE, fixed = FALSE)
  data@experimentData['threshold', probeColumn] <- threshold
  
  data <- .updateMPIFdata(data = data)
  
  if(plot == TRUE){
    plotCells(data = data, probe = probe, posCol = col)
  }
  
  return(data)
}