.cellCount <- function(x = NULL, threshold = NULL, type = "pos"){
  if(is.null(x) == TRUE | is.null(threshold == TRUE)){
    stop("Input for cellCount is not given.\n")
  }
  if(tolower(type) == "pos"){
    result <- sum(x >= threshold)
  } else if(tolower(type) == "neg"){
    result <- sum(x < threshold)
  } else {
    stop("Input type for cellCount is not correct.\n")
  }
  return(result)
}
