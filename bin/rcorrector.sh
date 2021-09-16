#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: RNAseq raw reads correction using Rcorrector           ##
##                                                                           ##
###############################################################################

# var settings
args=("$@")
CPUS=${args[0]}
FASTQ_R1=${args[1]}
FASTQ_R2=${args[2]}
LOGCMD=${args[3]}

#Run Rcorrector
CMD="run_rcorrector.pl -1 ${FASTQ_R1} -2 ${FASTQ_R2} -t ${CPUS}"
echo ${CMD} > ${LOGCMD}
eval ${CMD}
