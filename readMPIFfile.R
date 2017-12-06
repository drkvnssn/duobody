MPIFdata <- setClass("MPIFdata", slots = c(assayData = "matrix", 
                                             posCellData = "matrix", 
                                             xyData = "data.frame",
                                             experimentData = "matrix",
                                             phenoData = "matrix"))

readMPIFfile <- function(file =  NULL, thresholdfile = NULL, 
                               verbose = TRUE){
 
  ### CHECKING FOR FILES
  if(is.null(file) == TRUE){
    stop("No sample file has been given.\n\n")
  } else if(file.exists(file) == FALSE){
    stop("Sample file does not exists.\n\n")
  }
  if(is.null(thresholdfile) == TRUE){
    if(verbose == TRUE){
      cat("Threshold file not given. Looking for alternative.\n")
    }
    thresholdfile <- gsub(x = file, pattern = ".xlsx", replacement = ".txt")
    if(file.exists(thresholdfile) != FALSE){
      if(verbose == TRUE){
        cat("   Looking for second alternative.\n")
      }
      thresholdfile <- gsub(thresholdfile, pattern = basename(thresholdfile), replacement = "thresholds.txt")
      if(file.exists(thresholdfile) != FALSE){
        stop("Threshold file has not been given and no alternative has been found.\n")
    }
  } 
}
  ### READING XLS DATA
  if(verbose == TRUE){
    cat("Reading .xlsx data file.\n")
  }
    sample.data <- xlsxToR(file = file, header = TRUE)

  ### READING THRESHOLD DATA
    if(verbose == TRUE){
      cat("Reading threshold data file.\n")
    }
  threshold.data <- read.table(thresholdfile, header = TRUE, sep = "\t")

  ### TRANSFORM AND SPLIT DATA
  assayData <- sample.data[,10:16]
  assayData <- apply(X = assayData, MARGIN = 2, FUN = unlist)
  assayData <- apply(X = assayData, MARGIN = 2, FUN = as.numeric)
  probes <- gsub(x = colnames(assayData), pattern = "Mean ", replacement = "")
  colnames(assayData) <- probes
  posCellData <- matrix(data = NA, nrow = nrow(assayData), ncol = ncol(assayData))
  colnames(posCellData) <- probes
  xyData <- sample.data[,17:18]
  
  ### CREATE BASIC INFORMATION FOR ALL THE PROBES
  experimentCols <- c("min", "max", "threshold", 
                      "posMean", "posMedian", "posMode", "posCount", "negCount",
                      "totalCount", "posRatio", "negRatio", 'totalRatio')
  experimentData <- matrix(data = NA, nrow = length(experimentCols), ncol = ncol(assayData),
                           dimnames = list(experimentCols, probes))
 
  experimentData['min',] <- apply(X = assayData, FUN = min, MARGIN = 2)
  experimentData['max',] <- apply(X = assayData, FUN = max, MARGIN = 2)
  experimentData['totalCount', ] <- dim(assayData)[1]
  
  thresholdProbes <- tolower(threshold.data[,1])
  
  ### PLACE ALL THE DATA IN THE CORRECT LOCATION
  for(i in 1:length(thresholdProbes)){
    assayColumn <- grep(colnames(assayData), pattern = thresholdProbes[i], ignore.case = TRUE, fixed = FALSE)
    thresholdRow <- grep(threshold.data[,1],  pattern = thresholdProbes[i], ignore.case = TRUE, fixed = FALSE)
    experimentColumn <- grep(colnames(assayData), pattern = thresholdProbes[i], ignore.case = TRUE, fixed = FALSE)
    
    experimentData['posMean', experimentColumn] <- .cellAverage(x = assayData[,1], 
                                                            threshold = threshold.data[thresholdRow, 2],
                                                            type = "pos", algorithm = "mean")
    experimentData['posMedian', experimentColumn] <- .cellAverage(x = assayData[,1], 
                                                            threshold = threshold.data[thresholdRow, 2],
                                                            type = "pos", algorithm = "median")
    experimentData['posMode', experimentColumn] <- .cellAverage(x = assayData[,1], 
                                                            threshold = threshold.data[thresholdRow, 2],
                                                            type = "pos", algorithm = "mode")
    experimentData['threshold', experimentColumn] <- threshold.data[thresholdRow, 2]
    experimentData['posCount', experimentColumn] <- .cellCount(x = assayData[,assayColumn], 
                                               threshold = threshold.data[thresholdRow, 2],
                                               type = "pos")
    experimentData['negCount', experimentColumn] <- .cellCount(x = assayData[,assayColumn], 
                                               threshold = threshold.data[thresholdRow, 2],
                                               type = "neg")
    posCellData[, assayColumn] <- assayData[, assayColumn] >= threshold.data[thresholdRow, 2]
  }
  experimentData['posRatio', ] <- (100/experimentData['totalCount', ]) * experimentData['posCount', ]
  experimentData['negRatio', ] <- (100/experimentData['totalCount', ]) * experimentData['negCount', ]
  experimentData['totalRatio', ] <- experimentData['posRatio', ] + experimentData['negRatio', ]
  experimentData <- round(experimentData, digits = 2)
  
  ### PHENODATA
  phenoRows <- c("samplename", "filepath", "samplefile", "thresholdfile")
  phenoData <- matrix(data = NA, nrow = length(phenoRows), ncol = 1,
                           dimnames = list(phenoRows, c("")))
  phenoData['samplename', 1] <- .mgsub(basename(file), 
                                    pattern = c("ALP",".xlsx"), 
                                    replacement = c("",""))
  phenoData['filepath', 1] <- gsub(file, pattern = basename(file), replacement = "")
  phenoData['samplefile', 1] <- basename(file)
  phenoData['thresholdfile', 1] <- basename(thresholdfile)
                                    
  ### COMBINE ALL DATA INTO ONE STRUCTURE ----
  object <- new('MPIFdata', assayData = assayData, posCellData = posCellData, 
                xyData = xyData, experimentData = experimentData,
                phenoData = phenoData)
  
  return(object)
}