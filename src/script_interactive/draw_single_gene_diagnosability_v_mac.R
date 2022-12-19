#!/usr/bin/env Rscript

library(ggplot2)
d <- read.table('OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/02_Inga_Target_Capture/05_down_sampling/Number_of_spps_mono_by_single_gene.list')
index <- seq(1:nrow(d))
coords <- paste(index,d$V1,sep=",")

ggplot() +
  geom_point(aes(index,d$V1), color = "Royalblue3" )+
  labs(title = "Numbers of species discriminated by individule genes - Inga", x = "Gene index", y = "Number_species_discriminated") +
  geom_label(data = subset(d, index == nrow(d)), aes(x = nrow(d), y = d$V1[nrow(d)], label = coords[nrow(d)]), size = 2.5)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "Grey50"))

ggplot(d, aes(V1)) +
  geom_histogram(binwidth = 0.5, fill = "Royalblue3", color = "Royalblue3")+
  labs(title = "Frequency of numbers of species discriminated by one gene - Inga", x = "Number_species_discriminated", y = "Frequency") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "Grey50")) 
