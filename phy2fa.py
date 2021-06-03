import sys
from itertools import islice

f1 = open(sys.argv[1])
f2 = open(sys.argv[2],'w')

for i in islice(f1, 1, None):
	i = i.strip().split()
	f2.write('>{0}\n{1}\n'.format(i[0],i[1]))

f1.close()
f2.close()
