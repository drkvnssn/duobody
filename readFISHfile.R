FISHdata <- setClass("FISHdata", slots = c(assayData = "matrix", 
                                             useData = "matrix", 
                                             xyData = "data.frame",
                                             experimentData = "matrix",
                                             phenoData = "matrix"))

readFISHfile <- function(samplefile =  NULL, thresholdfile = NULL, 
                               verbose = TRUE){
 
  ### CHECKING FOR FILES
  if(is.null(samplefile) == TRUE){
    stop("No sample file has been given.\n\n")
  } else if(file.exists(samplefile) == FALSE){
    stop("Sample file does not exists.\n\n")
  }
  
  if(is.null(thresholdfile) == TRUE){
    if(verbose == TRUE){
      cat("Threshold file not given. Looking for alternative.\n")
    }
    thresholdfile <- gsub(samplefile, pattern = ".xlsx", replacement = ".txt")
    if(file.exists(thresholdfile) != TRUE){
      if(verbose == TRUE){
        cat("   Looking for second alternative.\n")
      }
      thresholdfile <- gsub(thresholdfile, pattern = basename(thresholdfile), replacement = "thresholds.txt")
    }
  } else {
    stop("Threshold file has not been given and no alternative has been found.\n")
  }

  ### READING XLS DATA
  computer.name <- Sys.info()["sysname"]
    if(computer.name == "Darwin"){
      source("https://gist.github.com/schaunwheeler/5825002/raw/3526a15b032c06392740e20b6c9a179add2cee49/xlsxToR.r")
      checkPackages("pbapply")
      sample.data <- xlsxToR(file = samplefile, header = TRUE)
    } else if(computer.name == "Windows"){
      sample.data <- read.xls(file = samplefile, header = TRUE) 
    }

  ### READING THRESHOLD DATA
  threshold.data <- read.table(thresholdfile, header = TRUE, sep = "\t")

  ### TRANSFORM AND SPLIT DATA
  assayData <- sample.data[,10:16]
  assayData <- apply(X = assayData, MARGIN = 2, FUN = unlist)
  assayData <- apply(X = assayData, MARGIN = 2, FUN = as.numeric)
  probes <- gsub(x = colnames(assayData), pattern = "Mean ", replacement = "")
  colnames(assayData) <- probes
  useData <- matrix(data = NA, nrow = nrow(assayData), ncol = ncol(assayData))
  colnames(useData) <- probes
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
  for(i in 1:length(thresholdProbes)){
    assayColumn <- grep(colnames(assayData), pattern = thresholdProbes[i], ignore.case = TRUE, fixed = FALSE)
    thresholdRow <- grep(threshold.data[,1],  pattern = thresholdProbes[i], ignore.case = TRUE, fixed = FALSE)
    experimentColumn <- grep(colnames(assayData), pattern = thresholdProbes[i], ignore.case = TRUE, fixed = FALSE)
    
    experimentData['posMean', experimentColumn] <- cellMean(x = assayData[,1], 
                                                            threshold = threshold.data[thresholdRow, 2],
                                                            type = "pos", algorithm = "mean")
    experimentData['posMedian', experimentColumn] <- cellMean(x = assayData[,1], 
                                                            threshold = threshold.data[thresholdRow, 2],
                                                            type = "pos", algorithm = "median")
    experimentData['posMode', experimentColumn] <- cellMean(x = assayData[,1], 
                                                            threshold = threshold.data[thresholdRow, 2],
                                                            type = "pos", algorithm = "mode")
    experimentData['threshold', experimentColumn] <- threshold.data[thresholdRow, 2]
    experimentData['posCount', experimentColumn] <- cellCount(x = assayData[,assayColumn], 
                                               threshold = threshold.data[thresholdRow, 2],
                                               type = "pos")
    experimentData['negCount', experimentColumn] <- cellCount(x = assayData[,assayColumn], 
                                               threshold = threshold.data[thresholdRow, 2],
                                               type = "neg")
  }
  experimentData['posRatio', ] <- (100/experimentData['totalCount', ]) * experimentData['posCount', ]
  experimentData['negRatio', ] <- (100/experimentData['totalCount', ]) * experimentData['negCount', ]
  experimentData['totalRatio', ] <- experimentData['posRatio', ] + experimentData['negRatio', ]

  ### PHENODATA
  phenoRows <- c("samplename", "filepath", "samplefile", "thresholdfile")
  phenoData <- matrix(data = NA, nrow = length(phenoRows), ncol = 1,
                           dimnames = list(phenoRows, c("")))
  
  phenoData['samplename', 1] <- .mgsub(basename(samplefile), 
                                    pattern = c("ALP",".xlsx"), 
                                    replacement = c("",""))
  phenoData['filepath', 1] <- gsub(samplefile, pattern = basename(samplefile), replacement = "")
  phenoData['samplefile', 1] <- basename(samplefile)
  phenoData['thresholdfile', 1] <- basename(thresholdfile)
                                    
  ### COMBINE ALL DATA INTO ONE STRUCTURE ----
  object <- new('FISHdata', assayData = assayData, useData = useData, 
                xyData = xyData, experimentData = experimentData,
                phenoData = phenoData)
  
  return(object)
}