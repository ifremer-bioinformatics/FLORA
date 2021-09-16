process rnaseq_correction {

    tag "$id"
    label 'rcorrector'
    beforeScript '. /appli/bioinfo/rcorrector/1.0.4/env.sh'
 
    publishDir "${params.outdir}/${params.results_dirname}", mode: 'copy', pattern : 'rcorrector.cmd', saveAs : { rcorrector_cmd -> "cmd/${task.process}_complete.sh" }

    input:
        tuple val(id), path(fastq)

    output:
        tuple val(id), file('*_R1_001.cor.fq.gz'), file('*_R2_001.cor.fq.gz'), emit: fastq_corrected
        path("rcorrector.cmd"), emit: rcorrector_cmd

    script:
    """
    rcorrector.sh ${task.cpus} ${fastq[0]} ${fastq[1]} rcorrector.cmd &> rcorrector_${id}.log 2>&1
    """
}
