library(dplyr)

data = read.table('/Users/HW/OneDrive_University_of_Edinburgh/OneDrive - University of Edinburgh/PhD_Research/Species_Identification_meta-analysis/01_Antirrhinum_RAD_seq/05_down_sampling/Number_of_spps_mono_for_boxplot.txt', sep = "\t", header=TRUE)
df = as.data.frame(data)

result <- df %>%  
  summarize_all(list(first_quartile = ~ quantile(.x, probs = 0.25),
                     median = ~quantile(., 0.5),
                     third_quartile = ~quantile(., 0.75)))
