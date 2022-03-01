#!/usr/bin/env python3
# 2021.06.23
# Wu Huang<whuang@rbge.org.uk>

from itertools import islice
import sys

f1 = open(sys.argv[1])
f2 = open(sys.argv[2],'w')

for i in islice(f1, 1, None):
	i = i.strip().split()
	f2.write('>{0}\n{1}\n'.format(i[0],i[1]))

f1.close()
f2.close()
