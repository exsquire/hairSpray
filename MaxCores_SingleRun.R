#Permutation Test - Max Cores, Single Run
#Rscript portion of Max Core Single Run Design
library(qtl2)

#Intialize arguments - allow cores to be controlled from SBATCH
args<-as.integer(commandArgs(TRUE))
print(args)

ncores <-args[1]
print(ncores)

#Read in inputs
apr <- readRDS("./DO2_alleleprob.rds")
phen <- readRDS("./DO2_permPhenos.rds")
kLOCO <- readRDS("./DO2_kLOCO.rds")
covar <- readRDS("./addcovar.rds")

#Run the permutation test
permOut <- scan1perm(apr, phen[,1,drop = F],
                     kinship = kLOCO,
                     addcovar = covar, 
                     n_perm = 1000,
                     cores = ncores)

saveRDS(permOut, file = "permOut_SingleRun.rds")
