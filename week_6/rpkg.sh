#/bin/bash

#SBATCH --job-name=rpkgs    ## Name of the job.
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1   ## number of tasks to launch (wc -l prefixes.txt)
#SBATCH --cpus-per-task=2    ## number of cores the job needs 

module module load R/4.1.2
Rscript pkg-installing.r
