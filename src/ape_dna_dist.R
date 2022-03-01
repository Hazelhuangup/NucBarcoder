#!/usr/bin/env Rscript
args<-commandArgs(TRUE)
setwd('./')

library(ape)

fa <- read.FASTA(file = args[1], type = "DNA")
dist <- format(dist.dna(fa, model="JC69", gamma = TRUE, pairwise.deletion = TRUE, as.matrix = TRUE),digits=4)
write.table(x = dist, file = args[2],sep = "\t", dec=",", col.names = TRUE, quote = FALSE)

q()
