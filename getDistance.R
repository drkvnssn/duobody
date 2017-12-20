.getDistance <- function(cell1, cell2){
  x <- abs(diff(c(as.numeric(cell1[1]), as.numeric(cell2[1]))))
  y <- abs(diff(c(as.numeric(cell1[2]), as.numeric(cell2[2]))))
  result <- sqrt(x**2 + y**2)
  return(result)
}
