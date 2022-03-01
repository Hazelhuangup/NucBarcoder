#!/usr/bin/env Rscript
args<-commandArgs(TRUE)
setwd('./')

library(ape)
library(phangorn)

d <- as.matrix(read.table(args[1], sep = "\t", header=TRUE))
add <- additive(d) ## Incomplete Distance Matrix Filling
colnames(add) <- colnames(d)
rownames(add) <- rownames(d)
UP_tree <- upgma(add, method="average")
write.tree(UP_tree, file=args[2])

q()
