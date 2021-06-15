library(MonoPhy)
phy <- read.tree(file = "./astral_Geo_795genes_sptree.tre")
name_clades <- read.table(file="./tree_ID.txt", header=FALSE)
AssessMonophyly <- function(phy, taxonomy=name_clades)
solution0 <- AssessMonophyly(phy, taxonomy=name_clades)
result <- GetResultMonophyly(solution0)
GetSummaryMonophyly(solution0)
write.table(x = result, file = "./file.txt",sep = "\t", dec=",", col.names = TRUE,quote = FALSE)