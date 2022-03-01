#!/usr/bin/env python3
# 2021.10.08
# Wu Huang<whuang@rbge.org.uk>

import sys
import random
import gzip

vcf_file = gzip.open(sys.argv[1],'rt')
fasta_file = open(sys.argv[2])

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

chr_pos = []
genome = {}
for i in vcf_file:
	if i.startswith('#'):
		continue
	else:
		i = i.split()
		chr_pos.append([i[0],i[1]])
		if i[0] not in genome:
			genome[i[0]] = ['']*100000000
		else:
			continue

repeat = int(sys.argv[3])
randomlist = []  ## a list of the fasta position for randomly picked SNPs
n = 0
while len(randomlist) < repeat:
	n += 1
	if n > repeat * 2:
		print("the sample size is too small or too dense to allow efficient random down-sampling, please re-run the program with larger sample or limit the sub-sample number, sub-len:", repeat)
		break
	random_pos = random.sample(range(0, length), 1) ## return a list of 1 element every iteration
	Chr = chr_pos[random_pos[0]][0]
	Pos = int(chr_pos[random_pos[0]][1])
	if genome[Chr][Pos] == '':
		start, end = Pos-25000, Pos+25000
		genome[Chr][start:end] = '0'* (end-start+1)
		randomlist += random_pos
	else:
		continue

sub_fasta = dict.fromkeys(seq.keys(),'')
for SNP in randomlist:
	for sample in seq:
		sub_fasta[sample] += seq[sample][SNP]

out_file = open(sys.argv[4],'w')
for i in sub_fasta:
	out_file.write('{0}\n{1}\n'.format(i,sub_fasta[i]))

vcf_file.close
fasta_file.close
out_file.close
