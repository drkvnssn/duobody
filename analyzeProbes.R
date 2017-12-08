analyzeProbes <- function(data = NULL, probes = NULL, 
                          write = TRUE, 
                          verbose = FALSE){
  if((class(data)[1] == "MPIFdata") != TRUE){
    stop ("data structure is not in the correct format.\n\n")
  } 
  if(is.null(probes) == TRUE){
    stop("No probes have been given.\n")
  }
  if(length(probes) == 1){
    stop("There are 2 or 3 probes needed for analysis.\n")
  }
  if(verbose == TRUE){
    cat("Creating subsets.\n")
  }
  if((length(probes) > length(unique(tolower(probes)))) == TRUE){
    stop("Probes are not unique enough.\n")
  }

  ### create subsets
  if(length(probes) == 2){
    if(verbose == TRUE){
      cat("Analyzing two probe combinations.\n")
    }
    probe1Column <- grep(colnames(data@assayData), pattern = probes[1], ignore.case = TRUE, fixed = FALSE)
    probe1 <- colnames(data@assayData)[probe1Column]
    probe2Column <- grep(colnames(data@assayData), pattern = probes[2], ignore.case = TRUE, fixed = FALSE)
    probe2 <- colnames(data@assayData)[probe2Column]
    probes <- c(probe1, probe2)
    
    probe1pos <- subsetProbe(data = data, probe = probes[1], positive = TRUE)
    probe2pos <- subsetProbe(data = probe1pos, probe = probes[2], positive = TRUE)
    probe2neg <- subsetProbe(data = probe1pos, probe = probes[2], positive = FALSE)
    #probe1pos.combn <- .probeCombn(p1 = probe1pos@phenoData['subset',1], p2 = probe2)
    
    ### GET RESULTS
    probe.combinations <- c(paste0(probe1,"+"), 
                            probe2pos@phenoData['subset',1], 
                            probe2neg@phenoData['subset',1])
    
    results <- matrix(data = NA, nrow = length(probe.combinations), ncol = 2, 
                      dimnames = list(c(1:length(probe.combinations)), 
                                      c("Probes","Counts")))
    results[,1] <- probe.combinations
    results[1,2] <- data@experimentData['posCount', probe1Column]
    results[2,2] <- probe1pos@experimentData['posCount', probe2Column]
    results[3,2] <- probe1pos@experimentData['negCount', probe2Column]

  }
  if(length(probes) == 3){
    if(verbose == TRUE){
      cat("Analyzing three probe combinations.\n")
    }
  probe1Column <- grep(colnames(data@assayData), pattern = probes[1], ignore.case = TRUE, fixed = FALSE)
  probe1 <- colnames(data@assayData)[probe1Column]
  probe2Column <- grep(colnames(data@assayData), pattern = probes[2], ignore.case = TRUE, fixed = FALSE)
  probe2 <- colnames(data@assayData)[probe2Column]
  probe3Column <- grep(colnames(data@assayData), pattern = probes[3], ignore.case = TRUE, fixed = FALSE)
  probe3 <- colnames(data@assayData)[probe3Column]
  probes <- c(probe1, probe2, probe3)
  
  probe1pos <- subsetProbe(data = data, probe = probes[1], positive = TRUE)
  probe2pos <- subsetProbe(data = probe1pos, probe = probes[2], positive = TRUE)
  probe2neg <- subsetProbe(data = probe1pos, probe = probes[2], positive = FALSE)
  probe2pos3pos <- subsetProbe(data = probe2pos, probe = probes[3], positive = TRUE)
  probe2pos3neg <- subsetProbe(data = probe2pos, probe = probes[3], positive = FALSE)
  probe2neg3pos <- subsetProbe(data = probe2neg, probe = probes[3], positive = TRUE)
  probe2neg3neg <- subsetProbe(data = probe2neg, probe = probes[3], positive = FALSE)
  
  probe.combinations <- c(paste0(probe1,"+"), 
                          probe2pos@phenoData['subset',1], 
                          probe2neg@phenoData['subset',1],
                          probe2pos3pos@phenoData['subset',1], 
                          probe2pos3neg@phenoData['subset',1],
                          probe2neg3pos@phenoData['subset',1], 
                          probe2neg3neg@phenoData['subset',1]
                          )
  ### GET RESULTS
  results <- matrix(data = NA, nrow = length(probe.combinations), ncol = 2, 
                    dimnames = list(c(1:length(probe.combinations)), 
                                    c("Probes","Counts")))
  results[,1] <- probe.combinations
  results[1,2] <- data@experimentData['posCount', probe1Column]
  results[2,2] <- probe1pos@experimentData['posCount', probe2Column]
  results[3,2] <- probe1pos@experimentData['negCount', probe2Column]
  results[4,2] <- probe2pos@experimentData['posCount', probe3Column]
  results[5,2] <- probe2pos@experimentData['negCount', probe3Column]
  results[6,2] <- probe2neg@experimentData['posCount', probe3Column]
  results[7,2] <- probe2neg@experimentData['negCount', probe3Column]
  }
  results <- data.frame(results)
  if(is.null(write) != TRUE){
    file <- paste0(data@phenoData['samplename',],"_",
                   paste0(probes, collapse = "_"),
                   ".xlsx")
    outputfile <- paste0(data@phenoData['filepath',1],
                            file)
    .checkPackages(x = "xlsx")
    write.xlsx(file = outputfile, x = results, row.names = FALSE)
    if(verbose == TRUE){
      cat("\nData has been save to disk at the following location.\n")
      print(data@phenoData['filepath',1])
      cat("\n")
    }
  }
  return(results)
}
