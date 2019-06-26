#Permutation Test - Max Cores, Single Run
library(qtl2)

#Intialize arguments - allow cores to be controlled from SBATCH
args<-as.integer(unlist(strsplit(commandArgs(TRUE)," ")))
print(args)

ncore <- args[1]
print(ncore)

perms <- args[2]
print(perms)

#Read in inputs
apr <- readRDS("./DO2_alleleprob.rds")
phen <- readRDS("./samp1000.rds")
kLOCO <- readRDS("./DO2_kLOCO.rds")
covar <- readRDS("./addcovar.rds")

#Run the permutation test
permOut <- scan1perm(apr, phen,
                     kinship = kLOCO,
                     addcovar = covar, 
                     n_perm = perms,
                     cores = ncores)

saveRDS(permOut, file = "permOut_SingleRun.rds")
