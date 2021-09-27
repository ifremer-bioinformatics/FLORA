# **FLORA: workFLOw for Rnaseq analyses of Amocyst project.**.

[![FLORA version](https://img.shields.io/badge/FLORA%20version-beta-red?labelColor=000000)](https://gitlab.ifremer.fr/cn7ab95/FLORA.git)
[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A520.10.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![Developer](https://img.shields.io/badge/Developer-Cyril%20NOEL-yellow?labelColor=000000)](https://github.com/cnoel-sebimer)

## Introduction

FLORA is a FAIR scalable workflow allowing the analysis of RNAseq data of the AMOCYST project using state-of-the-art transcriptomics tools and statistical methods to conduct reproducible analyses using Nextflow. FLORA starts processing by correct RNAseq raw reads using [Rcorrector](https://gigascience.biomedcentral.com/articles/10.1186/s13742-015-0089-y). Then uncorrectable reads are removed using a Python script. rRNA contamination are also removed using [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml) and the [SILVA database](https://www.arb-silva.de/) before a quality filtering process of the reads using [Trim Galore](https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/). Finally, the transcriptome assembly is performed using [Trinity](https://github.com/trinityrnaseq/trinityrnaseq) 

The FLORA workflow is built using [Nextflow](https://www.nextflow.io), a workflow tool to run tasks across multiple compute infrastructures in a very portable manner. It automates the mapping of an individual metagenomic sample on a concatenated reference. It is functional on DATARMOR (Ifremer computing cluster) and uses local dependencies.

## Quick Start

i. Download the pipeline

```bash
git clone https://gitlab.ifremer.fr/cn7ab95/FLORA.git
```

iii. Run the workflow

Standard launch:
```bash
nextflow run main.nf
```

Custom launch on our supercomputer DATARMOR:
```bash
qsub run-main.nf
```

See [usage docs](docs/usage.md) for a complete description of all of the options available when running the pipeline.

## Documentation

This workflow comes with documentation about the pipeline, found in the `docs/` directory:

1. [Introduction](docs/usage.md#introduction)
2. [Pipeline installation](docs/usage.md#install-the-pipeline)
3. [Running the pipeline](docs/usage.md#running-the-pipeline)
4. [Output](docs/output.md)
5. [Troubleshooting](docs/troubleshooting.md)

## Requirements

To use this workflow, it is necessary to:
- complete the parameters defined in the[config file](conf/base.config) 
- to have a SILVA database (SSU + LSU) indexed with Bowtie2
- to create a file allowing to identify the condition and the replicate of each sample like the following example:
```bash
cond_A	cond_A_rep1	reads_A_rep1_R1.fq	reads_A_rep1_R2.fq
cond_A	cond_A_rep2	reads_A_rep2_R1.fq	reads_A_rep2_R2.fq
cond_B	cond_B_rep1	reads_B_rep1_R1.fq	reads_B_rep1_R2.fq
cond_B	cond_B_rep2	reads_B_rep2_R1.fq	reads_B_rep2_R2.fq
```

## Credits

FLORA is written by Cyril NOEL, bioinformatics engineer at [SeBiMER](https://ifremer-bioinformatics.github.io/), the Bioinformatics Core Facility of [IFREMER](https://wwz.ifremer.fr/en/).

## Support

For further information or help, don't hesitate to get in touch with the developper: 

![email](assets/cnoel-email.png)
