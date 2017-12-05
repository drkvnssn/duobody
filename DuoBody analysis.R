source("https://gist.github.com/schaunwheeler/5825002/raw/3526a15b032c06392740e20b6c9a179add2cee49/xlsxToR.r")
install.packages("pbapply")
### https://gist.github.com/schaunwheeler/5825002/
#
# can not be used under view do to no install of "pbapply"


# loading different option to reading xls files
checkPackages("xlsx")

### FUNCTIONS
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

### script to read the data from Difiniens

### OSX
data.path <- "/Users/dirkvanessen/Desktop/data daniella/data/"

### vies
data.path <- "\\\\vumc.nl/home$/store4ever/h.vanessen/h.vanessen/Desktop/Intensity files Daniella"
files <- list.files(data.path, pattern = ".xlsx", full.names = TRUE)

sampleFilename <- .mgsub(basename(files[2]), 
                     pattern = c(".xlsx"),
                     replacement = c(""))
thresholdFilename <- paste0(samplename, ".txt")
thresholdFile <- file.path(data.path, thresholdFilename)

### READING THE DATA
thresholdData <- read.table(thresholdFile, header = TRUE, sep = "\t")
sampleData <- xlsxToR(file = files[2], header = TRUE)
x <- sampleData
### ANALYSIS 

t <- 1
probe <- thresholdData[t,1]
column <- grep(colnames(x), pattern = probe, ignore.case = TRUE, fixed = FALSE)
probeData <- x[,column]
result <- sum(probeData > thresholdData[t,2])

intensity <- sampleData[,c(10:14,16)]
result <- intensity

for(i in 1:dim(intensity)[2]){
  result[,i] <- intensity[,i] > thresholdData[i,2]
}

all.probe.results <- rep(NA, dim(result)[1])

for(z in 1:dim(result)[1]){
  all.probe.results[z]  <- sum(result[z,] == TRUE)
}

colors <- .mgsub(all.probe.results, 
                 pattern = c(0,1,2,3,4,5,6),
                 replacement = c("lightgrey","yellow", "orange", "red", 
                                 "green", "blue", "black"))

fileName <- paste(samplename,".png", sep ="")
outputFile <- file.path(data.path, fileName)
png(filename = outputFile, width = 800, height = 800)
plot(sampleData$inner_x, sampleData$inner_y,
     col = colors,
     main = "Cells by positive probes",
     xlab = "inner_x",
     ylab = "inner_y",
     cex = 0.8, pch = 20)
dev.off()
### CREATING PLOTS
outputFile <- paste(samplename,"_", probe,".png", sep ="")

for(i in 1:length(probes)){
  fileName <- paste("TAM16-36762_", probes[i],".png", sep ="")
  outputFile <- file.path(output.path, fileName)
  png(filename = outputFile, width = 600, height = 600)
  plotCells(data, probes[i], threshold[i])
  dev.off()
  }

