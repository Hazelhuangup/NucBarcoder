#!/usr/bin/env python3
# 2021.08.13
# Wu Huang<whuang@rbge.org.uk>

import sys

f1 = open(sys.argv[1]) ## *monophy.txt
f2 = open(sys.argv[2]) ## all_species.txt

all_spp = []
for i in f2:
	i = i.strip()
	all_spp.append(i)

mono = {}
for i in f1:
	i = i.strip().split()
	if i[0] in all_spp:
		if i[1] == "Yes":
			print(i[0],i[1])

f1.close
f2.close
