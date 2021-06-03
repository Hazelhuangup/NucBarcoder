#!/usr/bin/env python3
# 2021.05.04
# Wu Huang<whuang@rbge.org.uk>

from __future__ import division
from itertools import islice
import sys
import copy
import argparse
from Bio import SeqIO
from Bio.Seq import Seq

## function
def open_file(seqfile):
	if seqfile.endswith(('fa', 'fasta')):
		seq = SeqIO.parse(seqfile, "fasta")
	elif seqfile.endswith(('phy', 'phylip')):
		seq = SeqIO.parse(seqfile, "phylip")
	elif seqfile.endswith(('nex', 'nexus')):
		seq = SeqIO.parse(seqfile, 'nexus')
	else:
		seq = None
		print('not supported file format')
	return seq

# Dictionary of IUPAC ambiguities for nucleotides
ambiguities = {'R':"AG", 'Y':"CT", 'W':"AT",
               'S':"CG", 'M':"AC", 'K':"GT",
               'V':"GAC",'H':"ATC",'B':"GCT",
               'D':"GAT"}

def allele_freq(A_alleles):
	freq = {'A':0,'T':0,'C':0,'G':0}
	for ind_allele in A_alleles:
		if ind_allele in ['n','N','-','?','*']:
			continue
		elif ind_allele not in ['A','T','C','G']:
			for nuc in ambiguities[ind_allele]:
				freq[nuc] += 1
		else:
			freq[ind_allele] += 2
	return [list(freq.values()),sum(freq.values())]

## files
parser = argparse.ArgumentParser(description='\
        extract ancestral informative SNPs from aligned sequence files for target capture data\
        adapt to include hetero info in the form of IUPAC ambiguity code\
        required arguments:\
        [-f | -sm | -n | -sp | -o]')
parser.add_argument('-f','--seqfile', help='one concatenated sequence file. Format - fasta, phylip, nexus')
parser.add_argument('-n','--names', help='sample ID to species names corresponding file. Format - ID scientific_name')
parser.add_argument('-sp','--selectedspps', help='a list of spps names that are multiple sampled (scientific_name)')
parser.add_argument('-sm','--selectedsample', help='a list of sample names that belongs to target genus (ID)')
parser.add_argument('-o','--output',help='prefix of output files, can include the path to the directory for the output files')
args = parser.parse_args()

## main
name_dict, sample_name_list = {},[]
for i in open(args.names):
	i = i.strip().split()
	name_dict[i[0]] = i[1]  ## sample_name spps_name
	sample_name_list.append(i[0])

samples_in_selected_species = {}

for i in open(args.selectedspps):
	i = i.strip().split()
	samples_in_selected_species[i[0]] = []

selected_samples = []
for i in open(args.selectedsample):
	i = i.strip().split()
	selected_samples.append(i[0])

for i in name_dict:
	if name_dict[i] in samples_in_selected_species:
		samples_in_selected_species[name_dict[i]].append(i)

AIL_out_file = open(args.output+'.AIL.list','w')
AIL_out_file.write('Spp\tFlag\tPos\tType\tSpp_A_Allele\tRest_ind_allele\tA_max_AF\tAF_A_list\tAF_ALL_list\trest_selected_species_AF_list\n')
COUNT = open(args.output+'.count','w')
COUNT.write('Spp\tValid_Basepairs\n')

seq = open_file(args.seqfile)
selected_seq = {}
for acc in seq:
	if acc.id in selected_samples:
		selected_seq[acc.id] = acc.seq.upper()
for A in samples_in_selected_species:
	count_bp = 0
	rest_individual_list, rest_selected_species_name, rest_species_allele_dict= sample_name_list[:], copy.deepcopy(samples_in_selected_species),{}
	del rest_selected_species_name[A]
	for sample in samples_in_selected_species[A]:
		rest_individual_list.remove(sample)
	for pos in range(len(acc.seq)):   ##the coordination is 0 based
		A_alleles = []
		rest_alleles = []
		for sample in samples_in_selected_species[A]:
			if sample in selected_seq: ## some genes are absent in some samples
				A_alleles.append(selected_seq[sample][pos])
		for sample in rest_individual_list:
			if sample in selected_seq:
				rest_alleles.append(selected_seq[sample][pos])
		freq_A = allele_freq(A_alleles)
		freq_ALL = allele_freq(rest_alleles)
		rest_selected_species_AF_list = [[]for a in range(4)]
		for B in rest_selected_species_name:
			B_alleles = []
			for sample in rest_selected_species_name[B]:
				if sample in selected_seq:
					B_alleles.append(selected_seq[sample][pos])
			rest_species_allele_dict[B] = B_alleles
			freq_B = allele_freq(B_alleles)
			if freq_B[1] != 0:
				for n in range(0,4):
					rest_selected_species_AF_list[n].append(freq_B[0][n]/freq_B[1])
			else:
				continue
		if freq_A[1] >= 4: # for this locus, species A must have at least 2 inds have data
			count_bp += 1
			if len(rest_selected_species_AF_list[0]) >= 2: ## for this locus, alleles in at least 2 other groups are not missing
				AF_A_list = []
				AF_ALL_list =[]
				for n in range(0,4):
					AF_A_list.append(freq_A[0][n]/freq_A[1])
					AF_ALL_list.append(freq_ALL[0][n]/freq_ALL[1])
				max_index=AF_A_list.index(max(AF_A_list))
# judge if alleles_frequency in species A is significantly different from all the rest species respetively and in all.
# only calculate when two parties have over 2 fold coverage (dismissed N)
# stage 1: If AF in this group is higher than a specific threshold (say 87.5%), progresses to stage 2 ->
				if max(AF_A_list) >= 0.875:
# stage 2: if AF in all the rest groups(aggregated) is lower than a threshold (10%), progress to stage 3 ->
					if AF_ALL_list[max_index] <= 0.1:
						print(pos)
						print(A,A_alleles)
						print(freq_A)
						print('ALL',rest_alleles,freq_ALL)
						print('B',rest_species_allele_dict,rest_selected_species_AF_list)
# stage 3: if AFs in any other groups (separated) are lower than a threshold (12.5%, at most one allele amongst 8 alleles of 4 individuals), take this locus as valid one with allele frequency difference
						if max(rest_selected_species_AF_list[max_index]) <= 0.125:
							if max(AF_A_list) == 1.0 and AF_ALL_list[max_index] == 0.0: # IF fixed, TAG the SNP with 'SSA'
								AIL_out_file.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}\n'.format(A,'.', pos,'ssa',freq_A[0], freq_ALL[0], round(max(AF_A_list),2), AF_A_list,AF_ALL_list, rest_selected_species_AF_list))
							else:
								AIL_out_file.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}\n'.format(A, '.', pos,'.', freq_A[0], freq_ALL[0], round(max(AF_A_list),2), AF_A_list,AF_ALL_list, rest_selected_species_AF_list))
						else:
							continue
					else:
						continue
	COUNT.write('{0}\t{1}\n'.format(A,count_bp))

AIL_out_file.close()
COUNT.close()
