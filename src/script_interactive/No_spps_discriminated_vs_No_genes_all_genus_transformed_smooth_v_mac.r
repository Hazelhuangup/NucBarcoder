library(ggplot2)
library(tidyverse)
library(xlsx)

f = read.xlsx("/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/Overview_all_genus/All_genus_by_SNP_smooth_plot.xlsx", check.names=FALSE, header=TRUE, sheetIndex = 'All_genus_median_transformed')

Number_genes <- as.numeric(f$N_SNPs)
Number_species_discriminated <- as.numeric(f$Median_transformed)
Genus = as.factor(f$Genus)

ggplot(data = f) +
  geom_smooth(aes(x = Number_genes, y = Number_species_discriminated, group=Genus, color = Genus), size = 0.8, se=FALSE, span = 0.5) +
  scale_y_continuous(minor_breaks = seq(0 , 100, 5), breaks = seq(0, 100, 10)) +
#  labs(title = "Numbers of species discriminated by distance (transformed) - All Genus", x = "Number_genes", y = "Number_species_discriminated (transformed %)") +
  labs(x = "Number of SNPs", y = "Number of Species Discriminated (transformed %)") +
  theme_light()


