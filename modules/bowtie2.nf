process rrna_removal {

    tag "$id"
    label 'rrna_removal'
    beforeScript '. /appli/bioinfo/bowtie2/2.4.1/env.sh'
 
    publishDir "${params.outdir}/${params.results_dirname}", mode: 'copy', pattern : 'bowtie2.cmd', saveAs : { bowtie2_cmd -> "cmd/${task.process}_complete.sh" }

    input:
        tuple val(id), path(corrected_reads)

    output:
        tuple val(id), path("filtered_rrna_read_*.fq.{1,2}.gz"), emit: filtered_rrna
        path("bowtie2.cmd"), emit: bowtie2_cmd

    script:
    """
    remove_rrna.sh ${task.cpus} ${params.rrna_db} ${corrected_reads[0]} ${corrected_reads[1]} filtered_rrna_read_${id}.fq.gz bowtie2.cmd &> bowtie2_${id}.log 2>&1
    """
}
