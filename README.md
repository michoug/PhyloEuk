# PhyloEuk: Phylogenomics for Eukaryotes

<span style="color:red"> Warnings: </span>
This pipeline is an ongoing work and for now only "works" for Ocrophytes, but there is no real reason why it may not work for others taxa with few modifications in the script.

## Goal

Heavily inspired by [GTDB-TK](https://github.com/Ecogenomics/GTDBTk) and [Busco](https://busco.ezlab.org/), the goal of this software is to determine the taxonomy of your eukaryotic strain(s) of interest based on the presence of single copy genes.

## To Do

Add options to broaden the use case.

## Dependencies

* [conda](https://conda.io/) 
* [mafft](https://mafft.cbrc.jp/alignment/software/)
* [trimal](http://trimal.cgenomics.org/)
* [Busco](https://busco.ezlab.org/)
* [bioawk](https://github.com/lh3/bioawk)
* [iqtree2](http://www.iqtree.org/)
* [epa-ng](https://github.com/Pbdas/epa-ng)
* [perl](https://www.perl.org/)
* [BioPerl](https://bioperl.org/)

See `dependencies.bib` for citation of these dependencies.

## Installation

``` bash
conda install -c bioconda -c conda-forge mamba
mamba create -n phyloeuk -c bioconda -c conda-forge trimal mamba mafft busco=5 iqtree perl-bioperl perl-file-slurp bioawk epa-ng
```

## Run

### Caveats

These scripts are hardcoded to select single copy genes that are present in at least 30 reference genomes.
At the moment, you cannot restart the processes, but opening the scripts and copy/paste the different commands will work.
The more reference genomes, the longer of course.
The last steps, aka the tree generation, is the most time consuming part.

### Pipeline

`git clone https://github.com/michoug/PhyloEuk.git`

Put all references and MAGs proteomes (faa files) in folders called `reference` and `MAGs`, respectively.

Run the `runReference.sh` script.
Run the `runMAGs.sh` script.
