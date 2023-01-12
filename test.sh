#!/bin/bash
#SBATCH --job-name=test    ## Name of the job.
#SBATCH -A class-ee282       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=1  ## number of cores the job needs


echo "hello world" 
sleep 2m	# wait 2 minutes

