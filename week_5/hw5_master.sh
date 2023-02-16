#!/bin/bash

##This is the master file

./hw5_all_prep.sh

jobID1=$(sbatch hw5_1.sh |cut -d " " -f 4)
squeue -u jenyuw

jobID2=$(sbatch --dependency=afterok:$jobID1 hw5_2.sh |cut -d " " -f 4)
jobID3=$(sbatch --dependency=afterok:$jobID2 hw5_3.sh |cut -d " " -f 4)
jobID4=$(sbatch --dependency=afterok:$jobID3 hw5_4.sh |cut -d " " -f 4)

echo "All jobs are submitted"
squeue -u jenyuw
