epa-ng -m LG+F+I+G4 -t Reference_align.fasta.contree -s Reference_align.fasta --redo -q MAGs_align.fasta -T 8

gappa examine graft --jplace-path epa_result.jplace --fully-resolve --out-dir . --file-prefix ENSEMBLE_18S_ --threads 8 --log-file gappa.log