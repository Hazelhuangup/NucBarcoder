#!/usr/bin/env python3
# 2021.06.02
# Wu Huang<whuang@rbge.org.uk>

import sys
import argparse
from parse_sequence_format import open_file

## files
parser = argparse.ArgumentParser(description='\
        count the valid base pairs for each species\
        required arguments:\
        [-f | -sm | -n | -sp | -o]')
parser.add_argument('-f','--seqfile', help='one concatenated sequence file. Format - fasta, phylip, nexus')
parser.add_argument('-n','--names', help='sample ID to species names corresponding file. Format - ID scientific_name')
parser.add_argument('-sp','--selectedspps', help='a list of spps names that are multiple sampled (scientific_name)')
parser.add_argument('-sm','--selectedsample', help='a list of sample names that belongs to target genus (ID)')
parser.add_argument('-o','--output',help='prefix of output files, can include the path to the directory for the output files')
args = parser.parse_args()
