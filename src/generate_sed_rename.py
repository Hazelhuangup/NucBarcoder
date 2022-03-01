import sys

f2 = open(sys.argv[2],'w')

for i in open(sys.argv[1]):
	i = i.strip().split()
	f2.write('sed -i \'s/{0}/{1}/g\' astral_rooted.tre\n'.format(i[1],i[0]))

f2.close()
