agtc <- function(a,b){
  sig <- rep(1,length(a))
  diff <- which(a!=b)
  if(length(diff)>0){
    for(i in 1:length(diff)){
      j=diff[i]
      if(a[j]=="A"){
        if(b[j]!="T"){
          sig[j] <- -1
        }
      }
      if(a[j]=="T"){
        if(b[j]!="A"){
          sig[j] <- -1
        }

      }
      if(a[j]=="G"){
        if(b[j]!="C"){
          sig[j] <- -1
        }

      }
      if(a[j]=="C"){
        if(b[j]!="G"){
          sig[j] <- -1
        }

      }
    }
  }
  return(sig)
}
