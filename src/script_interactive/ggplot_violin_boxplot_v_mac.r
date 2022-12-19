library(ggplot2)
library(xlsx)
library(stringr)
library(tidyverse)
library(dplyr)
library(scales)

file = read.xlsx('/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/Overview_all_genus/Violin_all_genus.xlsx',sheetIndex = 'Genera_1_SSSNP_per_x_bp', header = TRUE)

## defining the function
# show only the first part of the interaction labels 
make_labels <- function(labels) {
  result <- str_split(labels, "\\.")
  unlist(lapply(result, function(x) x[1]))
} 

fancy_scientific <- function(l) {
  # turn in to character string in scientific notation
  l <- format(l, scientific = TRUE)
  # quote the part before the exponent to keep all the digits
  l <- gsub("^(.*)e", "'\\1'e", l)
  # turn the 'e+' into plotmath format
  l <- gsub("e", "%*%10^", l)
  # return this as an expression
  parse(text=l)
}

# Convert the variable dose from a numeric to a factor variable ## essential
Genus = as.factor(file$Group)
Density_of_SSSNPs = as.numeric(file$One_SSSNP_per_x_bp)
Sequencing_method = as.factor(file$Sequencing_technique)
Form = as.factor(file$Form)
dy <-replace(file$Monophyly, file$Monophyly == "No","x")
df <- replace(dy, file$Monophyly == "Yes", "o")
rects = data.frame(xstart = c(0,13), xend = c(13,29))

# Basic violin plot
ggplot(data = file, aes(x=interaction(Genus,Sequencing_method,Form), y=Density_of_SSSNPs, 
                      color = Sequencing_method, fill=Sequencing_method, group = Genus)) + 
  geom_boxplot(scale = "width",trim=T) +
  geom_point(shape = df, position = position_jitterdodge(), color = "Grey50", size =2 ,show.legend = TRUE) +
  scale_y_log10(labels = comma) +
  coord_flip() +
  scale_x_discrete(labels = make_labels) + 
  labs(x = "Genus", y = "Species Specific SNPs per bp") +
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
  

