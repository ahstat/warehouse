############################
# Heatmaps                 #
# 2016/10/26 -- 2018/02/26 #
############################

#################
# Grid heatmaps #
#################
## See warehouse/Anabasis_ggplot.R for the best way to do heatmaps using ggplot

################################
# Circular heatmap with ggplot #
################################
library(ggplot2)

circular_r_theta = function(r, theta, title = "") {
  seq_angle = seq(from = 0, to = 350, by = 10)
  seq_r = 0:max(r)
  
  df = data.frame(r = r, theta = theta)
  df = rbind(df, data.frame(r=c(0, 0), theta=c(0, 350)))
  
  if(!all(sort(unique(df$theta)) %in% seq_angle)) {
    print(head(theta))
    stop("theta must be in {0, 10, ..., 340, 350}, cannot be other values.")
  }
  
  my_plot = ggplot(df, aes(x=r+0.5 , y=theta+5)) +
    stat_bin2d(bins = c(length(seq_r)-1, 
                        length(seq_angle)-1), drop = FALSE,
               aes(fill = ..count.. + ..count../..count.. - 1)) + 
    scale_x_continuous(breaks = 0.5 + seq_r,
                       labels = seq_r) +
    scale_y_continuous(breaks = 5 + seq_angle,
                       labels = seq_angle) +
    coord_polar(theta = "y", start=0) + 
    labs(x="r", y="theta",title = title, fill="count") +
    scale_fill_distiller(palette = "Spectral", na.value = NA,
                         labels = function(x){sprintf("%0.0f", x)})
  
  return(my_plot)
}

N = 10000
r = sample(0:10, N, replace = TRUE)
theta = sample(seq(from = 0, to = 350, by = 10), N, replace = TRUE)
circular_r_theta(r, theta, "Sampled r and theta without missing elements")

N = 1000
r = floor(pmax(0, rnorm(N, 5, sd = 2.5)))
# theta must be in {0, 10, ..., 350}
theta = floor(rnorm(N, 220, sd = 40) %% 360 / 10) * 10
circular_r_theta(r, theta, "Sampled r and theta with missing elements")

################
# Contour plot #
################
# From http://ggplot2.tidyverse.org/reference/geom_contour.html
v <- ggplot(faithfuld, aes(waiting, eruptions, z = density))
v + geom_contour()

########################################################
# Base R methods to do grid heatmaps and contour plots #
########################################################

##
# Create heatmap with contours without ggplot
##
N = 100
set.seed(5)
x = 25 + runif(N)
y = 45 + 2*runif(N)
z = 100 - 2*abs(x-25.5) - abs(y-45.8) + rnorm(N, 0, 0.01)
data <- data.frame(x=x, y=y, z=z)
# plot(y, z)
# plot(x, z)

require(akima) # for function "interp"
# Source: http://stackoverflow.com/questions/11531059/
# See also: https://pakillo.github.io/R-GIS-tutorial/

# You can increase resolution by decreasing following number
# (warning: the resulting dataframe size increase very quickly)
resolution <- 0.005
a <- interp(x=data$x, y=data$y, z=data$z, 
            xo=seq(min(data$x),max(data$x),by=resolution), 
            yo=seq(min(data$y),max(data$y),by=resolution), duplicate="mean")
image(a, xlab = "x", ylab = "y") # you can of course modify the color palette and the color categories. See ?image for more explanation
contour(a, add = TRUE)

##
# Create heatmap on a grid
##
library(fields)
x <- 1:10
y <- 1:15
z <- outer( x,y,"+") 
image.plot(x,y,z) 

##
# Create heatmap by doing GAM smooth regression
##
library("gam")
library("gplots")
reg = gam(z ~ s(y,4) + s(x,4), data=data, trace=TRUE)
y_all = seq(from=range(y)[1], to = range(y)[2], length.out = 20)
x_all = seq(from=range(x)[1], to = range(x)[2], length.out = 20)
to_predict_all = expand.grid(y_all, x_all)
names(to_predict_all) = c("y", "x")
predictions = predict(reg, newdata=to_predict_all)
heatmap.2(predictions,dendrogram='none', Rowv=FALSE, Colv=FALSE,trace='none')
