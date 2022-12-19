library(MonoPhy)
setwd('./')

phy <- read.tree(file = "10genes_0.mono.tre")
rooted_tree <- root(phy, outgroup = "BIP", resolve.root = TRUE)

name_clades <- read.table(file="ID_to_scientific_name.txt", sep = "\t", header=FALSE)
tip <- intersect(phy[["tip.label"]],name_clades[["V1"]])
tre <- keep.tip(phy, tip)
taxa<-name_clades[name_clades$V1 %in% tip,]
solution0 <- AssessMonophyly(tre, taxonomy = taxa)


result <- GetResultMonophyly(solution0)
write.table(x = result$Taxlevel_1, file = "00.txt",sep = "\t", dec=",", col.names = TRUE, quote = FALSE)
