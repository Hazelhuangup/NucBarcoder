from Bio import SeqIO
import sys

f1 = open(sys.argv[1])
f2 = open(sys.argv[2],'w')

records = SeqIO.parse(f1, "phylip")
count = SeqIO.write(records, f2, "fasta")
print("Converted %i records" % count)
