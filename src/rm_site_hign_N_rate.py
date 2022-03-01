#!/usr/bin/env python3
# 2021.10.11
# Wu Huang<whuang@rbge.org.uk>

import sys
import re

f = open(sys.argv[1])
out_file = open(sys.argv[2],'w')

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

seq = fasta(f)
length = len(list(seq.values())[0])
seq_num = len(seq)
pos_sel = []
for i in range(length):
	pos = ''
	for a in seq.values():
		pos += a[i]
	if len(re.findall('[nN-]', pos)) > seq_num*0.4:
		continue
	else:
		pos_sel.append(i)

sub_fasta = dict.fromkeys(seq.keys(),'')
for SNP in pos_sel:
	for sample in seq:
		sub_fasta[sample] += seq[sample][SNP]

for i in sub_fasta:
	out_file.write('{0}\n{1}\n'.format(i,sub_fasta[i]))

f.close
out_file.close
