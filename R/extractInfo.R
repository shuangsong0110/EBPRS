extractInfo <- function(train,test){
  if(missing(test)==T){
    cat("No testing data are provided.","\n")
    cat("All the SNPs in training data will be used.","\n")
    cat("Only estimated effect sizes are generated, instead of the polygenic risk socres.","\n")
    snpNum <- dim(train)[1]
    Info <- list(train=train)
    cat("Completed.","\n")
    temp1 <- paste0(snpNum," SNPs are included in calculating PRS.","\n")
    cat(temp1)
    return(Info)
  }
  else{
    cat("Merging the data...","\n")
    trainindex <- data.frame(snp=train$SNP,indextrain=1:nrow(train))
    testindex <- data.frame(snp=test$bim[,2],indextest=1:nrow(test$bim))
    colnames(trainindex)[1] <- "snp"
    colnames(testindex)[1] <- "snp"
    index <- merge(trainindex,testindex,by="snp")
    index=cbind(index,1:nrow(index))
    #write.table(index,"index.txt")

    train1 <- train[index[,2],]
    bed1 <- test$bed[,index[,3]]
    bim1 <- test$bim[index[,3],]
    fam1 <- test$fam
    #rm(train)
    #rm(test)
    # cat("Processing NAs in bed file...","\n")
    # bed1 <- bedNA0(bed1)
    snpNum <- dim(train1)[1]
    peoNum <- dim(fam1)[1]

    Info <- list(train=train1,bed=bed1,bim=bim1,fam=fam1)
    cat("Completed.","\n")
    temp1 <- paste0(snpNum," SNPs are included in calculating PRS.","\n")
    cat(temp1)
    temp2 <- paste0(peoNum," individuals in total.","\n")
    cat(temp2)
    return(Info)
  }
}
