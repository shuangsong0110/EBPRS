#' Description of the package
#'
#' @description
#' Description of the package. This is the 2.0.0 version.
#' @details
#' EB-PRS is a novel method that leverages information for effect sizes across all the markers to improve the prediction accuracy.  No parameter tuning is needed in the method, and no external information is needed. This R-package provides the calculation of polygenic risk scores from the given training summary statistics and test data. We can use EB-PRS to extract main information, estimate Empirical Bayes parameters, derive polygenic risk scores for  each individual in test data, and evaluate the PRS according to AUC and predictive r2.
#' \tabular{ll}{
#' Package: \tab EBPRS\cr
#' Type: \tab Package\cr
#' Date: \tab 2019-12\cr
#' Version: \tab 2.0.0\cr
#' }
#'
#' The package contains two main functions for users, \code{EBPRS}, and \code{validate}.
#'
#' 1. \code{EBPRS}. This function integrate three parts: (1) merge the train and test (if have)
#' data, (2) estimate effectsize (3) generate polygenic risk scores (if test data provided.)
#'
#'
#' There is a strict requirement for the format of imput, which is
#' detailedly illustrated in details in \code{EBPRS}. The training summary statistics are necessary.
#' The test data can either
#' be included in the input or not. If test data are provided. The function will first
#' merge the data, as well as generate scores for each person in the result.
#' Here we mention that
#' the we recommend users first use package \code{plink2R} from github to read plink files into R,
#' and the data transfered by \code{read_plink} from \code{plink2R} can be directly used as our input.
#' A merge of training set and testing set will also be made.
#'
#'   \code{plink2R} can be installed using this command:
#'
#'    \code{options(unzip = "internal")}
#'
#'   \code{devtools::install_github("gabraham/plink2R/plink2R")}
#'
#'
#' 2. \code{validate}. We use this to validate the performance of the PRS.
#'
#'
#' 3. \code{data("traindat")} for the example training dataset.
#'
#'
#' A complete pipeline can be:
#'
#' result <- EBPRS(train=traindat, test=plinkfile, N1, N0)
#'
#' validate(truey, result$S)
#'
#' or
#'
#' result <- EBPRS(train=traindat, N1, N0)
#'
#'
#' @references
#' Song, S., Jiang, W., Hou, L. and Zhao, H. (2019). Leveraging effect size distributions to improve polygenic risk scores derived from genome-wide association studies. \emph{PLoS Compuational Biology}.
#'
#' @seealso
#' \code{\link{EBPRS}},
#' \code{\link{validate}},
#'
#' \url{https://github.com/gabraham/plink2R}
#' @author
#' Shuang Song, Wei Jiang, Lin Hou and Hongyu Zhao
#' @export

EBPRSpackage <- function(){}
