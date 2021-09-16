# **FLORA: workFLOw for Rnaseq analyses of Amocyst project.**.

[![FLORA version](https://img.shields.io/badge/FLORA%20version-1.0.0-red?labelColor=000000)](https://gitlab.ifremer.fr/cn7ab95/FLORA.git)
[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A520.10.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![Developer](https://img.shields.io/badge/Developer-Cyril%20NOEL-yellow?labelColor=000000)](https://github.com/cnoel-sebimer)

## Introduction

FLORA is a FAIR scalable workflow allowing the analysis of RNAseq data of the AMOCYST project using state-of-the-art transcriptomics tools and statistical methods to conduct reproducible analyses using Nextflow. FLORA starts processing by correct RNAseq raw reads using [Rcorrector](). Then ...

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

Upcoming section ...

## Credits

FLORA is written by Cyril NOEL, bioinformatics engineer at [SeBiMER](https://ifremer-bioinformatics.github.io/), the Bioinformatics Core Facility of [IFREMER](https://wwz.ifremer.fr/en/).

## Support

For further information or help, don't hesitate to get in touch with the developper: 

![email](assets/cnoel-email.png)
