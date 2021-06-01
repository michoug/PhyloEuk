# PhyloEuk

Phylogenomics for Eukaryotes

<span style="color:red"> Warnings: </span>
This script is an ongoing work and for now only "works" for Stramenopiles

## Goal

Heavily inspired by [GTDB-TK](https://github.com/Ecogenomics/GTDBTk) and [Busco](https://busco.ezlab.org/), the goal of this software is to determine the taxonomy of your strain(s) of interest based on the presence of single copy genes.

## Pre-requesites

### Busco

This script uses the ouptput of busco (v5) run with the eukaryotic lineage (eukaryota_odb10.2019-11-20), hence you'll need to run the following command to use the `phyloEuk.pl` script.

First install Busco :

`mamba create -n Busco -c conda-forge -c bioconda busco=5.0.0`

then run as such if you have already obtain the proteins from your strain(s) of interest

``` bash
source activate Busco
for i in *faa
   do busco -m prot -c 28 -i $i -o ${i%.faa}_busco -l eukaryota
done
```

### Methods

