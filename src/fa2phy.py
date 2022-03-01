#!/home/whuang/scratch/apps/conda/bin/python
from Bio import SeqIO
import sys

f1 = open(sys.argv[1])
f2 = open(sys.argv[2],'w')

records = SeqIO.parse(f1, "fasta")
count = SeqIO.write(records, f2, "phylip")
print("Converted %i records" % count)
