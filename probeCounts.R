probeCounts <- function(m1 = NULL, m2 = NULL, 
         th1 = NULL, th2 = NULL, m1pos = TRUE){
  if(is.character(m1) != TRUE | is.character(m2) != TRUE){
    cat("Markers must be a character.\n")
  }
  if(is.numeric(th1) != TRUE | is.numeric(th2) != TRUE){
    cat("Thresholds must be a numeric.\n")
  }
  
}