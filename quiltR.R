setwd("./permutations/batchPerms/")
getwd()
#ctrl <- readRDS("controller.rds)

buildOut <- list()
for(i in 1:max(ctrl$seed)){
  ind <- ctrl$aID[ctrl$seed == i]
  buildSeed <- list()
  for(j in seq_along(ind)){
    print(ind[j])
    fileIn <- list.files("./",pattern = paste0("_",ind[j],".rds"), full.names = T)
    tmp <- readRDS(fileIn)
    buildSeed[[j]] <- tmp
  }
  tmpSeed <- do.call(cbind.data.frame,buildSeed)
  buildOut[[i]] <- tmpSeed
}
out <- do.call(rbind, buildOut)


