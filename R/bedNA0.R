bedNA0<- function(bed1){
  for(j in 1:ncol(bed1)){
    temp <- bed1[,j]
    temp[is.na(temp)] <- 0
    bed1[,j] <- temp
    #print(j)
  }
  return(bed1)
}
