library(ggplot2)
library(xlsx)
library(stringr)
library(tidyverse)

file = read.xlsx('/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/Overview_all_genus/Violin_all_genus.xlsx',sheetIndex = 'Genera_Density_SSSNPs', header = TRUE)

## defining the function
# show only the first part of the interaction labels 
make_labels <- function(labels) {
  result <- str_split(labels, "\\.")
  unlist(lapply(result, function(x) x[1]))
} 

# Convert the variable dose from a numeric to a factor variable ## essential
Genus = as.factor(file$Group)
Density_of_SSSNPs = as.numeric(file$Density_of_SSSNPs..MB.)
Sequencing_method = as.factor(file$Sequencing_technique)
Form = as.factor(file$Form)
dy <-replace(file$Monophyly, file$Monophyly == "No","x")
df <- replace(dy, file$Monophyly == "Yes", "o")
rects = data.frame(xstart = c(0,13), xend = c(13,29))


# Basic violin plot
ggplot(data = file, aes(x=interaction(Genus,Sequencing_method,Form), y=Density_of_SSSNPs, 
                      color = Sequencing_method, fill=Sequencing_method, group = Genus)) + 
  geom_violin(scale = "width",trim=T) +
  geom_point(shape = df, position = position_jitterdodge(), color = "Grey50", size =1.4 ,show.legend = TRUE) +
  scale_y_log10() +
  coord_flip() +
  scale_x_discrete(labels = make_labels) + 
  labs(x = "Genus", y = "Density_of_SSSNPs(/Mb)(log)") +
  theme_light()

## draw a density plot comparing all mono spps and non-mono spps
sheet2 = read.xlsx('/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/Overview_all_genus/Violin_all_genus.xlsx',sheetIndex = 'Monophyly_Density_SSSNPs', header = TRUE)
Mono = as.factor(sheet2$Monophyly)
Den = as.numeric(sheet2$Density_of_SSSNPs..MB.)

ggplot(data = sheet2) +
  geom_boxplot(aes(x = Mono, y = Den, fill = Mono)) +
  ylim(0,5000)+
  labs(x= "Monophyletic?",
       y = "Density_of_SSSNPs")+
  theme_light()
  

