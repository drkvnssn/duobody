GetColorHex <- function(color){
    c <- col2rgb(color)
    sprintf("#%02X%02X%02x", c[1],c[2],c[3])
}