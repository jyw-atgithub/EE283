## intro

This folder contains separate scripts for alignments of DNA, RNA and ATAC seq. They are name by {DNA,ATAC,RNA}_mapping.sh
Before mapping, we have to prepare file lists for array jobs and index for mapping. 
The script for preperation is called all_perp.sh, which is only  needed once. 

## Answer to Question 1

The trimming process removed some low quality bases form both ends, which made the score distribution better. 
Because some sequences were trimmed, the length distribution was wider than the original sequences.
The backword read did not pass the "Per tile sequence quality" session, even after trimming.
The quality of the forward reads were better.
