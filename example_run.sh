#!/bin/bash

#SBATCH --partition=medium
#SBATCH --mail-user=whuang@rbge.org.uk
#SBATCH --mail-type=END,FAIL,TIME_LIMIT_90
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

echo "Starting job on $HOSTNAME"

catfasta2phyml.pl -c -f ./05_down_sampling/single_gene_alignments/*.fasta \
	> ./01_raw_data/Artocarpus.242genes.fasta \
	2>>./01_raw_data/Artocarpus.242genes.partition.txt
python ../00_src/extract_ancestral_informative_SNPs_hete.py \
	-f 01_raw_data/Artocarpus_supercontig.noparalogs.fasta \
	-n 01_raw_data/ID_to_scientific_name.txt \
	-sp 01_raw_data/selected_species.txt \
	-sm 01_raw_data/selected_samples.txt \
	-o 03_output/Artocarpus \
	> Artocarpus.midfile.txt  # 2h58mins
python ../00_src/extract_ancestral_informative_SNPs_hete.py \
	-f 01_raw_data/Artocarpus.242genes.fasta \
	-n 01_raw_data/ID_to_scientific_name.txt \
	-sp 01_raw_data/selected_species.txt \
	-sm 01_raw_data/selected_samples.txt \
	-o 03_output/Artocarpus_new \
	> Artocarpus_new.midfile.txt 

# basic statistical analysis and visualization of SSA
for i in `cat 01_raw_data/selected_species.txt`;do
	grep $i 03_output/Artocarpus.AIL.list |awk '$4=="ssa"'|wc -l >>  03_output/All.AIL.SSA.txt
	grep $i 03_output/Artocarpus.AIL.list |awk '$4=="."'|wc -l >>  03_output/All.AIL.freq_diff.txt
	done

# down-sampling and phylogeny
# selected Batocarpus_costaricensis_GW1463 ind as outgroup and together with 143 inga inds. Extract DNA sequence of 810 genes for them
give_me_mul_seq.py \
	-f 01_raw_data/Artocarpus_supercontig.noparalogs.fasta \
	-l 01_raw_data/ID_to_scientific_name_phy.txt \
	-o 04_phylogeny/Artocarpus_supercontig.noparalogs_140inds.fasta

# build phylogeny using iqtree2 based on the 140 inds sequence
iqtree2 \
	-s 04_phylogeny/Artocarpus_supercontig.noparalogs_140inds.fasta \
	--seqtype DNA \
	-B 1000 \
	-m HKY \
	--prefix 04_phylogeny/Artocarpus_supercontig.noparalogs_140inds \
	-T 64 \
	-o Batocarpus_costaricensis_GW1463  ##4h50min * 64 CPU
Rscript ../00_src/MonoPhy.r  04_phylogeny/Artocarpus_supercontig.noparalogs_140inds.treefile Batocarpus_costaricensis_GW1463 01_raw_data/ID_to_scientific_name_phy.txt 04_phylogeny/MonoPhy.txt
awk '$4>1{print $1"\t"$2"\t"$4}' 04_phylogeny/MonoPhy.txt > 04_phylogeny/MonoPhy_YN_result.txt

# distance matrix
Rscript ../00_src/ape_dna_dist.R ./01_raw_data/Artocarpus.242genes.fasta ./01_raw_data/Artocarpus.242genes.dist ## 
python ../00_src/calculate_intra_inter_specific_distance.py ./01_raw_data/Artocarpus.242genes.dist ./01_raw_data/ID_to_scientific_name.txt ./01_raw_data/Artocarpus.242genes.inter_intra.txt ./05_down_sampling/all_species.txt
awk '{print $4}' ./01_raw_data/Artocarpus.242genes.inter_intra.txt |grep 'Y' |wc -l >> Number_of_spps_intra_ls_inter_all.txt

# build quick tree using ape
give_me_mul_seq.py \
	-f ./01_raw_data/Artocarpus.242genes.fasta 
	-l ./01_raw_data/ID_to_scientific_name_phy.txt 
	-o ./01_raw_data/Artocarpus.242genes_139inds.fasta
snp-sites -o ./01_raw_data/Artocarpus.242genes_139inds-snp-sites.fasta ./01_raw_data/Artocarpus.242genes_139inds.fasta
awk '{print $2}' ./01_raw_data/ID_to_scientific_name_phy.txt|uniq > ./05_down_sampling/all_species.txt
Rscript ../00_src/ape_dna_dist.R ./01_raw_data/Artocarpus.242genes_139inds.fasta ./05_down_sampling/Artocarpus.242genes_139inds.dist
Rscript ../00_src/ape_dist_tree.R ./05_down_sampling/Artocarpus.242genes_139inds.dist ./05_down_sampling/Artocarpus.242genes_139inds.mono.tre
Rscript ../00_src/MonoPhy.r ./05_down_sampling/Artocarpus.242genes_139inds.mono.tre 87wilsonii ./01_raw_data/ID_to_scientific_name_phy.txt ./05_down_sampling/Artocarpus.242genes_139inds.mono.txt
python ../00_src/count_Yes_multiple_sampled_clades.py ./05_down_sampling/Artocarpus.242genes_139inds.mono.txt ./05_down_sampling/all_species.txt \
	|wc -l > ./05_down_sampling/Artocarpus.242genes_139inds.mono.count

# single_gene_diagnosability
cd 05_down_sampling/single_gene_alignments/
for i in `ls *.fasta`;do
	Rscript ../../../00_src/ape_dna_dist.R ./$i ./$i.dist
	Rscript ../../../00_src/ape_dist_tree.R $i.dist $i.mono.tre
done
# single gene (all spps) nucleotide diversity
for i in `ls 05_down_sampling/single_gene_alignments/*fasta`; do Rscript ../00_src/calculate_pi.R $i $i.nuc.div;done
grep -v "x" 05_down_sampling/single_gene_alignments/*.nuc.div > 06_nuc_div/single_gene_nuc_div.txt
rm 05_down_sampling/single_gene_alignments/*.nuc.div
cp ../00_src/recreate_partition_file.sh ./05_down_sampling/single_gene_alignments/
cd ./05_down_sampling/single_gene_alignments/
sh recreate_partition_file.sh
cd ../../
python ../00_src/count_single_gene_SSSNP_number.py -p 05_down_sampling/single_gene_alignments/gene_conc_partition.txt -s 03_output/Artocarpus.AIL.list -o 03_output/single_gene_SSSNP_number.txt

# extract ancestral informative SNPs on randomised labels
cut -f 1 01_raw_data/ID_to_scientific_name.txt > 00
cut -f 2 01_raw_data/ID_to_scientific_name.txt |shuf > 11
paste 00 11 > 01_raw_data/ID_shuffled.txt
rm 00 11
mkdir 03_output/randomise_label/
python ../00_src/extract_ancestral_informative_SNPs_hete.py \
	-f 01_raw_data/Artocarpus_supercontig.noparalogs.fasta \
	-n 01_raw_data/ID_shuffled.txt \
	-sp 01_raw_data/selected_species.txt \
	-sm 01_raw_data/selected_samples.txt \
	-o 03_output/randomise_label/Artocarpus \
	> Artocarpus_randomise_label.midfile.txt  # 16h8min30s
for i in `cat 01_raw_data/selected_species.txt`;do
	grep $i 03_output/randomise_label/Artocarpus.AIL.list |awk '$4=="ssa"'|wc -l >>  03_output/randomise_label/All.AIL.SSA.txt
	grep $i 03_output/randomise_label/Artocarpus.AIL.list |awk '$4=="."'|wc -l >>  03_output/randomise_label/All.AIL.freq_diff.txt
	done

# calculate nucleotide diversity
Rscript ../00_src/calculate_π.R 01_raw_data/Artocarpus.242genes_139inds.fasta 06_nuc_div/Artocarpus.242genes_139inds.nuc.div

# examine plastid content by blast whole sequence (not SNPs) to NCBI ncDatabase
mkdir 03_output/blast
blastn \
	-db /mnt/shared/scratch/whuang/database/refseq_plastid/plastid.genomic.fna \
	-query 01_raw_data/blast.fa \
	-out 03_output/blast/blast.fa.out \
	-num_threads 1 \
	-max_target_seqs 5 \
	-outfmt 6

echo "job finished"
