process quality_trimming {

    tag "$id"
    label 'quality_trimming'
    beforeScript '. /appli/bioinfo/trim-galore/0.6.7/env.sh'
 
    publishDir "${params.outdir}/${params.results_dirname}", mode: 'copy', pattern : 'trimmed_reads_output/filtered_rrna_read_*.fq.{1,2}.gz_val_{1,2}.fq.gz'
    publishDir "${params.outdir}/${params.results_dirname}", mode: 'copy', pattern : 'trimmed_reads_output/*_trimming_report.txt'
    publishDir "${params.outdir}/${params.results_dirname}", mode: 'copy', pattern : 'trimgalore.cmd', saveAs : { trimgalore_cmd -> "cmd/${task.process}_complete.sh" }

    input:
        tuple val(id), path(filtered_reads)

    output:
        path("trimmed_reads_output/*_trimming_report.txt"), emit: report
        tuple val(id), path("trimmed_reads_output/filtered_rrna_read_*.fq.{1,2}.gz_val_{1,2}.fq.gz"), emit: validate_reads
        path("trimgalore.cmd"), emit: trimgalore_cmd

    script:
    """
    quality_trimming.sh ${task.cpus} ${filtered_reads[0]} ${filtered_reads[1]} ${params.min_length} ${params.min_quality} ${params.stringency} ${params.error_rate} trimmed_reads_output trimgalore.cmd &> trimgalore_${id}.log 2>&1
    """
}
