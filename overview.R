overview <- function(data = NULL, manip = "head"){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  if(manip == "head"){
    message("head of 'assayData'.")
    print(head(data@assayData))
    message("\nhead of 'posCellData'.")
    print(head(data@posCellData))
    message("\nhead of 'xyData'.")
    print(head(data@xyData))
    message("\n'experimentData'")
    print(data@experimentData)
    message("\n'phenoData'")
    print(data@phenoData)
  }
  if(manip == "tail"){
    message("tail of 'assayData'.")
    print(tail(data@assayData))
    message("\tail of 'posCellData'.")
    print(tail(data@posCellData))
    message("\tail of 'xyData'.")
    print(tail(data@xyData))
    message("\n'experimentData'")
    print(data@experimentData)
    message("\n'phenoData'")
    print(data@phenoData)
  }
}
  