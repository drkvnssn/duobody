.cellAverage <- function(x = NULL, threshold = NULL, type = "pos", algorithm = "mean"){
  if(is.null(x) == TRUE | is.null(threshold == TRUE)){
    stop("Input for cellCount is not given.\n")
  }
  if(tolower(type) == "pos"){
    x <- x[x >= threshold]
  } else if(tolower(type) == "neg"){
    x <- x[x < threshold]
  } else {
    stop("Input type for cellCount is not correct.\n")
  }
  if(tolower(algorithm) == "mean"){
    result <- mean(x)
  } else  if(tolower(algorithm) == "median"){
    result <- median(x)
  } else if(tolower(algorithm) == "mode"){
    result <- .Mode(x)
  }
  return(result)
}
