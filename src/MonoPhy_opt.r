#!/usr/bin/env Rscript
args<-commandArgs(TRUE)
setwd('./')

library(MonoPhy)
library("optparse")

option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="tree file name", metavar="character"),
    make_option(c("-o", "--out"), type="character", default="Monophyly_summary.txt", 
              help="output file name [default= %default]", metavar="character")
    make_option(c("-og", "--outgroup"), type="character", default=NULL, 
              help="output file name", metavar="character")
    make_option(c("-n", "--taxnames"), type="character", default=NULL, 
              help="taxonomy corresponding name file for all samples", metavar="character")
); 
 
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

phy <- read.tree(file = args[1])
rooted_tree <- root(phy, outgroup = args[2], resolve.root = TRUE)

if (length(args)==3) {
	name_clades <- read.table(file=args[3], header=FALSE)
	solution0 <- AssessMonophyly(rooted_tree, taxonomy = name_clades)
	print(solution0)
} else {
	solution0 <- AssessMonophyly(rooted_tree)
}

result <- GetResultMonophyly(solution0)
#GetSummaryMonophyly(solution0)
write.table(x = result, file = "./file.txt",sep = "\t", dec=",", col.names = TRUE, quote = FALSE)

q()
