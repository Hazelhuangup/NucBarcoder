#!/usr/bin/Rscript
args<-commandArgs(TRUE)

#lib
library(xlsx)

file = read.xlsx(args[1],sheetIndex = args[2], check.names=FALSE, header = TRUE)

result1 <- wilcox.test(file$Herbaceous,file$Woody, paired = FALSE)

Welch_seq_met = read.xlsx(args[1],sheetIndex = args[3], check.names=FALSE, header = TRUE)

result2 <- wilcox.test(Welch_seq_met$Genome_skimming,Welch_seq_met$RAD_GBS, paired = FALSE)
result3 <- wilcox.test(Welch_seq_met$Genome_skimming,Welch_seq_met$Target_Capture, paired = FALSE)
result4 <- wilcox.test(Welch_seq_met$Genome_skimming,Welch_seq_met$Transcriptome, paired = FALSE)
result5 <- wilcox.test(Welch_seq_met$RAD_GBS,Welch_seq_met$Target_Capture, paired = FALSE)
result6 <- wilcox.test(Welch_seq_met$RAD_GBS,Welch_seq_met$Transcriptome, paired = FALSE)
result7 <- wilcox.test(Welch_seq_met$Target_Capture,Welch_seq_met$Transcriptome, paired = FALSE)

result1
result2
result3
result4
result5
result6
result7

q()
