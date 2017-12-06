writeMPIFdata <- function(data = NULL, file = NULL, path = NULL){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  if(is.null(file) == TRUE){
    stop("No probe name was given to update.\n ")
  }
  if(is.null(path) == TRUE){
    cat("No data path was given. Using current work directory.\n")
    print(getwd())
    path <- test
  }
  ###

  write.xlsx(x = data@experimentData, file = outputfile)
 
}