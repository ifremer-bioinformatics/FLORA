#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Remove rRNA from RNAseq raw reads using Bowtie2 and    ##
##                    the SILVA database                                     ##
##                                                                           ##
###############################################################################

# var settings
args=("$@")
CPUS=${args[0]}
RRNA_DB=${args[1]}
R1=${args[2]}
R2=${args[3]}
FILTERED_READS=${args[4]}
LOGCMD=${args[5]}

#Run Bowtie2
CMD="bowtie2 --quiet --nofw  --very-sensitive --phred33 -x ${RRNA_DB} -p ${CPUS} -1 ${R1} -2 ${R2} --un-conc-gz ${FILTERED_READS}"
echo ${CMD} > ${LOGCMD}
eval ${CMD}
