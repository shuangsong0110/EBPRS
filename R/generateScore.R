generateScore <- function(eff, bed){
  X <- bedNA0(bed)
  n0=nrow(X)
  if(is.null(n0)){
    S <- sum(X*eff)
    return(S)
  }
  else{
    cat(n0," individuals in total.","\n")
    S=rep(0,n0)
    for(l in 1:n0){
      S[l]=sum(X[l,]*eff)
      if(l%%500==0){
        #ll <- paste()
        cat(l,"individuals finished. \n")
      }

    }
    return(S)

  }

}
