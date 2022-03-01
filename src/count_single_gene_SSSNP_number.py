#!/usr/bin/env python3
# 2022.02.16
# Wu Huang<whuang@rbge.org.uk>

from itertools import islice
import sys
import argparse

## files
parser = argparse.ArgumentParser(description='\
        required arguments:\
        [-p | -s | -o]')
parser.add_argument('-p','--position', help='the length of each sinngle gene/ partition file')
parser.add_argument('-s','--sssnps', help='a list of sssnps output')
parser.add_argument('-o','--output',help='prefix of output files, can include the path to the directory for the output files')
args = parser.parse_args()

## main
n = 1
pos = {}
for i in open(args.position):
	i = i.strip().split()
	pos[i[0]] = [n,n+int(i[2])-1]
	n = n+int(i[2])

out_file = open(args.output,'w')
mid_file = open(args.sssnps + '.pos', 'w')
sssnp_in_gene = dict.fromkeys(pos,0) ## {gene1:3, gene2:25, ...}
for i in islice(open(args.sssnps), 1, None):
	i = i.strip().split()
	for p in pos:
		if pos[p][0] <= int(i[2]) < pos[p][1]:
			mid_file.write('{0}\t{1}\t{2}\t{3}\n'.format(i[0],p,i[2],i[3]))
			if i[3] == 'ssa':
				sssnp_in_gene[p] += 1
			else:
				continue
		else:
			continue
for i in sssnp_in_gene:
	out_file.write('{0}\t{1}\n'.format(i, sssnp_in_gene[i]))

out_file.close()
mid_file.close()
