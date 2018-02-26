#########################################################
# Code plotted in https://ahstat.github.io/Clickstream/ #
#########################################################
setwd("E:/gitperso/warehouse")
library(dplyr)
library(ggplot2)

# Data frame of attemps with pic number, cell clicked, id of user and date.
df0 = read.csv("data/Anabasis_ggplot/attempts.csv")
dir.create("outputs", showWarnings = FALSE)
out_folder = "outputs/Anabasis_ggplot"
dir.create(out_folder, showWarnings = FALSE)

##
# Helper functions
##
# Extract digits of a number x between 0000 and 9999.
digits_func = function(x) {
  x = as.integer(x)
  d4 = floor(x/1000)
  d3 = floor((x-1000*d4)/100)
  d2 = floor((x-1000*d4-100*d3)/10)
  d1 = floor(x-1000*d4-100*d3-10*d2)
  return(c(d4, d3, d2, d1))
}

# Extract digits of a vector of password, and output as a data frame
extract_digits = function(pass) {
  digits = as.data.frame(t(sapply(pass, digits_func)))
  colnames(digits) = c("d4", "d3", "d2", "d1")
  return(digits)
}

# Get (x, y) positions inside rooms
pos_small_func = function(digits) {
  pos_small = digits[,c("d2", "d1")]
  df1 = data.frame(x = pos_small$d1, y = 9 - pos_small$d2)
  return(df1)
}

# Get (x, y) positions in the lobby
pos_large_func = function(digits) {
  pos_large = digits[,c("d4", "d3")]
  df2 = data.frame(x = pos_large$d3, y = 9 - pos_large$d4)
  return(df2)
}

# Get (x, y) positions in the 100 x 100 picture
pos_absolute_func = function(digits) {
  pos_absolute = data.frame(x = digits$d3 + digits$d1/10,
                            y = digits$d4 + digits$d2/10)
  df3 = data.frame(x = pos_absolute$x, y = 9.9 - pos_absolute$y)
  return(df3)
}

##
# Take top n clicks of each drawing and plot density of clicks:
# * Inside rooms,
# * In each cell at the lobby,
# * On the whole with 10000 elements.
##
for(top in c(1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000)) {
  print(top)
  df = df0 %>% group_by(vault_num) %>% top_n(n = -top, wt = date)
  pass = df$pass
  # pass = c(pass, rep(1789, 700)) # to check results
  digits = extract_digits(pass)
  df1 = pos_small_func(digits)
  df2 = pos_large_func(digits)
  df3 = pos_absolute_func(digits)
  
  for(i in 1:3) {
    if(i == 1) {
      dfi = df1
      bins = 10
      type = "room"
    } else if(i == 2) {
      dfi = df2
      bins = 10
      type = "lobby"
    } else if(i == 3) {
      dfi = df3
      bins = 100
      type = "whole"
    }
    
    # Note: don't use image.plot from fields! Too difficult to manage legend
    # Note: the bug even when drop = FALSE when row/col is empty is documented
    # at https://github.com/tidyverse/ggplot2/issues/2202
    png(paste0(out_folder, "/", type, "_top_", top, ".png"), 560, 560)
    print(
    ggplot(dfi, aes(x,y)) + 
      stat_bin2d(bins = bins, aes(fill = ..density..), drop = FALSE) +
      coord_fixed() +
      theme(axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.background=element_blank(),
            panel.border=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            #legend.position = c(0.98, 0.65),
            #legend.justification = c(0, 1),
            plot.background=element_blank()) + 
      scale_fill_gradient(low = "black", high = "blue")
                          #, labels = function(x){sprintf("%0.3f", x)})
    )
    dev.off()
  }
}
 
##
# Plot each draw with one color for (almost) one id
##
for(draw_nb in 1:max(df0$vault_num)) {
  print(draw_nb)
  df = df0 %>% filter(vault_num == draw_nb)
  
  # Removing duplicates (yes...)
  df = df %>% group_by(pass) %>% top_n(-1, date)
  
  # Adding NA for each undiscovered cell on the grid
  digits = extract_digits(df$pass)
  digits_all = expand.grid(d4=0:9, d3=0:9, d2=0:9, d1=0:9)
  digits_all = rbind(digits, digits_all)
  dup = which(duplicated(digits_all))
  dup = dup[which(dup > nrow(digits))]
  digits_all = digits_all[-dup,]
  df$id = as.character(df$id)
  df = cbind(digits_all, id = c(df$id, rep(NA, 10000 - nrow(df))))
  df = cbind(df, pos_absolute_func(df))
  df$id = addNA(df$id, ifany = FALSE)
  
  # Plotting
  png(paste0(out_folder, "/image", draw_nb, ".png"), 560, 560)
  print(
    ggplot(df, aes(x,y)) + 
      stat_bin2d(bins = 100, aes(fill = id), drop = TRUE) +
      coord_fixed() +
      theme(axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.background=element_blank(),
            panel.border=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            legend.position = "none",
            #legend.justification = c(0, 1),
            plot.background=element_blank()) + 
      scale_fill_discrete(na.value="#222222")
  )
  dev.off()
}