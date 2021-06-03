#/usr/local/bin/R
library(ggplot2)

data <- read.table("/Users/HW/All_final.info_new.txt", NULL, header = TRUE)
data$Species_Name = factor(data$Species_Name, levels = unique(data$Species_Name))
mydf <- data.frame(
  Spp_Name= data$Species_Name,
  No_SSAs = as.numeric(data$Number_of_SSSNPs),
  Category = data$Intra.Inter.,
  Number_of_Individuals = as.numeric(data$Number_of_Individuals)
)
plot <-
  ggplot(mydf) + 
  geom_point(aes(fill = Category, col = Category, x = No_SSAs, y = Spp_Name, size = Number_of_Individuals)) +
  labs(x = "Number_of_SSSNPs", y = "Species_Names") +
  ggtitle('Number_of_SSSNPs_and_distance_correlation') +
  theme_light()

print(plot)
dev.off()
q()
