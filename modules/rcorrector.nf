process rnaseq_correction {

    tag "$id"
    label 'rcorrector'
    beforeScript '. /appli/bioinfo/rcorrector/1.0.4/env.sh'
 
    publishDir "${params.outdir}/${params.results_dirname}", mode: 'copy', pattern : 'rcorrector.cmd', saveAs : { rcorrector_cmd -> "cmd/${task.process}_complete.sh" }

    input:
        tuple val(id), path(fastq)

    output:
        tuple val(id), path("*_R{1,2}_001.cor.fq.gz"), emit: fastq_corrected
        path("rcorrector.cmd"), emit: rcorrector_cmd

    script:
    """
    rcorrector.sh ${task.cpus} ${fastq[0]} ${fastq[1]} rcorrector.cmd &> rcorrector_${id}.log 2>&1
    """
}

process filter_uncorrectable_fastq {

    tag "$id"
    label 'filter_uncorrect'
    beforeScript '. /appli/bioinfo/rcorrector/1.0.4/env.sh'

    publishDir "${params.outdir}/${params.results_dirname}", mode: 'copy', pattern : 'filter_uncorrectable_fastq.cmd', saveAs : { filter_uncorrectable_fastq_cmd -> "cmd/${task.process}_complete.sh" }

    input:
        tuple val(id), path(fastq_corrected)

    output:
        tuple val(id), path("corrected_*_R{1,2}_001.cor.fq"), emit: fastq_only_corrected
        path("filter_uncorrectable_fastq.cmd"), emit: filter_uncorrectable_fastq_cmd

    script:
    """
    FilterUncorrectabledPEfastq.sh ${baseDir}/bin/FilterUncorrectabledPEfastq.py ${fastq_corrected[0]} ${fastq_corrected[1]} corrected filter_uncorrectable_fastq.cmd &> filter_uncorrectable_fastq_${id}.log 2>&1
    """
}
