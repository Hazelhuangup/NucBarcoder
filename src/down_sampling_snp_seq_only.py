#!/usr/bin/env python3
# 2021.10.11
# Wu Huang<whuang@rbge.org.uk>

import sys
import random

fasta_file = open(sys.argv[1])

def fasta(file):
	dic, k, v = {}, '', []
	for i in file:
		i = i.strip()
		if i.startswith('>'):
			dic[k] = "".join(v)
			k = i
			v = []
		else:
			v.append(i)
	dic[k] = "".join(v)
	dic.pop('')
	return dic

seq = fasta(fasta_file)
length = len(list(seq.values())[0])

sub_len = int(sys.argv[2])
randomlist = random.sample(range(0, length), sub_len) ## return a list of sub_len elements

sub_fasta = dict.fromkeys(seq.keys(),'')
for SNP in randomlist:
	for sample in seq:
		sub_fasta[sample] += seq[sample][SNP]

out_file = open(sys.argv[3],'w')
for i in sub_fasta:
	out_file.write('{0}\n{1}\n'.format(i,sub_fasta[i]))

fasta_file.close
out_file.close
