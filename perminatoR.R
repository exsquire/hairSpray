perminatoR <- function(x){
  #Build dataframe with array number, start, stop, seed, and n_perm
  #We keep seed so this function is basically a parallelized version
  #Of scan1perm
  
  #Ask pheno and nperm chunk
  askChunk <- as.numeric(readline("Enter chunk size: "))
  choices <- c(1,2,4,5,8,10,20,
               25,40,50,100,125,
               200,250,500,1000)
  
  askPerm <- menu(as.character(choices), 
                  title = "Please select n_perm",
                  graphics = T)
  askPerm <- choices[askPerm]
  
  #Pull total number of phenos
  numPhen <- ncol(x)
  
  #Begin with start
  start1 <- seq(1, numPhen, by = askChunk)
  stop1 <- c(start1[-1] - 1, numPhen)
  
  #The number of chunks for one full permutation equals:
  onePerm <- length(start1)
  
  seed <- rep(seq(1,1000/askPerm), each = onePerm)
  
  #The number of n_perm chunks to 1000 permutations
  permChunks <- length(unique(seed))
  
  #Start and stop vecs
  startVec <- rep(start1, 
                  times = permChunks)
  stopVec <- rep(stop1, 
                 times = permChunks) 
  
  aID <- seq(1,length(seed))
  
  if(permChunks*askPerm < 1000){
    while(length(unique(seed))*askPerm < 1000){
      askPerm <- askPerm+1
    }
    cat("Setting n_perm to", askPerm)
    cat("\nNumber of unique permutations:",
        length(unique(seed))*askPerm)
    
    seed <- rep(seq(1,1000/askPerm), each = onePerm)
    
    #The number of n_perm chunks to 1000 permutations
    permChunks <- length(unique(seed))
    
    #Start and stop vecs
    startVec <- rep(start1, 
                    times = permChunks)
    stopVec <- rep(stop1, 
                   times = permChunks) 
    
    aID <- seq(1,length(seed))
  }
  
  controller <- data.frame(aID = aID,
                           start = startVec,
                           stop = stopVec,
                           seed = seed,
                           n_perm = askPerm)
  cat("Generating Controller File...")
  cat("\nPhenotypes run in chunks of",
      askChunk,
      ".\nPerforming",
      askPerm,
      "permutations per chunk.\n")
  cat("\nSingle run partitioned into [",onePerm,"] chunks.")
  cat("\n[",1000/askPerm,"] runs per 1000 permutations.")
  cat("\nTotal jobs:[", nrow(controller),"]")
  
  
  gc()
  cat("\nDone.")
  return(controller)
}

