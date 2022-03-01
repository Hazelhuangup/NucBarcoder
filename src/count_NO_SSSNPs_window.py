#!/usr/bin/env python3
# 2022.02.07
# Wu Huang<whuang@rbge.org.uk>

import sys
from itertools import islice

sssnps = sys.stdin
sssnps_win = open(sys.argv[1],'w')

win = int(sys.argv[2])
count = {}
for i in islice(sssnps, 1, None):
	i = i.strip().split()
	if i[1] not in count:
		count[i[1]] = [0 for i in range(100)]
		if i[3] == 'ssa':
			pos = int(i[2])//win
			count[i[1]][pos] += 1
		else:
			continue
	else:
		if i[3] == 'ssa':
			pos = int(i[2])//win
			count[i[1]][pos] += 1
		else:
			continue

for c in count:
	for m in range(len(count[c])):
		sssnps_win.write('{0}\t{1} M\t{2}\n'.format(c,m,count[c][m]))

sssnps.close()
sssnps_win.close()
