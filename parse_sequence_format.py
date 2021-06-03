from Bio import SeqIO
from Bio.Seq import Seq
import sys

def open_file(seqfile):
	if seqfile.endswith(('fa', 'fasta')):
		seq = SeqIO.parse(seqfile, "fasta")
	elif seqfile.endswith(('phy', 'phylip')):
		seq = SeqIO.parse(seqfile, "phylip")
	elif seqfile.endswith(('nex', 'nexus')):
		seq = SeqIO.parse(seqfile, 'nexus')
	else:
		seq = None
		print('not supported file format')
	return seq
