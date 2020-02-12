# EBPRS
EB-PRS is a novel method that leverages information for effect sizes across all the markers to improve the prediction accuracy.  No parameter tuning is needed in the method, and no external information is needed. This R-package provides the calculation of polygenic risk scores from the given training summary statistics and testing data. We can use EB-PRS to extract main information, estimate Empirical Bayes parameters, derive polygenic risk scores for  each individual in testing data, and evaluate the PRS according to AUC and predictive r2. See Song et al. (2020) <doi:10.1371/journal.pcbi.1007565> for a detailed presentation of the method.

## Version
2.0.2

Please see the manual EBPRS-manual-2.0.2.pdf for the detailed description and instructions aboout the package.

## Install
```
devtools::install_github("shuangsong0110/EBPRS")
```

If there are connection problems, such as "Error in utils", users could download the .zip file to the local and use 
```
devtools::install_github("/$path$/EBPRS-master/EBPRS-master")
```
to solve the problem.


## References
Song S, Jiang W, Hou L, Zhao H (2020) Leveraging effect size distributions to improve polygenic risk scores derived from summary statistics of genome-wide association studies. PLoS Comput Biol 16(2): e1007565. https://doi.org/10.1371/journal.pcbi.1007565

## License
GPL-3

## Depends
R (>= 3.4.0), ROCR, methods
