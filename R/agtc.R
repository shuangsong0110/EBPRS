agtc <- function(a1,a2,b1,b2){
  sig <- rep(1,length(a1))
  for(i in 1:length(a1)){
    if((is.na(a1[i]))||(is.na(a2[i]))||(is.na(b1[i]))||(is.na(b2[i]))){
      sig[i] <- 0
    }
    else if((a1[i]==b1[i])&(a2[i]==b2[i])){
      sig[i] <- 1
    }else if((a1[i]==b2[i])&(a2[i]==b1[i])){
      sig[i] <- -1
    }
    else{
      if(b1[i]=="A"){temp1 <- "T"}
      if(b1[i]=="T"){temp1 <- "A"}
      if(b1[i]=="G"){temp1 <- "C"}
      if(b1[i]=="C"){temp1 <- "G"}
      if(b2[i]=="A"){temp2 <- "T"}
      if(b2[i]=="T"){temp2 <- "A"}
      if(b2[i]=="G"){temp2 <- "C"}
      if(b2[i]=="C"){temp2 <- "G"}
      if((a1[i]==temp1)&(a2[i]==temp2)){
        sig[i] <- 1
      }else if((a1[i]==temp2)&(a2[i]==temp1)){
        sig[i] <- -1
        }else{ sig[i] <- 0}
    }
    # if(i %% 10000==0){
    #   print(i)
    # }
  }
  return(sig)
}



