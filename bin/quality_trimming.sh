#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Quality filtering of RNAseq raw reads using TrimGalore ##
##                                                                           ##
###############################################################################

# var settings
args=("$@")
CPUS=${args[0]}
R1=${args[1]}
R2=${args[2]}
LENGTH=${args[3]}
QUAL=${args[4]}
STRINGENCY=${args[5]}
ERROR=${args[6]}
OUTPUT_DIR=${args[7]}
LOGCMD=${args[8]}

#Run TrimGalore
CMD="trim_galore -j ${CPUS} --paired --retain_unpaired --output_dir ${OUTPUT_DIR} --length ${LENGTH} -q ${QUAL} --gzip --stringency ${STRINGENCY} -e ${ERROR} ${R1} ${R2}"
echo ${CMD} > ${LOGCMD}
eval ${CMD}
