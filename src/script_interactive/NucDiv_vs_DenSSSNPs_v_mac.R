#!/usr/bin/env Rscript

library(ggplot2)

d <- read.table('OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/01_Antirrhinum_RAD_seq/03_output/microphyllum_NucDiv_NO_SSSNPs_window_for_fig.txt')

mydf <- data.frame(Chr <- d$V1,
                   Pos <- d$V2,
                   NucDiv <- as.numeric(d$V3),
                   SSSNP <- as.numeric(d$V7)
                   )
coeff <- 20000
NucDivColor <- rgb(0.9, 0.6, 0.5, 1)
SSSNPColor <- rgb(0.2, 0.6, 0.8, 1)

ggplot(mydf, aes(x = Pos)) +
  geom_line(aes( y = NucDiv), col = NucDivColor) +
  geom_point(aes( y = SSSNP/coeff), col = SSSNPColor) +
  scale_y_continuous(
    
    # Features of the first axis
    name = "Nucleotide Diversity",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.*coeff, name="Density of SSSNPs (/Mb)")
  ) +
  ggtitle("NucDiv vs. DensSSSNPs - Antirrhinum") +
  theme_light() +
  theme(
    axis.title.y = element_text(color  =  NucDivColor, size = 12),
    axis.title.y.right = element_text(color = SSSNPColor)
  ) +
  facet_grid( ~mydf$Chr....d.V1, scales = "free") 
 

  

