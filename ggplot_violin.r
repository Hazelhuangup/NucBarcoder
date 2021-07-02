library(ggplot2)
library(xlsx)

file = read.xlsx('/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/Overview_all_genus/Violin_all_genus.xlsx',sheetIndex = 'Sheet1', header = TRUE)

## defining the function
# show only the first part of the interaction labels 
make_labels <- function(labels) {
  result <- str_split(labels, "\\.")
  unlist(lapply(result, function(x) x[1]))
} 

# Convert the variable dose from a numeric to a factor variable ## essential
Genus = as.factor(file$Group)
Density_of_SSSNPs = as.numeric(file$Density_of_SSSNPs..MB.)
Sequencing_technique = as.factor(file$Sequencing_technique)
Form = as.factor(file$Form)
rects = data.frame(xstart = c(0,13), xend = c(13,29))


# Basic violin plot
ggplot(data = file, aes(x=interaction(Genus,Sequencing_technique,Form), y=Density_of_SSSNPs, 
                      color = Sequencing_technique, fill=Sequencing_technique, group = Genus)) + 
  geom_violin(scale = "width",trim=T) +
  geom_jitter(shape=16, position=position_jitter(0.05), color = "Grey50") +
  scale_y_log10() +
  coord_flip() +
  scale_x_discrete(labels = make_labels) + 
  labs(title = "Distribution of the Density of Species Specific SNPs for Generic Level Groups", x = "Genus", y = "Density_of_SSSNPs(/Mb)") +
  theme_light()
