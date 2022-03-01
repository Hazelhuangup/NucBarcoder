#!/usr/bin/env Rscript
args<-commandArgs(TRUE)
setwd('./')

library(MonoPhy)
library(ape)
library(phangorn)

phy <- read.tree(file = args[1])
rooted_tree <- root(phy, outgroup = args[2], resolve.root = TRUE)

if (length(args)==4) {
	name_clades <- read.table(file=args[3], header=FALSE)
	tip <- intersect(phy[["tip.label"]],name_clades[["V1"]])
	tre <- keep.tip(phy, tip)
	taxa<-name_clades[name_clades$V1 %in% tip,]
	solution0 <- AssessMonophyly(tre, taxonomy = taxa)
} else {
	print("invalid argument length")
	solution0 <- AssessMonophyly(tre)
}

result <- GetResultMonophyly(solution0)
write.table(x = result, file = args[4],sep = "\t", dec=",", col.names = TRUE, quote = FALSE)

q()
