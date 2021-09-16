# FLORA: Usage

## Table of contents
* [Introduction](#introduction)
* [Install the pipeline](#install-the-pipeline)
* [Running the pipeline](#running-the-pipeline)
  * [Updating the pipeline](#updating-the-pipeline)
  * [Reproducibility](#reproducibility)
* [Main arguments](#main-arguments)
* [Mandatory arguments](#mandatory-arguments)
  * [`--rawdata`](#--rawdata)
* [Job resources](#job-resources)
* [Other command line parameters](#other-command-line-parameters)
  * [`--outdir`](#--outdir)
  * [`-w/--work-dir`](#--work-dir)
  * [`-name`](#-name)
  * [`-resume`](#-resume)
  * [`--max_memory`](#--max_memory)
  * [`--max_time`](#--max_time)
  * [`--max_cpus`](#--max_cpus)

## Introduction

Nextflow handles job submissions on SLURM or other environments, and supervises running the jobs. Thus the Nextflow process must run until the pipeline is finished. We recommend that you put the process running in the background through `screen` / `tmux` or similar tool. Alternatively you can run nextflow within a cluster job submitted your job scheduler.

It is recommended to limit the Nextflow Java virtual machines memory. We recommend adding the following line to your environment (typically in `~/.bashrc` or `~./bash_profile`):

```bash
NXF_OPTS='-Xms1g -Xmx4g'
```

## Install the pipeline

### Local installation

How to install FLORA:

```bash
git clone https://gitlab.ifremer.fr/cn7ab95/FLORA.git
```

## Running the pipeline

The most simple command for running the workflow is to use the provided PBS script as follows:

```bash
nextflow run main.nf
```

This will launch the workflow using local configurations.

For our usage, we adapt configuration to our supercomputer and we launch the workflow with our scheduler:

```bash
qsub run-main.nf
```

Note that the pipeline will create the following files in your working directory:

```bash
$SCRACTH/flora_workdir		# Directory containing the nextflow working files
$PWD/results			# Finished results (configurable, see below)
$PWD/.nextflow_log		# Log file from Nextflow
# Other nextflow hidden files, eg. history of pipeline runs and old logs.
```

### Updating the pipeline

When you run the above command, Nextflow automatically runs the pipeline code from your git clone - even if the pipeline has been updated since. To make sure that you're running the latest version of the pipeline, make sure that you regularly update the version of the pipeline:

```bash
cd FLORA
git pull
```

### Reproducibility

It's a good idea to specify a pipeline version when running the pipeline on your data. This ensures that a specific version of the pipeline code and software are used when you run your pipeline. If you keep using the same tag, you'll be running the same version of the pipeline, even if there have been changes to the code since.

First, go to the [FLORA releases page](https://gitlab.ifremer.fr/cn7ab95/FLORA/-/releases) and find the latest version number (eg. `v1.0.0`). 

```bash
cd FLORA
git checkout v1.0.0
```

## Mandatory arguments

### `--rawdata`

Path to the RNAseq raw data files in FASTQ format.

## Job resources

Each step in the pipeline has a default set of requirements for number of CPUs, memory and time. For most of the steps in the pipeline, if the job exits with an error code of `143` (exceeded requested resources) it will automatically resubmit with higher requests (2 x original, then 3 x original). If it still fails after three times then the pipeline is stopped.

# Other command line parameters

### `--outdir`

The output directory where the results will be published.

### `-w/--work-dir`

The temporary directory where intermediate data will be written.

### `-name`

Name for the pipeline run. If not specified, Nextflow will automatically generate a random mnemonic.

### `-resume`

Specify this when restarting a pipeline. Nextflow will used cached results from any pipeline steps where the inputs are the same, continuing from where it got to previously.

You can also supply a run name to resume a specific run: `-resume [run-name]`. Use the `nextflow log` command to show previous run names.

**NB:** Single hyphen (core Nextflow option)

### `--max_memory`

Use to set a top-limit for the default memory requirement for each process.
Should be a string in the format integer-unit. eg. `--max_memory '8.GB'`

### `--max_time`

Use to set a top-limit for the default time requirement for each process.
Should be a string in the format integer-unit. eg. `--max_time '2.h'`

### `--max_cpus`

Use to set a top-limit for the default CPU requirement for each process.
Should be a string in the format integer-unit. eg. `--max_cpus 1`
