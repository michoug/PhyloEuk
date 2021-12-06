#!/usr/bin/env bash

# mamba create -n phyloeuk -c bioconda -c conda-forge trimal mamba mafft busco=5 fasttree perl-bioperl perl-file-slurp bioawk
conda activate phyloeuk

cd MAGs

ls *faa > ../listMAGs.txt

for i in *faa
   do busco -m prot -c 8 -i $i -o ${i%.faa}_busco -l eukaryota
done

mkdir BuscoGenes

while read -r line; do mkdir BuscoGenes/$line\.faa; done < ../listGenes.tsv

for i in *busco
   do for j in $i/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/*faa
      do cp $j BuscoGenes/${j#$i/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/}/${i%_busco}\_${j#$i/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/} 2>&1 >/dev/null
   done
done

cd BuscoGenes

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

cd concatGenes
mkdir align

for i in *faa
do
   mafft --quiet --add $i --keeplength ../../../reference/BuscoGenes/concatGenes/align/${i%.faa}_align_trim.faa > align/${i%.faa}_align_all.faa
done

for i in $(find align/*align_all.faa -type f -empty)
do
   cp ../../../reference/BuscoGenes/concatGenes/${i%_all.faa}_trim.faa $i
done

cd ../../..

perl concatenateFastaReferenceMAGs.pl MAGs/BuscoGenes/concatGenes/align listReference.txt listMAGs.txt

