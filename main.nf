#!/usr/bin/env nextflow
/*
========================================================================================
                                  FLORA workflow                                     
========================================================================================
 workFLOw for Rnaseq analyses of Amocyst project.
 #### Homepage / Documentation
 https://gitlab.ifremer.fr/cn7ab95/FLORA
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl=2

def helpMessage() {
    // Add to this help message with new command line parameters
    log.info SeBiMERHeader()
    log.info"""

    Usage:

    The typical command for running the pipeline according to the conf/base.config file is as follows:

	nextflow run main.nf

	Mandatory:
	--rawdata	[path]		Path to the RNAseq raw data.
        --rrna_db	[path]		Path to a rRNA database to remove them from raw reads.
	--min_length	[str]		Minimum length to keep read after quality trimming.
	--min_quality	[str]		Minimum quality to trim reads.
	--stringency	[str]		Overlap with adapter sequence required to trim a sequence.
	--error_rate	[str]		Maximum allowed error rate.
	--samples_file	[path]		Path to the file describing the condition and replicate ID of each sample used by Trinity.
			
	Other options:
	--outdir [path]			The output directory where the results will be saved.
	-w/--workdir [path]		The temporary directory where intermediate data will be saved.
	-name [str]			Name for the pipeline run. If not specified, Nextflow will automatically generate a random mnemonic.
	--projectName [str]		Name of the project.

	""".stripIndent()
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

/*
 * SET UP CONFIGURATION VARIABLES
 */

// Has the run name been specified by the user?
//  this has the bonus effect of catching both -name and --name
custom_runName = params.name
if (!(workflow.runName ==~ /[a-z]+_[a-z]+/)) {
    custom_runName = workflow.runName
}

//Copy config files to output directory for each run
paramsfile = file("$baseDir/conf/base.config", checkIfExists: true)
paramsfile.copyTo("$params.outdir/00_pipeline_conf/base.config")

/*
 * PIPELINE INFO
 */

// Header log info
log.info SeBiMERHeader()
def summary = [:]
if (workflow.revision) summary['Pipeline Release'] = workflow.revision
summary['Run Name'] = custom_runName ?: workflow.runName
summary['Project Name'] = params.projectName
summary['Output dir'] = params.outdir
summary['Launch dir'] = workflow.launchDir
summary['Working dir'] = workflow.workDir
summary['Script dir'] = workflow.projectDir
summary['User'] = workflow.userName
summary['RawData path'] = params.rawdata
summary['rRNA database path'] = params.rrna_db

log.info summary.collect { k,v -> "${k.padRight(18)}: $v" }.join("\n")
log.info "-\033[91m--------------------------------------------------\033[0m-"

// Check the hostnames against configured profiles
checkHostname()

/*
 * VERIFY AND SET UP WORKFLOW VARIABLES
 */

channel
  .fromFilePairs( params.rawdata )
  .ifEmpty { error "Cannot find RNAseq raw data FASTQ files: ${params.rawdata}. Please configure the 'rawdata' parameter in the base.config file with a valid path." }
  .set { raw_fastq }

/*
 * IMPORTING MODULES
 */

include { rnaseq_correction } from './modules/rcorrector.nf'
include { filter_uncorrectable_fastq } from './modules/rcorrector.nf'
include { rrna_removal } from './modules/bowtie2.nf'
include { quality_trimming } from './modules/trimgalore.nf'
include { assembly } from './modules/trinity.nf'

/*
 * RUN MAIN WORKFLOW
 */

workflow {
    rnaseq_correction(raw_fastq)
    filter_uncorrectable_fastq(rnaseq_correction.out.fastq_corrected)
    rrna_removal(filter_uncorrectable_fastq.out.fastq_only_corrected)
    quality_trimming(rrna_removal.out.filtered_rrna)
        final_reads = quality_trimming.out.reads4assembly.collect()
    assembly(final_reads)
}

/*
 * Completion notification
 */

workflow.onComplete {
    c_green = params.monochrome_logs ? '' : "\033[0;32m";
    c_purple = params.monochrome_logs ? '' : "\033[0;35m";
    c_red = params.monochrome_logs ? '' : "\033[0;31m";
    c_reset = params.monochrome_logs ? '' : "\033[0m";

    if (workflow.success) {
        log.info "-${c_purple}[FLORA workflow]${c_green} Pipeline completed successfully${c_reset}-"
    } else {
        checkHostname()
        log.info "-${c_purple}[FLORA workflow]${c_red} Pipeline completed with errors${c_reset}-"
    }
}

/*
 * Other functions
 */

def SeBiMERHeader() {
    // Log colors ANSI codes
    c_red = params.monochrome_logs ? '' : "\033[0;91m";
    c_blue = params.monochrome_logs ? '' : "\033[1;94m";
    c_reset = params.monochrome_logs ? '' : "\033[0m";
    c_yellow = params.monochrome_logs ? '' : "\033[1;93m";
    c_Ipurple = params.monochrome_logs ? '' : "\033[0;95m" ;

    return """    -${c_red}--------------------------------------------------${c_reset}-
    ${c_blue}    __  __  __  .       __  __  ${c_reset}
    ${c_blue}   \\   |_  |__) | |\\/| |_  |__)  ${c_reset}
    ${c_blue}  __\\  |__ |__) | |  | |__ |  \\  ${c_reset}
                                            ${c_reset}
    ${c_yellow}  FLORA workflow (version ${workflow.manifest.version})${c_reset}
                                            ${c_reset}
    ${c_Ipurple}  Homepage: ${workflow.manifest.homePage}${c_reset}
    -${c_red}--------------------------------------------------${c_reset}-
    """.stripIndent()
}

def checkHostname() {
    def c_reset = params.monochrome_logs ? '' : "\033[0m"
    def c_white = params.monochrome_logs ? '' : "\033[0;37m"
    def c_red = params.monochrome_logs ? '' : "\033[1;91m"
    def c_yellow_bold = params.monochrome_logs ? '' : "\033[1;93m"
    if (params.hostnames) {
        def hostname = "hostname".execute().text.trim()
        params.hostnames.each { prof, hnames ->
            hnames.each { hname ->
                if (hostname.contains(hname) && !workflow.profile.contains(prof)) {
                    log.error "====================================================\n" +
                            "  ${c_red}WARNING!${c_reset} You are running with `-profile $workflow.profile`\n" +
                            "  but your machine hostname is ${c_white}'$hostname'${c_reset}\n" +
                            "  ${c_yellow_bold}It's highly recommended that you use `-profile $prof${c_reset}`\n" +
                            "============================================================"
                }
            }
        }
    }
}
