subsetProbe <- function(data = NULL, probe = NULL, output = "data", 
                        positive = TRUE, verbose = TRUE){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  if(is.null(probe) == TRUE){
      stop("Probe for subsetting was not given.\n")
  }
  
  cat("Location 1\n")
  probeColumn <- grep(colnames(data@assayData), pattern = probe, ignore.case = TRUE, fixed = FALSE)
  if(length(probe) != 1){
    stop("The probes can not be found or a not distinct enough to get single match.\n")
  }
  cat("Location 2\n")
  probe <- colnames(data@assayData)[probeColumn]
  cat("Location 3\n")
  assayData <- data@assayData[data@posCellData[,probeColumn] == positive, ]
  cat("Location 4\n")
  posCellData <- data@posCellData[data@posCellData[,probeColumn] == positive, ]
  xyData <- data@xyData[data@posCellData[,probeColumn] == positive, ]
  experimentData <- data@experimentData
  phenoData <- data@phenoData
  
  subsetRow <- grep(rownames(phenoData), pattern = "subset", ignore.case = TRUE, fixed = FALSE)
  if(positive == TRUE){
    suffix <- "+"
  } else if(positive == FALSE){
    suffix <- "-"
  }
  
  if(is.na(phenoData[subsetRow, 1]) == TRUE){
    phenoData[subsetRow, 1] <- paste0(probe,suffix)
  } else {
    phenoData[subsetRow, 1] <- paste0(phenoData[subsetRow, 1], ", ",paste0(probe,suffix))
    }
  cat("Location 5\n")
  subsetData <- new('MPIFdata', assayData = assayData, posCellData = posCellData, 
                xyData = xyData, experimentData = experimentData,
                phenoData = phenoData)
  cat("Location 6\n")
  subsetData <- .updateMPIFdata(subsetData)
  cat("Location 7\n")
  return(subsetData)
}