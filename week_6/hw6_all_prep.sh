#!/bin/bash

##This session only need to be done once

##path
atac_bam="/pub/jenyuw/EE283/ATACseq/results/aligned_bam"

ls ${atac_bam}/*A4.*.sort.bam >${atac_bam}/atac-A4-list.txt
