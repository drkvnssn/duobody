cellIntensity <- function(data = NULL){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  colors <- rep(c("lightblue", "lightgreen"), 10)
  
  par(mfrow=c(1,dim(data@assayData)[2]))
  
  y.limits <- c(min(data@assayData, na.rm = TRUE), max(data@assayData, na.rm = TRUE))
  for(i in 1:length(colnames(data@assayData))){
    if(tolower(colnames(data@assayData)[i]) == "dapi"){
      sample.data <- data@assayData[,i]
    } else {
      sample.data <- data@assayData[data@posCellData[,i],i]
    }
    probe.name <- colnames(data@assayData)[i]
    boxplot(x = sample.data, na.rm = TRUE, col = colors[i], 
            cex = 0.5, pch = 20, ylim = y.limits)
    mtext(text = probe.name, side = 3, cex = 0.6)
  }
}