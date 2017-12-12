cellIntensity <- function(data = NULL, points = NULL, size = 75, col = "red"){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  colors <- rep(c("lightblue", "lightgreen"), 10)
  
  ### PARSE ALL THE DATA
  boxplotData <- matrix(data = NA, ncol = dim(data@assayData)[2], nrow = 5)
  colnames(boxplotData) <- colnames(data@assayData)
  xCoord <- matrix(data = NA, ncol = dim(data@assayData)[2], nrow = size)
  colnames(xCoord) <- colnames(data@assayData)
  yCoord <- matrix(data = NA, ncol = dim(data@assayData)[2], nrow = size)
  colnames(yCoord) <- colnames(data@assayData)
  
  sample.data <- list(boxplot = boxplotData, x = xCoord, y = yCoord)
  
  for(i in 1:length(colnames(data@assayData))){
    if(tolower(colnames(data@assayData)[i]) == "dapi"){
      sample.data$boxplot[,i] <- boxplot(data@assayData[,i], plot = FALSE)$stats
      sample.data$x[,i] <- rep(x = i, dim(sample.data$x)[1])
      sample.data$y[,i] <- sample(x = data@assayData[,i], size = size)
    } else {
      sample.data$boxplot[,i] <- boxplot(data@assayData[data@posCellData[,i],i], plot = FALSE)$stats
      sample.data$x[,i] <- rep(x = i, dim(sample.data$x)[1])
      sample.data$y[,i] <- sample(x = data@assayData[data@posCellData[,i],i], size = size)
    }
  } 
  

  main.text <- "Boxplot of positive cells for each probe"
  boxplot(sample.data$boxplot, col = colors, main = main.text)
  if(is.numeric(size) == TRUE){
    points(x = jitter(sample.data$x), y = sample.data$y, cex = 0.3, col = "red", pch = 20)
  }
}
