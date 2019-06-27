#Allow for sbatch control of a single block test
library(qtl2)

#Read in inputs
apr <- readRDS("./DO2_alleleprob.rds")
phen <- readRDS("./samp1000.rds")
kLOCO <- readRDS("./DO2_kLOCO.rds")
covar <- readRDS("./addcovar.rds")

#Intialize array id
args<-as.integer(unlist(strsplit(commandArgs(TRUE)," ")))
print(args)

start <-args[1]
print(start)

stop <-args[2]
print(start)

ncore <- args[3]
print(ncore)

perms <- args[4]
print(perms)

#no perms argument from sbatch, arrayid selects perms via ctrl
perm <- scan1perm(apr,
                  phen[,start:stop, drop = FALSE],
                  kinship = kLOCO,
                  addcovar = covar,
                  cores = ncore, 
                  n_perm = perms)

out <- data.frame(perm, check.names = F)


#can also save "out" data
saveRDS(out, file = "blockTest.rds")
