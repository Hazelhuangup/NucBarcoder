#!/usr/bin/env python3
# 2020.07.15
# Wu Huang<whuang@rbge.org.uk>

import sys
import itertools
import copy

f1 = open(sys.argv[1]) #distance matrix file
f2 = open(sys.argv[2]) # species names correspond to sample names
f3 = open(sys.argv[3],'w') # output file for intra/inter-specific distance
f4 = open(sys.argv[4]) # selected_species

selected_species = []
for i in f4:
	i = i.strip()
	selected_species.append(i)

sample_name_list = []
dist_mtx = {}
for i in itertools.islice(f1, 1, None):
	i = i.strip().split()
	sample_name_list.append(i[0])
	dist_mtx[i[0]] = i[1:]

species_samples = {}
name_dict = {}
for i in f2:
	i = i.strip().split()
	name_dict[i[0]] = i[1]
	if i[1] in selected_species:
		if i[1] not in species_samples:
			species_samples[i[1]] = [i[0]]
		else:
			species_samples[i[1]] .append(i[0])

f3.write('species_name\tmax_intra_dist\tmin_inter_dist\tA<B?\n')
for spp in species_samples:
	if len(species_samples[spp])>1:
		dist_A,dist_B = [],[]
		rest_individual_list = copy.deepcopy(sample_name_list)
		rest_individual_list = list(set(rest_individual_list) - set(species_samples[spp]))
		for pair_A in itertools.combinations(species_samples[spp],2):
			if pair_A[0] not in sample_name_list or pair_A[1] not in sample_name_list:
				dist = ''
			else:
				dist = float(dist_mtx[pair_A[0]][sample_name_list.index(pair_A[1])])
			dist_A.append(dist)
		for pair_B in itertools.product(species_samples[spp],rest_individual_list):
			if pair_B[0] not in sample_name_list or pair_B[1] not in sample_name_list:
				dist = 1
			else:
				dist = float(dist_mtx[pair_B[0]][sample_name_list.index(pair_B[1])])
			dist_B.append(dist)
		dist_A = list(filter(None,dist_A))
		if dist_A == []:
			f3.write('{0}\t{1}\t{2}\tN\n'.format(spp,dist_A,min(dist_B)))
		else:
			if max(dist_A) < min(dist_B):
				f3.write('{0}\t{1}\t{2}\tY\n'.format(spp,max(dist_A),min(dist_B)))
			else:
				f3.write('{0}\t{1}\t{2}\tN\n'.format(spp,max(dist_A),min(dist_B)))

f1.close
f2.close
f3.close
f4.close
