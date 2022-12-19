#!/usr/bin/env Rscript

library(ggplot2)
library(grid)
library(xlsx)

d <- read.xlsx('/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/13_Gardner_Artocarpus_Target_Capture/Basic_statistics_of_Artocarpus_target_capture.xlsx',
               sheetIndex = "Genes_diagnosability", 
               header = TRUE)

mydf <- data.frame(gene <- factor(d$Gene_Name, levels = d$Gene_Name),
                   NucDiv <- as.numeric(d$Nuc_Div),
                   SSSNP <- as.numeric(d$Den_SSSNPs_on_this_gene.kb),
                   Mono <- as.numeric(d$No_spps_mono_by_this_gene),
                   Num <- as.numeric(d$Num)
)

coeff = 5
NucDivColor <- rgb(0.9, 0.6, 0.5, 1)
SSSNPColor <- rgb(0.2, 0.6, 0.8, 1)
MonoColor <- rgb(0.3, 0.7, 0, 1)

p1 <- ggplot(mydf, aes(x = Num)) +
  geom_smooth(aes(y = SSSNP/coeff), col = SSSNPColor, size = 0.8, se=TRUE, span = 1) +
  geom_point(aes( y = SSSNP/coeff), col = SSSNPColor) +
  geom_point(aes( y = Mono), col = MonoColor) +
  scale_y_continuous(
    
    # Features of the first axis
    name = "Number species monophyly",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.*coeff, name="Density of SSSNPs (/Kb)", guide = waiver())
  ) +
  ggtitle("NucDiv, DensSSSNPs, and No_spps_mono by each gene - Artocarpus") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank(), axis.line = element_line(colour = "Grey50")) +
  theme(axis.title.y = element_text(color  =  MonoColor, size = 12),
        axis.title.y.right = element_text(color = SSSNPColor),
        axis.title.x=element_blank(),
        axis.text.x=element_blank()
  )

p2 <- ggplot(mydf, aes(x = Num)) +
  geom_point(aes( y = NucDiv), col = NucDivColor) +
  geom_smooth(aes(y = NucDiv), col = NucDivColor, size = 0.8, se=TRUE, span = 1) +
  xlab("Genes (numbered)") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
       panel.background = element_blank(), axis.line = element_line(colour = "Grey50")) +
  theme(axis.title.y = element_text(color  =  NucDivColor, size = 12)
  )

grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), size = "first"))  

