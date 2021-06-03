library(ggplot2)
library(xlsx)

file = read.xlsx('/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/Overview_all_genus/Violin_data.xlsx',sheetIndex = 'Sheet1', header = TRUE)

# Convert the variable dose from a numeric to a factor variable ## essential
Genus = as.factor(file$Genus)
Density_of_SSSNPs = as.numeric(file$Density_of_SSSNPs..MB.)

# Basic violin plot
ggplot(file, aes(x=Genus, y=Density_of_SSSNPs, color=Genus, fill=Genus)) + 
  coord_flip() + 
  geom_violin(scale = "width",trim=T) +
  geom_jitter(shape=16, position=position_jitter(0.05), color = "Grey50") +
  theme_light()

