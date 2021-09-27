#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Assembly RNAseq reads using Trinity                    ##
##                                                                           ##
###############################################################################

# var settings
args=("$@")
CPUS=${args[0]}
SAMPLES_FILE=${args[1]}
MEM=${args[2]}
LOGCMD=${args[3]}

#Run TrimGalore
CMD="Trinity --seqType fq --CPU ${CPUS} --samples_file ${SAMPLES_FILE} --no_normalize_reads --full_cleanup --max_memory ${MEM}"
echo ${CMD} > ${LOGCMD}
eval ${CMD}
