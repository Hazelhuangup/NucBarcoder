#/usr/local/bin/R
args<-commandArgs(TRUE)
library(ggplot2)
library(xlsx)

FILE<-args[1]
PDF<-args[2]
pdf(PDF,width=as.numeric(args[3]),height=as.numeric(args[4]))

data <- read.xlsx(FILE,sheetIndex = 'AILs', header = TRUE)
data$Species_Name = factor(data$Species_Name, levels = unique(data$Species_Name))
mydf <- data.frame(
  Spp_Name= data$Species_Name,
  No_SSAs = as.numeric(data$Number_of_SSSNPs),
  Category = data$Monophyly.,
  Number_of_Individuals = as.numeric(data$Number_of_Individuals)
)
plot <-
  ggplot(mydf) + 
  geom_point(aes(col = Category, x = No_SSAs, y = Spp_Name, size = Number_of_Individuals)) +
  labs(x = "Number_of_SSSNPs", y = "Species_Names", col = "Monophyly?") +
  ggtitle('Number_of_SSSNPs_and_Monophyly_correlation') +
  theme_light()

print(plot)
dev.off()
q()
