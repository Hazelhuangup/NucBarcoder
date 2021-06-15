#!/usr/bin/env python3
# 2021.06.15
# Wu Huang<whuang@rbge.org.uk>

import sys
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

## files
parser = argparse.ArgumentParser(description='\
        extract a subset of fasta sequence given the names to be extracted from a list\
        required arguments:\
        [-f | -l| -o]')
parser.add_argument('-f','--seqfile', help='one concatenated sequence file. Format - fasta, phylip, nexus')
parser.add_argument('-l','--seqlist', help='a table devided file where the first column to be the names of the sequence to be extracted. Format - table devided txt')
parser.add_argument('-o','--output', help='output, in fasta format')
args = parser.parse_args()

seq = open_file(args.seqfile)
outfile = open(args.output,'w')

selected_seq = {}
for acc in seq:
	selected_seq[acc.id] = acc.seq.upper()

for i in open(args.seqlist):
	i = i.strip().split()
	if i[0] in selected_seq:
		outfile.write('>{0}\n{1}\n'.format(i[1],selected_seq[i[0]]))

outfile.close()
