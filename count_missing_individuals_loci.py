#!/usr/local/bin/python
# 2019.05.09
# Wu Huang<whuang@rbge.org.uk>

import sys
import gzip

vcf_file = gzip.open(sys.argv[1])
out_file = open(sys.argv[2],'w')

for i in vcf_file:
	if not i.startswith('#'):
		i = i.strip().split()
		count = 0
		for sample in i[9:]:
			sample = sample.split(':')
			if int(sample[2]) > 0:
				count += 1
			else:
				continue
		out_file.write('{0}\t{1}\t{2}\n'.format(i[0],i[1],count))

vcf_file.close()
out_file.close()
