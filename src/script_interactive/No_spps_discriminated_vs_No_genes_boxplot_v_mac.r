library(ggplot2)
library(tidyverse)

f = read.table("/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/19_FMario_Linaria_RAD/05_down_sampling/Number_of_spps_mono_all_for_boxplot.txt", check.names=FALSE, header=TRUE)
## boxplot
#boxplot(f)

d <- pivot_longer(f, cols = 1:length(colnames(f)), names_to = "Number_of_genes", values_to = "Number_of_species_discriminated")
Number_genes <- as.numeric(d$Number_of_genes)
Number_species_discriminated <- as.numeric(d$Number_of_species_discriminated)

ggplot(data = d) +
  geom_boxplot(aes(x = Number_genes, y = Number_species_discriminated, group = Number_genes)) +
  scale_y_continuous(minor_breaks = seq(0 , 42, 1), breaks = seq(0, 42, 2)) +
  geom_smooth(aes(x = Number_genes, y = Number_species_discriminated), size = 0.5, se=FALSE) +
  labs(title = "Numbers of species discriminated by Monophyly - Linaria", x = "Number_genes", y = "Number_species_discriminated") +
  theme_light()


