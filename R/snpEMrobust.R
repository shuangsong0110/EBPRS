snpEMrobust<-function(z, K=2, maxIter=1000, tol=1e-3, empNull=F, boot=1, info=TRUE){
  m <-length(z)
  #	beta0 <- seq(m/2, 0, length.out=21)
  blength1 <- 21
  beta0 <- seq(0, m/5, length.out=blength1)
  cat('Initial Fitting...\n')
  EMresult0 <- snpEM(z, K, maxIter, tol, m/20, empNull, info=info)
  nullSigma2 <- min(median(z^2)/0.455-1, EMresult0$sigma02)
  sigma02List <- pmax(nullSigma2,EMresult0$sigma02*c(0.8,1,1.2)^2)
  sigma02List <- unique(sigma02List)

  relErr<-rep(0, blength1)

  for(i in 1:blength1){
    if(info) cat(i,': Set beta0 to',beta0[i],'\n')
    for(l in 1:length(sigma02List)){
      sigma02tmp<-sigma02List[l]
      for(k in 1:boot){
        zTmp <- rnormMix(m, sigma02tmp, EMresult0$Pi1, EMresult0$sigma2)$z
        #Use the test and train data partitions however you desire...
        cat('Perturbation:',l,'/',length(sigma02List),'Boot:',k,'/',boot)
        EMresultTmp <- snpEM(zTmp, K, maxIter, tol, beta0[i], empNull, info=F)
        tmpRelErr <- calRelErr(sigma02tmp, EMresult0$Pi1, EMresult0$sigma2, EMresultTmp$sigma02, EMresultTmp$Pi1, EMresultTmp$sigma2)
        cat(' RelErr:',tmpRelErr,'\n')
        relErr[i] <- relErr[i]+tmpRelErr
      }
    }
    relErr[i] <- relErr[i]/(boot*length(sigma02List))
    if(info)
      cat('Avg. Relative Error: ',relErr[i],'\n')
  }
  lLim<-beta0[ifelse(which.min(relErr)==1, 1, which.min(relErr)-1)]
  uLim<-beta0[ifelse(which.min(relErr)==blength1, blength1, which.min(relErr)+1)]
  cat('Further searching optimal beta0 within [', lLim, ',',uLim,']','\n')

  beta0 <- c(beta0, seq(lLim, uLim, length.out=21))
  beta0 <- unique(beta0)
  relErr <- c(relErr, rep(0, length(beta0)-blength1))
  for(i in (blength1+1):length(beta0)){
    if(info) cat(i,': Set beta0 to',beta0[i],'\n')
    for(l in 1:length(sigma02List)){
      sigma02tmp<-sigma02List[l]
      for(k in 1:boot){
        zTmp <- rnormMix(m, sigma02tmp, EMresult0$Pi1, EMresult0$sigma2)$z
        #Use the test and train data partitions however you desire...
        cat('Perturbation:',l,'/',length(sigma02List),'Boot:',k,'/',boot)
        EMresultTmp <- snpEM(zTmp, K, maxIter, tol, beta0[i], empNull, info=F)
        tmpRelErr <- calRelErr(sigma02tmp, EMresult0$Pi1, EMresult0$sigma2, EMresultTmp$sigma02, EMresultTmp$Pi1, EMresultTmp$sigma2)
        cat(' RelErr:',tmpRelErr,'\n')
        relErr[i] <- relErr[i]+tmpRelErr
      }
    }
    relErr[i] <- relErr[i]/(boot*length(sigma02List))
    if(info)
      cat('Avg. Relative Error: ',relErr[i],'\n')
  }
  optBeta0 <- beta0[which.min(relErr)]
  if(info){
    cat('Optimal Beta0 =',optBeta0,'\n')
    cat('Start Inference using optimized Beta0\n')
  }
  EMresult <- snpEM(z, K, maxIter, tol, optBeta0, empNull, info)
  return(EMresult)
}


calRelErr<-function(sigma02_t, Pi1_t, sigma2_t, sigma02_t1, Pi1_t1, sigma2_t1){
  nanVal<-function(x) ifelse(is.nan(x),0,x)

  relErr<-sqrt(nanVal(sum((Pi1_t1-Pi1_t)^2)/sum(Pi1_t^2))) + Reduce('+',Map(function(x,y){return(ifelse(sum(y^2)==0, 0, sqrt(sum((x-y)^2)/sum(y^2))))},sigma2_t1,sigma2_t))+nanVal((sigma02_t1-sigma02_t)/sigma02_t)
  return(relErr)
}
