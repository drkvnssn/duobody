# Multiplex Immuno Panel FISH analysis
## HF van Essen
## 2017-12

##############

sample '.xlsx' files can be read with 'readMPIFfile' function and data will be stored in 
a dedicated S4 structure. 

A threshold holding the thresholds for each probe can be given or a text file with the 
same name as the sample '.xlsx' file may be placed next to the sample file. Data will be 
read with the sample data and basic values will be calculated according to the thresholds.

Thresholds can be updated manually (one probe at a time) with the function 'updateThresholds'.
A plot can be generated immediately with 'plot = TRUE' to see the difference.

A simple overview of the data structure can be requested with 'overview()'

data can be plotted with 'plotCells()'

Use 'writeMIPFdata()' to write experiment data to disk.

**EXAMPLES**

### SETTING THE FUNCTIONS PATH AND SOURCING THE FUNCTIONS
```
functions.path <- "/Users/dirkvanessen/Documents/coding/R/duobody"
source(file.path(functions.path,"sourceDir.R"))
sourceDir(functions.path)
```

### setting the data path and getting files:
```
data.path <- "/Users/data"
files <- list.files(path = data.path, pattern = ".xlsx", full.names = TRUE)
```

### An example of reading one file, getting the overview of all the data and plotting the cells
```
data <- readMPIFfile(file = files[2], verbose = FALSE)
overview(data)
plotCells(data = data)
```

### plotting the cells and a selection of probes within the set
```
plotCells(data = data, probe = "cd3")
plotCells(data = data, probe = "pax")
```

### Analysis of the data with subsets of 2 or 3 probes
```
tcells <- c("cd3","cd8","pd1")
analyzeProbes(data, tcells)
```
Results will be written to R console.
If results need to be stored, add 'write = TRUE' and an excel file will be stored to disk

```
macro <- c("cd163","pdl")
analyzeProbes(data, macro, write = TRUE)
```
