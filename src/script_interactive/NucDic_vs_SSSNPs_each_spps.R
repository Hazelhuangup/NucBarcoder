#!/usr/bin/env Rscript

library(ggplot2)
library(xlsx)

d <- read.xlsx('/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/04_Geonoma_Target_Capture/Basic_statistics_Geo.xlsx',sheetIndex = 'Sheet1', header = TRUE)

# make Number_of_SSSNPs an ordered factor

mydf <- data.frame(Spps <- factor(d$Species_Name, levels = d$Species_Name),
                   NucDiv <- as.numeric(d$NucDiv_concatenate),
                   SSSNP <- as.numeric(d$Number_of_SSSNPs)
)
coeff <- 1000000
NucDivColor <- rgb(0.9, 0.6, 0.5, 1)
SSSNPColor <- rgb(0.2, 0.6, 0.8, 1)


ggplot(mydf, aes(x = Spps)) +
  geom_point(aes( y = NucDiv), col = NucDivColor) +
  geom_point(aes( y = SSSNP/coeff), col = SSSNPColor) +
  scale_y_continuous(
    
    # Features of the first axis
    name = "Nucleotide Diversity",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.*coeff, name="Density of SSSNPs (/Mb)")
  ) +
  ggtitle("NucDiv vs. DensSSSNPs concatenated - Geonoma") +
  theme_light() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
    axis.title.y = element_text(color  =  NucDivColor, size = 12),
    axis.title.y.right = element_text(color = SSSNPColor)
  )




