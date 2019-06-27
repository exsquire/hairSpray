#Permutation by blocks
#e.g 2000 jobs in 200 5 phenotype chunks with 100 permutations each 
library(qtl2)

#Read in inputs
apr <- readRDS("./DO2_alleleprob.rds")
phen <- readRDS("./samp1000.rds")
kLOCO <- readRDS("./DO2_kLOCO.rds")
covar <- readRDS("./addcovar.rds")
ctrl <- readRDS("./ctrl_samp1000.rds")

#Intialize array id
args<-as.integer(unlist(strsplit(commandArgs(TRUE)," ")))
print(args)

arrayid <-args[1]
print(arrayid)

ncore <- args[2]
print(ncore)

#no perms argument from sbatch, arrayid selects perms via ctrl

#Set arguments from ctrl
start <- ctrl$start[which(ctrl$aID == arrayid)]
stop <- ctrl$stop[which(ctrl$aID == arrayid)]
seed <- ctrl$seed[which(ctrl$aID == arrayid)]
perms <- ctrl$n_perm[which(ctrl$aID == arrayid)]

#Run scan1perm 
set.seed(seed)
perm <- scan1perm(apr,
                  phen[,start:stop, drop = FALSE],
                  kinship = kLOCO,
                  addcovar = covar,
                  cores = ncore, 
                  n_perm = perms)

out <- data.frame(perm, check.names = F)


#can also save "out" data
saveRDS(out, file = paste0("permOut_block",arrayid,".rds"))
