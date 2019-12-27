
findpara_ltdr <- function(n0,n1,SE,beta,z,pi0Hat,sigma02,ltdr,lfdr){
  kk <- length(ltdr)
  n <- n0+n1
  m <- length(z)
  c <- 2*sqrt(n0*n1/n)
  # lfdr <- rep(0,m)
  sigmaHat2 <- rep(0,m)
  f1 <- rep(0,m)
  f0 <- rep(0,m)
  # pval <- rep(0,m)
  k <- n1/n
  muHat <- rep(0,m)
  #newmuHat2 <- rep(0,m)
  sigmaHat2<- 4/c^2/(SE)^2
  sigma0Hat2 <- sigma02/c^2
  for(j in 1:m ){
    # lfdr <- pi0Hat*dnorm(z[j])/(pi0Hat*dnorm(z[j])+
    #                            (1-pi0Hat)*dnorm(z[j]/sqrt(1+c^2*sigma0Hat2)))
    mu <- c*sigma0Hat2*z[j]/(1+c^2*sigma0Hat2)
    for(w in 1:kk){
      muHat[j] <- muHat[j]+mu[w]*ltdr[[w]][j]
    }
    #newmuHat2[j] <- (1-lfdr[j])*((c*sigma0Hat2*z[j]/(1+c^2*sigma0Hat2))^2+sigma0Hat2^2/(1+c^2*sigma0Hat2+1))
  }

  return(list(muHat=muHat,pi0Hat=pi0Hat,sigma0Hat2=sigma0Hat2,sigmaHat2=sigmaHat2))

}
