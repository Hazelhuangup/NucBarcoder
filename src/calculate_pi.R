#!/usr/bin/env Rscript
## calculate nucleotide diversity (π) 

args<-commandArgs(TRUE)

library(ape)
library(pegas)

fa <- read.FASTA(file = args[1], type = "DNA")
pi <- nuc.div(fa)
write.table(x = pi, file = args[2],sep = "\t", dec=",", quote = FALSE)

q()