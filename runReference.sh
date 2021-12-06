#!/usr/bin/env bash

# mamba create -n phyloeuk -c bioconda -c conda-forge trimal mamba mafft busco=5 fasttree perl-bioperl perl-file-slurp bioawk iqtree
source activate phyloeuk

cd reference

ls *faa > ../listReference.txt

for i in *faa
   do busco -m prot -c 8 -i $i -o ${i%.faa}_busco -l eukaryota
done

rm full_table_all.tsv

for i in *_busco/run_eukaryota_odb10/full_table.tsv
   do cat $i >> full_table_all.tsv
done

awk '$2 ~ /Complete/' full_table_all.tsv | cut -f1 | sort | uniq -c | perl -pe 's/ +/\t/g' | awk '$2 > 30' | cut -f3 > ../listGenes.tsv

mkdir BuscoGenes

while read -r line; do mkdir BuscoGenes/$line\.faa; done < ../listGenes.tsv

for i in *busco
   do for j in $i/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/*faa
      do cp $j BuscoGenes/${j#$i/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/}/${i%_busco}\_${j#$i/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/} 2>/dev/null
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
   do mafft --auto --thread 8 $i > align/${i%.faa}\_align.faa --quiet
done

for i in align/*align.faa
   do trimal -in $i -out ${i%.faa}_trim.faa -gt 0.5 -cons 25
done
 
cd ../../..

perl concatenateFastaReference.pl reference/BuscoGenes/concatGenes/align listReference.txt

## Check to see if all the sequences have the same size

bioawk -c fastx '{ print $name, length($seq) }' < Reference_align.fasta | cut -f2 | sort | uniq

## Make phylogenetic tree

iqtree2 -T AUTO --alrt 1000 -B 1000 -s Reference_align.fasta -m TEST