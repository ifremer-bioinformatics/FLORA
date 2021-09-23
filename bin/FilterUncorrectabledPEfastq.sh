#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Remove RNAseq raw reads uncorrectable with Rcorrector  ##
##                    using a custom python script                           ##
##                                                                           ##
###############################################################################

# var settings
args=("$@")
PYTHON_SCRIPT=${args[0]}
CORRECTED_R1=${args[1]}
CORRECTED_R2=${args[2]}
OUTPUT_PREFIX=${args[3]}
LOGCMD=${args[4]}

#Filter uncorrectable RNAseq raw reads
CMD="python ${PYTHON_SCRIPT} -1 ${CORRECTED_R1} -2 ${CORRECTED_R2} -o ${OUTPUT_PREFIX}"
echo ${CMD} > ${LOGCMD}
eval ${CMD}
