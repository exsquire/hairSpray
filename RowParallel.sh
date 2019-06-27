#!/bin/bash -l
#SBATCH -J RowParallel
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --array=1-1000
#SBATCH --partition=short
#SBATCH --time=48:00:00

#Email me here when job starts, ends, or sh*ts the bed
#SBATCH --mail-user=<Email Here>
#SBATCH --mail-type=ALL

#Run script out of 'scripts' folder 
#Requires a project/{input,output,scripts,config} folder structure
#SBATCH -o ../config/RowParallel-%A_%a.out
#SBATCH -e ../config/RowParallel-%A_%a.err

#SciNet Ceres scratch designation
export SCR_DIR=/local/scratch/$USER/$SLURM_JOBID/$SLURM_ARRAY_TASK_ID

#Use Full Paths
export WORK_DIR=$HOME/parent/DO2/inputs
export OUTPUT_DIR=$HOME/parent/DO2/outputs

# Load R
module load r

# Create scratch & copy everything over to scratch
mkdir -p $SCR_DIR
cd $SCR_DIR

#Copy over everything for permutation Run
cp -p $WORK_DIR/addcovar.rds .
cp -p $WORK_DIR/DO2_alleleprob.rds .
cp -p $WORK_DIR/samp1000.rds .
cp -p $WORK_DIR/DO2_kLOCO.rds .
cp -p $WORK_DIR/RowParallel.R .

#Confirm presence of input files in scratch
echo "before srun in dir"
pwd
echo "contents"
ls -al

# SciNet Ceres automatically cleans up scratch after jobs
# This is nice! But not ubiquitous.
# Termination Signal Trap - when a job goes over its walltime or user cancels job
termTrap()
{
        echo "Termination signal sent. Clearing scratch before exiting"
        # do whatever cleanup you want here
        rm -rf $SCR_DIR/*
        exit -1
}
# associate the function "term_handler" with the TERM signal
trap 'termTrap' TERM

#Run lightweight R instance
#Adding arguments, separate by spaces: taskid, ncores = 4, nperm =1
#Run a single permutation for 1000 phenotypes (samp1000.rds), iterate and name outputs by arrayid
srun R --vanilla --no-save --args "$SLURM_ARRAY_TASK_ID 4 1" <  ./RowParallel.R

#Confirm that output made it
echo "after srun, directory"
ls -al
echo work=$WORK_DIR
echo scr=$SCR_DIR

# Copy results over 
cd $OUTPUT_DIR
#change to output directory (now the pwd)
cp -p $SCR_DIR/permOut_row* .

#Routine Scratch Cleanup
rm -rf $SCR_DIR/*

echo "End of program at `date`"
