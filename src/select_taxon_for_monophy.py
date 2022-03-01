#!/usr/bin/env python3
# 2021.08.17
# Wu Huang<whuang@rbge.org.uk>

import sys

f1 = open(sys.argv[1]) ##*dist_available_sampls.tmp
f2 = open(sys.argv[2]) ## ID_to_scientific_name.txt
f3 = open(sys.argv[3],'w')

di = {}
for i in f2:
	i = i.strip().split()
	di[i[0]] = i[1]

for i in f1:
	i = i.strip()
	f3.write('{0}\t{1}\n'.format(i,di[i]))

f1.close
f2.close
f3.close
