#!/usr/bin/env python3
# 2021.05.04
# Wu Huang<whuang@rbge.org.uk>

import sys
import os
import argparse
from Bio import SeqIO
from Bio.Seq import Seq

## function
def open_seq(seqfile):
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

## files
parser = argparse.ArgumentParser(description='\
        output seq of the inds from the same species/group\
        required arguments:\
        [-f | -n | -sp | -o]')
parser.add_argument('-f','--seqfile', help='sequence file. Format - fasta, phylip, nexus')
parser.add_argument('-n','--name', help='seq ID to the species name')
parser.add_argument('-sp','--sel_spps', help='selected multiple-sampled species whose nucleotide diversity to be presented in the result')
parser.add_argument('-o','--output', help='prefix of output sequence files')
args = parser.parse_args()

#main
name = {}
for i in open(args.name):
	i = i.strip().split()
	name[i[0]] =i[1]

selected_spps = {}
for i in open(args.sel_spps):
	i = i.strip().split()
	selected_spps[i[0]] = {}

seq = open_seq(args.seqfile)
for acc in seq:
	if acc.id in name:
		if name[acc.id] in selected_spps.keys():
			selected_spps[name[acc.id]][acc.id] = acc.seq

for spps in selected_spps:
	outname = args.output+'_'+spps
	seq_spps_out = open(outname + '.fasta','w')
	for sample in selected_spps[spps]:
		seq_spps_out.write('>{0}\n{1}\n'.format(sample, selected_spps[spps][sample]))
	seq_spps_out.close()
	cmd = 'Rscript /mnt/shared/scratch/whuang/02_phd_project/00_src/calculate_pi.R '+ outname + '.fasta ' + outname + '.div'
	os.system(cmd)
