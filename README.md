# hairSpray
BASH and R script repository for running large quantitative trait loci PERMutations on a SLURM scheduled cluster. 
Certain BASH parameters are specific to the SciNet Ceres cluster. 

Permutation runs allow for empirical determination of significance thresholds. Randomizing the order of genotypes before QTL regression essentially generates a random LOD score. Alone this is useless, but 1,000 of them create a null distribution that demonstrates the range and probability of LOD scores that our data can produce by pure chance. Taking the 95th quantile of this distribution gives us an LOD score that occurs by chance 5% of the time, also known as an alpha of 0.05.    

This repository holds three methods of generating a 1000 x ncol(phenotypes) matrix of permuted LOD scores for the individual thresholding of eQTL hits.
