#UPDATE*:2/8/19, the number of failed jobs often creates failed lists that are larger than 
#The allowable amount that sbatch can read at once. 
#Make missingNo do the .txt.transformations that unix does, then, if longer than X length, 
#Cut each into its own list. 

#Gold Standard: Unix can only accept a txt file of 
#certain byte size, use a while loop to grow and check 
#for each cut and stop at the limit. 

#Develop code that loops through the output, taking i = a and 
#nexting as long as i+1 is a + 1. When it doesn't, take the
#last 

#Write function missingNo(), which takes in a folder name in
#your working directory and a number that represents the expected 
#number of output files from your cluster run and outputs a list
#of missing file numbers

#If sourcing file, let this show up to guide user
cat("\nInitializing missingNo Failed Run Identifier\nex.) missingNo([folder location],[expected#files])\ne.g. missingNo('./addCovarOuts/',42250)\n")
#Have .sh look for failed_list* and run the for loop below that puts 
#The comma in for the re-run

#Each number represents an array run, by returning a list of array 
#runs that did not output a file, we can reference the .err/.out files
#to examine the problem or simply re-run them in command line

missingNo <- function(x, expected){
  #List of all expected runs 
  exp_seq <- seq(1:expected)
  #List files in input folder
  list.names <- list.files(paste(x))
  #extract the numerics from each file name
  numbers <-  as.numeric(gsub("^.*_|\\..*$","",list.names))
  
  #output holds missing values  
  output <- exp_seq[!exp_seq %in% numbers]
  print(paste0("Run quality: %", round((1 - length(output)/expected)*100, 2)))
  print("The following runs have failed:")
  print(output)
  
  #If more than 100, do a bunch of shit, if not, just sink output into failed.txt
  if(length(output) > 20){
    cat("Damn, son. There are more than 20 missing files\n")
    #FIrst gate: Offer to use interval notation
    gate <- NULL
    errCount <- 0
    while(is.null(gate)){
      userIn <- readline("Use interval notation to reduce list size? (Y/N)")
      if(userIn %in% c("Y","N")){
        gate <- userIn
      }else{
        errCount <- errCount + 1
      if(errCount > 5){
        stop("OK, dum-dum, you're booted.\n")
        }
      }
    }
    #if no, then sink output 
    if(gate == "N"){
      ask <- readline("\nSubtract indices for large jobs? (Y/N)\n")
      if(ask == "Y"){
        sub <- as.numeric(readline("How much?: "))
        output <- output - sub
      }
        #Sink output into .txt file
        vec=paste(as.character(output), collapse=",")
        sink("failed.txt")
        cat(vec)
        cat("\n")
        sink()
        cat("\nWriting file 'failed.txt' to working directory.\n")
        invisible(gc())
        return(TRUE)
    }
    #if yes, set up outvec and stream
    outvec <- character()
    stream <- numeric()
    if(gate == "Y"){
        ask <- readline("\nSubtract indices for large jobs? (Y/N)\n")
        if(ask == "Y"){
          sub <- as.numeric(readline("How much?: "))
          output <- output - sub
        }
        cat("\nConverting sequential runs to interval notation.\n")
        #Convert numvec to include intervals  
        for(i in 1:length(output)){
          #Prevent running off edge
          if(i == length(output)){
            outvec <- c(outvec, output[i])
            break()
          }
          if(output[i] %in% stream){
            next()
          }
          #If next value is NOT sequential to current
          if((output[i+1]-1) != output[i]){
            #append current to outvec and skip
            outvec <- c(outvec,as.character(output[i]))
            next()
          }else{
            #Find the last index of a sequence
            k = i
            j = i + 1
            while(k < length(output) & 
                  j < length(output) &
                  (output[j]-1) == output[k]){
              k = k + 1
              j = j + 1
            }
            stream <- output[i:k]
            #only dash if more than 2
            if(k-i > 1){
              bunch <- paste0(output[i],"-",output[k])
              outvec <- c(outvec,bunch)
            }else{
              outvec <- c(outvec, output[i], output[k])
            }
           }
        }#end for loop
      }#end interval notation chunk 
      #Gate2: check if outvec is still too long
      gate2 <- NULL
      if(length(outvec) > 100){
          errCount2 <- 0
          while(is.null(gate2)){
            userIn2 <- readline("Still too long for command line.\nCut into separate files? (Y/N):")
            if(userIn2 %in% c("Y","N")){
              gate2 <- userIn2
            }else{
              errCount2 <- errCount2 + 1
              if(errCount2 > 5){
                stop("OK, dum-dum, you're booted.\n")
              }
            }
          }
          if(gate2 == "Y"){
          n <- as.numeric(readline("Number of cuts?: "))
          x <- 1:length(outvec)
          #taking the remainder of each element groups them as evenly as possible
          splitVec <- split(x, sort(x%%n))
          for(i in 1:length(splitVec)){
            vec=paste(unique(outvec[splitVec[[i]]]), collapse=",")
            sink(paste0("failed_",i,".txt"))
            cat(vec)
            cat("\n")
            sink()
            cat("\nWriting file",i,"to working directory.\n")      
          }
          invisible(gc())
          return(TRUE)
         }else{
           #Sink output into .txt file
           vec=paste(as.character(outvec), collapse=",")
           sink("failed.txt")
           cat(vec)
           cat("\n")
           sink()
           cat("\nWriting file 'failed.txt' to working directory.\n")
         }
        }
      invisible(gc())
      return(TRUE)
    }
}



#cat('In terminal, run code:\nfor i in `cat failed.txt`; do echo -n "$i,"; done > failed_list.txt\n')
cat("Resubmit sbatch with --array=`cat failed.txt`\n")

#DO2
#failed_runs <- missingNo("DO2_outs", 1609, hasNum = TRUE)
#


#>>>dos2unix failed.txt
#>>>for i in `cat failed.txt`; do echo -n "$i,"; done > failed_list.txt
#>>>sbatch --array=`cat failed_list.txt`  DOren_scan.sh

#failed_list will have a trailing comma, doesn't matter, but can fix with
#>>> echo "'a','b','c','d'," | sed 's/,$//g'


