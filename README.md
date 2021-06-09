# PhyloEuk

Phylogenomics for Eukaryotes

<span style="color:red"> Warnings: </span>
This script is an ongoing work and for now only "works" for Stramenopiles

## Goal

Heavily inspired by [GTDB-TK](https://github.com/Ecogenomics/GTDBTk) and [Busco](https://busco.ezlab.org/), the goal of this software is to determine the taxonomy of your strain(s) of interest based on the presence of single copy genes.

## Pre-requesites

### Busco

This script uses the ouptput of busco (v5) ran with the eukaryotic lineage (eukaryota_odb10.2019-11-20), hence you'll need to run the following command to use the `phyloEuk.pl` script.

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

Install and activate the conda environment

Replace `mamba` by `conda` if it's not installed

`mamba create -n phyloeuk -c bioconda -c conda-forge trimal mamba mafft busco=5`
`conda activate phyloeuk`

Download the genome and proteome of your taxa of interest using the new [datasets](https://www.ncbi.nlm.nih.gov/datasets/docs/) tool of the NCBI

`./datasets download genome --exclude-gff3 --exclude-rna taxon "stramenopiles"`

If the proteome is not avalaible, it's best to generate it using your preferred tools such as [MetaEuk](https://github.com/soedinglab/metaeuk), [GeneMark-ES](http://exon.gatech.edu/GeneMark/), [Augustus](https://github.com/Gaius-Augustus/Augustus)

Then, run Busco of all proteome or genomes

``` bash
source activate phyloeuk
for i in *faa
   do busco -m prot -c 28 -i $i -o ${i%.faa}_busco -l eukaryota
done
```

``` bash
for i in *_busco/run_eukaryota_odb10/full_table.tsv
   do cat $i >> full_table_all.tsv
done
```

The number of single copy genes was calculated to remove the ones that were present in less than 80 reference proteomes

`awk '$2 ~ /Complete/' full_table_all.tsv | cut -f1 | sort | uniq -c | perl -pe 's/ +/\t/g' | awk '$2 > 80' | cut -f3 > listGenes.tsv`

Then all the single copy genes were put in the same folders and concatenated

``` bash
while read -r line; do mkdir BuscoGenes/$line\.faa; done < listGenes.tsv

for i in *busco
   do for j in $i/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/*faa
      do cp $j BuscoGenes/${j#$i/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/}/${i%_busco}\_${j#$i/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/}\
   done
done

rm toRenameFasta.sh

for i in *.faa
   do for j in $i/*
      do echo perl -pe \'"s/>/>${j#$i/}/g"\' $j \> ${j%.faa}_rename.faa
   done
done >> toRenameFasta.sh

bash toRenameFasta.sh

mkdir concatGenes

for i in *faa
   do cat $i/*rename.faa > concatGenes/$i
done
```
Then align each single copy genes

``` bash
cd concatGenes
for i in *faa
   do mafft --auto --thread 30 $i > ${i%.faa}\_align.faa
done
```

```bash
for i in *align.faa
   do trimal -in $i -out ${i%.faa}_trim.faa -gt 0.5 -cons 25
done
```

`trimal -in AllConcat.faa -out AllConcatTrim.faa -gt 0.5 -cons 25`

