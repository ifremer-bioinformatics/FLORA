process assembly {

    label 'assembly'
    beforeScript '. /appli/bioinfo/trinity/2.8.5/env.sh'
 
    publishDir "${params.outdir}/${params.results_dirname}/assembly", mode: 'copy', pattern : 'trinity_out_dir.Trinity.fasta'
    publishDir "${params.outdir}/${params.results_dirname}/assembly", mode: 'copy', pattern : 'trinity_out_dir.Trinity.fasta.gene_trans_map'
    publishDir "${params.outdir}/${params.results_dirname}", mode: 'copy', pattern : 'trinity_assembly.cmd', saveAs : { trinity_assembly_cmd -> "cmd/${task.process}_complete.sh" }

    input:
        path(valid_reads)

    output:
        path("trinity_out_dir.Trinity.fasta"), emit: assembly_fasta
        path("trinity_out_dir.Trinity.fasta.gene_trans_map"), emit: gene_trans_map
        path("trinity_assembly.cmd"), emit: trinity_assembly_cmd

    script:
    avail_memory = task.memory.toGiga()
    """
    assembly.sh ${task.cpus} ${params.samples_file} ${avail_memory}G trinity_assembly.cmd &> trinity_assembly.log 2>&1
    """
}
