# FLORA: Quickstart guide

## Input file requirements

### Raw reads directory

A directory containing all R1 and R2 of all individual transcriptome samples.

## Process parameters

The `base.config` file control each process and it's parameters, **This file contains the parameters adapted to the analysis of the data of the AMOCYST project**.

In this section, we will describe the most important parameters for each process.

```projectName```: the name of your project, **without space, tabulation or accented characters**.

```outdir```: the path to save your results.

```rawdata```: the path to the RNAseq raw data in FASTQ format for each sample.
