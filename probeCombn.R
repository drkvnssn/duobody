.probeCombn2 <- function(p1, p2){
    p1pp2p <- paste0(p1,"+, ", p2,"+")
    p1pp2n <- paste0(p1,"+, ", p2,"-")
    p1np2p <- paste0(p1,"-, ", p2,"+")
    p1np2p <- paste0(p1,"-, ", p2,"-")
    result <- c(p1pp2p, p1pp2n, p1np2p, p1np2p)
    
    return(result)
}
.probeCombn4 <- function(p1, p2){
  p1p2p <- paste0(p1,", ", p2,"+")
  p1p2n <- paste0(p1,", ", p2,"-")
  result <- c(p1p2p, p1p2n)
  return(result)
}