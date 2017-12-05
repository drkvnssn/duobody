### LOADING FUNCTIONS
checkPackages <- function(x){
  for (i in 1:length(x)){
    package <- as.character(x[i])
    if( package %in% installed.packages()[,1] == FALSE ){
      install.packages(package, lib = "N:/Documenten/R/win-library/3.2")
    } else { library(package, character.only = TRUE ) }
  }
}
.mgsub <- function(pattern, replacement, x, ...) {
  if (length(pattern)!=length(replacement)) {
    stop("pattern and replacement do not have the same length.")
  }
  result <- x
  for (i in 1:length(pattern)) {
    result <- gsub(pattern[i], replacement[i], result, ...)
  }
  result
}
positiveCells <- function(x, probe = NULL, threshold = NULL){
  column <- grep(colnames(x), pattern = probe, ignore.case = TRUE, fixed = FALSE)
  probeData <- x[,column]
  result <- sum(probeData > threshold)
  return(result)
}
plotCells <- function(x, probe = NULL, threshold = 35.1,
                      pch = 20, 
                      cex = 0.8, probeCol = "#ff0000",
                      density = 60){
  
  if(is.null(probe) != TRUE){
    column <- grep(colnames(x), pattern = probe, ignore.case = TRUE, fixed = FALSE)
    probeData <- x[,column]
    selection <- probeData > threshold
  }
  main.text <- toupper(probe)
  pos.cells <- positiveCells(x = x, probe = probe, threshold = threshold)
  total.cells <- dim(x)[1]
  percent.pos.cells <- round((100/total.cells)*pos.cells, digits = 2)
  sub.text <- paste("Total positive cells:", sub.text )
  plot(x$inner_x, x$inner_y, pch = 20, col = "#00000020",
       main = main.text,
       xlab = "inner_x",
       ylab = "inner_y")
  mtext(sub.text, side = 3, cex = 1)
  posColor <- paste0(probeCol, as.character(density))
  posColor <- rep(posColor, length(probeData))
  points(x$inner_x[selection], x$inner_y[selection], 
         pch = pch, cex = cex,
         col = posColor[selection])
}

### LOADING PACKAGES
checkPackages("xlsx")

# [ ] read total positive cells
# [ ] read total negative cells
# [ ] read total positive cells / probe

### function for analysis two probes combined
# [ ] data, markers = c(), thresholds = c()
# [ ] total pos marker 1
# [ ] total pos marker 1 & pos marker 2
# [ ] total pos marker 1 & neg marker 2

### function for analysis three probes combined
# [ ] data, markers = c(), thresholds = c()
# [ ] total pos marker 1
# [ ] total pos marker 1 & pos marker 2
# [ ] total pos marker 1 & neg marker 2
# [ ] total pos marker 1 & pos marker 2 & pos marker 3
# [ ] total pos marker 1 & pos marker 2 & neg marker 3
# [ ] total pos marker 1 & neg marker 2 & pos marker 3
# [ ] total pos marker 1 & neg marker 2 & neg marker 3

### various
# [ ] mean pos for probe
# [ ] mean neg for probe
# [ ] total multi positive cells (> 4 probes)

### files
# [ ] file format is always the same
