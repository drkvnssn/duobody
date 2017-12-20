plotCellSubsetIntensity <- function(data = NULL, subset = NULL, probe, 
                                     size = 25){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  colors <- rep(c("lightblue", "lightgreen"), 10)
  ### MATRIX FOR BOXPLOTDATA
  boxplotData <- matrix(data = NA, ncol = length(subset), nrow = 5)
  colnames(boxplotData) <- subset
  xCoord <- matrix(data = NA, ncol = length(subset), nrow = size)
  colnames(xCoord) <- subset
  yCoord <- matrix(data = NA, ncol = length(subset), nrow = size)
  colnames(yCoord) <- subset
  sample.data <- list(boxplot = boxplotData, x = xCoord, y = yCoord)
  ### LOOP FOR THE SUBSETS
  for(i in 1:length(subset)){
    subsetData <- subsetProbe(data = data, probe = subset[i])
    
    subProbeColumn <- grep(colnames(data@assayData), pattern = probe, ignore.case = TRUE, fixed = FALSE)
    sample.data$boxplot[,i] <- boxplot(subsetData@assayData[subsetData@posCellData[,subProbeColumn],subProbeColumn], 
                                       plot = FALSE)$stats
    colnames(boxplotData)[i] <- subset[i]
    sample.data$x[,i] <- rep(x = i, dim(sample.data$x)[1])
    sample.data$y[,i] <- sample(x = subsetData@assayData[subsetData@posCellData[,subProbeColumn],subProbeColumn], size = size)
  }
  
  main.text <- paste(data@phenoData['samplename', 1], ":", "Boxplots for", probe,"positive cells.")
  boxplot(sample.data$boxplot, col = colors, main = main.text) 
  if(is.numeric(size) == TRUE){
    points(x = jitter(sample.data$x), y = sample.data$y, cex = 0.3, col = "red", pch = 20)
  }
}
  