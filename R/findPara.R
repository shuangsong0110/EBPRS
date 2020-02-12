#' Main function
#'
#' @param train training dataset
#' @param test testing dataset (list) including fam, bed, bim (generated from plink files, plink2R::read_plink is recommended). If missing(test)=T, the function will use all SNPs in training dataset by default.
#' @param N1 case number
#' @param N0 control number
#' @param robust T/F, indicator that whether robust estimation is needed.
#' @return A list containing
#' data.frame (result): combining the summary statistics and estimated effect sizes (eff)
#'
#' estimated effect sizes (eff)
#'
#' estimated mu (muHat)
#'
#' estimated sigma2 (sigmaHat2)
#'
#' estimated proportion of non-associated SNPs (pi0)
#'
#' estimated variance of effect sizes of associated SNPs (sigma02)
#' @description
#' Clean the dataset, extract information from raw data and calculate effect sizes.
#' (Please notice that there are some requirements for the training and testing datasets.)
#' @details
#' The raw training data should be a
#' data.fame including A1, A2, OR, P, SNP (NOTE that the colnames should be exactly consistent with the above).
#'
#'
#' The SNP column (rsid) is used for indexing.
#'
#' An example training dataset can be acquired using data("traindat")
#'
#' "test" file can be generated from read_plink("test_plink_file")
#' The raw testing data could be the files transformed from plink2R (using plink bfiles).
#'
#' test is a list, which has test$fam (6 columns with information on samples), test$bim (6 columns with information on SNPs), test$bed (genotypes matrix 0, 1, 2)
#'
#' Note that in real data, we usually use beta0 = m/20 as the default setting for the EM algorithm,
#' which is accurate enough in most cases and will have little influence on the prediction performance.
#' If more accurate parameter estimation is required, we provide a robust estimation (by setting robust=T),
#' integrating our data-driven bootstrap-based parameter tuning method. This can
#' derive the best parameter for robust estimation, while more time is needed.
#' @references
#' Song S, Jiang W, Hou L, Zhao H (2020) Leveraging effect size distributions to improve polygenic risk scores derived from summary statistics of genome-wide association studies. PLoS Comput Biol 16(2): e1007565. https://doi.org/10.1371/journal.pcbi.1007565
#' @seealso
#' \url{https://github.com/gabraham/plink2R}
#' @author
#' Shuang Song, Wei Jiang, Lin Hou and Hongyu Zhao
#' @importFrom utils write.table
#' @export


EBPRS <- function(train,test,N1,N0,robust=F){
  if(missing(test)==T){
    temp0 <- extractInfo(train)
    train <- temp0$train
  }
  else{
    temp0 <- extractInfo(train,test)
    train <- temp0$train
    # fam <- temp$fam
    bim <- temp0$bim
    # bed <- temp$bed

    cat("Coordinating the ref alleles...","\n")
    colnames(train)[which(colnames(train)=="a1")] <- "A1"
    colnames(train)[which(colnames(train)=="a2")] <- "A2"
    colnames(train)[which(colnames(train)=="or")] <- "OR"
    colnames(train)[which(colnames(train)=="p")] <- "P"
    # a=train$A1
    # b=bim[,5]
    sig=agtc(train$A1,train$A2,bim[,5],bim[,6])
    train$OR=(train$OR)^sig
  }
    z <- -qnorm(train$P/2)*sign(log(train$OR))
    se <- log(train$OR)/z
    z[which(is.na(z))] <- 0
    se[which(is.na(se))] <- 1
    cat("Utilizing EM algorithm to derive pi0 and sigma02","\n")
    if(robust==F){
      temp <- snpEM(z,empNull=F,beta0=(length(z)/20), K=3)
    }else{
      temp <- snpEMrobust(z, K=3, maxIter=1000, tol=1e-3, empNull=F, boot=1, info=TRUE)
    }
    res <- findpara_ltdr(n0=N0,n1=N1,SE=se,beta=log(train$OR),z=z,pi0Hat=temp$pi0,sigma02=temp$sigma2,ltdr=temp$ltdr,lfdr=temp$lfdr)
    cat("Estimating the parameters.","\n")
    muHatnew <- res$muHat/sqrt(res$sigmaHat2)
    muHatnew[which(is.na(muHatnew))] <- 0
    result <- data.frame(train,effectsize=muHatnew)
    #result=data.frame(muHat=res$muHat,sigmaHat2=res$sigmaHat2)
    write.table(result,"res_para.txt")
    cat("Completed.","\n")
    if(missing(test)==F){
      cat("Now calculating scores \n")
      S <- generateScore(muHatnew, temp0$bed)
      validate(S, test$fam[,6])
      return(list(result=result,S=S,muHat=res$muHat,sigmaHat2=res$sigmaHat2,pi0=temp$pi0,sigma02=temp$sigma02,eff=muHatnew))
    }
    else{
      return(list(result=result,muHat=res$muHat,sigmaHat2=res$sigmaHat2,pi0=temp$pi0,sigma02=temp$sigma02,eff=muHatnew))
    }
}
