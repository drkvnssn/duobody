writeMPIFdata <- function(data = NULL, file = NULL, path = NULL, verbose = TRUE){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  if(is.null(path) == TRUE){
    if(verbose == TRUE){
      cat("No data path was given. Using path in phenoData.\n")
    }
    path <- data@phenoData['filepath',1]
  }
  if(is.null(file) == TRUE){
    if(verbose == TRUE){
      cat("No file name was given. Will generate a generic output file.\n")
    }
    file <- paste0("Experiment-results_",data@phenoData['samplename',1],".xlsx")
  }
  outputfile <- file.path(path, file)
  if(verbose == TRUE){
    cat("Writing Experiment Data to the following location:\n")
    print(path)
  }
  write.xlsx(x = data@experimentData, file = outputfile)
}