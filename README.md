# NucBarcoder [SSSNPs Species_specific_alleles_analysis]

Current version: 1.0 (March 2022)

[![DOI](https://zenodo.org/badge/6513/mossmatters/HybPiper.svg)](https://zenodo.org/badge/latestdoi/6513/mossmatters/HybPiper)

--
[Read our article in Applications in Plant Sciences (Open Access)](http://www.bioone.org/doi/full/10.3732/apps.1600016)

by Wu Huang, Royal Botanic Garden Edinburgh

![](examples/hybpiper_logo.png)



## Purpose

SSSNPs


---
## Dependencies
* Python 3+ 
* R

*Required for BWA version of the pipeline and for the intron and depth calculation scripts*:

*
* [samtools 1.2 or later](https://github.com/samtools/samtools) (Read/Write BAM files to save space).

**NOTE:** 

----

## Pipeline Input

Full instructions on running the pipeline, including the requred formats of the files, a step-by-step tutorial using a small test dataset, is available on our wiki:
link


### VCF files

You will also need to construct a "target" file of gene regions. The target file should contain one gene region per sequence, with exons "concatenated" into a contiguous sequence. For more information on constructing the target file, see the wiki, or view the example file in: `test_dataset/test_targets.fasta`

There can be more than one "source sequence" for each gene in the target file. This can be useful if the target enrichment baits were designed from multiple sources-- for example a transcriptome in the focal taxon and a distantly related reference genome.

### fasta files

----

## Pipeline Output


-----
## Changelog

---

## Citation

