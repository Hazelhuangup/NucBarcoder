for i in `ls *fasta`;do seq_n50.pl $i |grep 'N50' >> each_gene_length.txt ;done
ls *fasta > gene_name.txt
paste gene_name.txt each_gene_length.txt > gene_conc_partition.txt
rm gene_name.txt each_gene_length.txt
