# Multiplex Immuno Panel FISH analysis
## HF van Essen
## 2017-12

##############

sample '.xlsx' files can be read with 'readMPIFfile' function and data will be stored in 
a dedicated S4 structure with the following structure.

assayData -> holds the intensity for each probe / cell

posCellData -> TRUE / FALSE value for each probe / cell based on the thresholds

xyData -> holds the xy position for each cell in mm

experimentData -> basic statistics for each probe/cell

phenoData -> basic information about the sample & file

A threshold holding the thresholds for each probe can be given or a text file with the 
same name as the sample '.xlsx' file may be placed next to the sample file. Data will be 
read with the sample data and basic values will be calculated according to the thresholds.

Thresholds can be updated manually (one probe at a time) with the function 'updateThresholds'.
A plot can be generated immediately with 'plot = TRUE' to see the difference.

A simple overview of the data structure can be requested with 'overview()'

data can be plotted with 'plotCells()'

Use 'writeMIPFdata()' to write experiment data to disk.

**EXAMPLES**

### Reading functions

Setting the functions path and souring the functions

```
functions.path <- "/Users/dirkvanessen/Documents/coding/R/duobody"
source(file.path(functions.path,"sourceDir.R"))
sourceDir(functions.path)
```

### Selecting files

setting the data path and getting files:
```
data.path <- "/Users/data"
files <- list.files(path = data.path, pattern = ".xlsx", full.names = TRUE)
```

### Reading the data

An example of reading one file, getting the overview of all the data and plotting the cells
```
data <- readMPIFfile(file = files[2], verbose = FALSE)
overview(data)

head of 'assayData'.
          PD1    CD163       Pax5       CD8     PDL1     DAPI      CD3
[1,] 32.68627 53.13725  4.0196078 16.274510 34.35294 44.21569 59.82353
[2,] 58.05556 18.88889  0.9444444  3.277778 11.83333 44.50000 59.66667
[3,] 36.90000 33.00000  1.9000000 26.150000 22.80000 38.55000 72.65000
[4,] 25.84000 19.72000 16.4000000  3.040000 20.04000 17.52000 15.44000
[5,] 69.44444 98.66667 10.3333333  7.000000 39.44444 55.77778 85.66667
[6,] 38.27027 74.54054  6.9189189 10.189189 44.21622 52.10811 56.18919

head of 'posCellData'.
       PD1 CD163  Pax5   CD8  PDL1 DAPI   CD3
[1,]  TRUE  TRUE FALSE  TRUE FALSE   NA  TRUE
[2,]  TRUE FALSE FALSE FALSE FALSE   NA  TRUE
[3,]  TRUE FALSE FALSE  TRUE FALSE   NA  TRUE
[4,] FALSE FALSE  TRUE FALSE FALSE   NA FALSE
[5,]  TRUE  TRUE FALSE FALSE FALSE   NA  TRUE
[6,]  TRUE  TRUE FALSE FALSE  TRUE   NA  TRUE

head of 'xyData'.
  Position on Slide x (mm) Position on Slide y (mm)
2            0.21756516532    4.4535113928000003E-3
3      0.35899013085999998    7.1924208994000004E-3
4      0.22497135475999999    9.1419455116000005E-3
5      0.34575860005999998    9.9482537492999994E-3
6      0.44990485468000002          1.3753927685E-2
7            0.44399131374          1.6758443006E-2

'experimentData'
               PD1   CD163    Pax5     CD8    PDL1   DAPI     CD3
min           1.04    2.28    0.11    0.15    0.83    0.7    1.72
max         121.76  179.05   46.42   98.17  117.44  137.0  130.55
threshold    27.60   53.10   14.00   14.50   42.50     NA   42.50
posMean      47.77   66.60   39.30   39.56   58.10     NA   58.10
posMedian    44.85   63.34   36.40   36.65   54.71     NA   54.71
posMode      45.50   60.00   20.00   20.00   45.50     NA   45.50
posCount   5511.00 3033.00 1531.00 4394.00 3683.00     NA 5297.00
negCount   3534.00 6012.00 7514.00 4651.00 5362.00     NA 3748.00
totalCount 9045.00 9045.00 9045.00 9045.00 9045.00 9045.0 9045.00
posRatio     60.93   33.53   16.93   48.58   40.72     NA   58.56
negRatio     39.07   66.47   83.07   51.42   59.28     NA   41.44
totalRatio  100.00  100.00  100.00  100.00  100.00     NA  100.00

'phenoData'
                                                                                  
samplename    "TVU-10737II"                                                       
subset        NA                                                                  
filepath      "/Users/dirkvanessen/Documents/coding/R/duobody data daniella/data/"
samplefile    "ALPTVU-10737II.xlsx"                                               
thresholdfile "ALPTVU-10737II.txt" 



plotCells(data = data)
```

### plotting

Plotting of the cells and a selection of probes within the set. 
One probename can be added to look at a positive subset of cells.
Color of  positive subset be manually added with posCol (hex or by stating a color)

```
plotCells(data = data, probe = "cd3")
plotCells(data = data, probe = "pax")
```

### Analysis 

Analysis of the data with subsets of 2 or 3 probes
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
