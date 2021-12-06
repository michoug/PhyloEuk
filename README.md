# PhyloEuk

Phylogenomics for Eukaryotes

<span style="color:red"> Warnings: </span>
This script is an ongoing work and for now only "works" for Stramenopiles

## Goal

Heavily inspired by [GTDB-TK](https://github.com/Ecogenomics/GTDBTk) and [Busco](https://busco.ezlab.org/), the goal of this software is to determine the taxonomy of your strain(s) of interest based on the presence of single copy genes.

## Dependencies

* conda
* mafft
* trimal
* busco
* fasttree
* bioawk
* iqtree
* epa-ng

## Installation

conda install -c bioconda -c conda-forge mamba
mamba create -n phyloeuk -c bioconda -c conda-forge trimal mamba mafft busco=5 fasttree perl-bioperl perl-file-slurp bioawk epa-ng

## Run

Put all references genomes and MAGs genomes in folder called `reference` and MAGs, respectively.

Run the `runReference.sh` script
