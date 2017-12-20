.getDistance <- function(x1, y1, x2, y2){
  x <- abs(diff(c(x1, x2)))
  y <- abs(diff(c(y1, y2)))
  result <- sqrt(x**2 + y**2)
  return(result)
}
