library(ape)
library(phangorn)

d <- as.matrixro(read.table("2genes_44.dist",sep = "\t",header=TRUE))
utra <- additive(d)
colnames(utra) < colnames(d)
rownames(utra) <- rownames(d)
UP_tree <- upgma(utra, method = "average")
plot(UP_tree, main="UPGMA")
write.tree(UP_tree, file="Inga_ex.tre")

