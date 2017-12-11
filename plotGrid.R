.plotGrid <- function(xyData = NULL, breaks = 3, lineCol = "black"){
  if(is.null(xyData)){
    stop("xyData structure is not in the correct format.\n\n")
  }
  if(class(breaks) == "numeric"){
    if(breaks >= 2 | breaks <= 20){
      x.data <- as.numeric(xyData[,1])
      y.data <- as.numeric(xyData[,2])
      xlim <- as.numeric(c(min(x.data, na.rm = TRUE), 
                           max(x.data, na.rm = TRUE)))
      ylim <- as.numeric(c(min(y.data, na.rm = TRUE), 
                           max(y.data, na.rm = TRUE)))
      x.break <- (abs(diff(xlim))/breaks)
      y.break <- (abs(diff(ylim))/breaks)
      x.result <- xlim[1]
      y.result <- ylim[1]
      for(i in 1:breaks){
        x.result <- c(x.result, x.result[i]+x.break)
        y.result <- c(y.result, y.result[i]+y.break)
      }
      abline(v = x.result, col = lineCol)
      abline(h = y.result, col = lineCol)
    }
  }
}