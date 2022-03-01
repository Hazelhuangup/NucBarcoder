import sys

f1 = open(sys.argv[1]) ##vcf file
f2 = open(sys.argv[2])  ## name file
f3 = open(sys.argv[3],'w')  ## renamed vcf file

name_dict = {}
for i in f2:
	i = i.strip().split()
	name_dict[i[0]] = i[2]

for i in f1:
	if i.startswith('#CHROM'):
		i = i.strip().split()
		for a in i:
			if a in name_dict:
				f3.write('{0}\t'.format(name_dict[a]))
			else:
				f3.write('{0}\t'.format(a))
		f3.write('\n'.format(a))
	else:
		f3.write('{0}'.format(i))

f1.close()
f2.close()
f3.close()
