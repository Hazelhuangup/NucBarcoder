#!/usr/bin/env python3
# 2021.05.04
# Wu Huang<whuang@rbge.org.uk>

import sys

# Dictionary of IUPAC ambiguities for nucleotides
ambiguities = {"AG":'R', "CT":'Y', "AT":'W',"GA":'R', "TC":'Y', "TA":'W', "AA":"A", "TT":"T", "??":"-", "NN":"N",
               "CG":'S', "AC":'M', "GT":'K',"GC":'S', "CA":'M', "TG":'K', "CC":"C", "GG":"G", "--":"-"}

f1 = open(sys.argv[1])
suffix = sys.argv[2]  ## directory for result fasta files

n = 0
dict = {}
for i in f1:
	if i.startswith('//'):
		i = i.strip().split('|')
		output = suffix+'/locus_'+i[1]+'.fasta'
		print(output)
		f2 = open(output,'w')
		for locus in dict:
			f2.write('>{0}\n{1}\n'.format(locus,dict[locus]))
		dict = {}
		f2.close()
	else:
		i = i.strip().split()
		if n == 0:
			n += 1
			i1 = i[1]
		else:
			n = 0
			seq = ''
			name = i[0][1:-2]
			i2 = i[1]
			for nuc in range(0,len(i1)):
				seq = seq+ambiguities[i1[nuc]+i2[nuc]]
			dict[name] = seq
