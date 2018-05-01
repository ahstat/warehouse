##############################################
# Transform string into operation (20160225) #
##############################################
a = "c(1,2,3)"
eval(parse(text = a))

#####################################################
# Converting data frame into multidimensional array #
#####################################################
# http://r.789695.n4.nabble.com/
# Converting-data-frame-into-multidimensional-array-td3926705.html
X <- data.frame(Titanic) 
xtabs(Freq ~., X)

#######################################
# Equation in text from lm (20150728) #
#######################################
a = c(1,2,3,4,5,7)
b = c(10,8,9,10,4,-1)
c = c(9,4,1,-3,-9,-10)
y = c(10,11,13,18,19,20)
reg = lm(y~a+b+c)
names_coeff = names(reg$coefficients)
names_coeff[1] = "1"
paste(paste(paste(names_coeff , reg$coefficients, 
                  sep="*(" ), collapse=")+"),")",sep="")

##################################################
# Get all variables beginning with S_ (20150727) #
##################################################
rm(list=ls())
S_1 = "coucou"
S_2 = "bonjour"
S_3 = "salut"
D_1 = "adieu"
first_two_letters = "S_"
current_ls = ls()
idx = which(substr(current_ls, 1, 2) == first_two_letters)
name_list = current_ls[idx]
for(name in name_list) { print(get(name)) }

#########################
# Handling overplotting #
#########################
# The keyword is "jitter".
#
# http://www.cookbook-r.com/Graphs/Scatterplots_%28ggplot2%29/
# If you have many data points, or if your data scales are discrete, 
# then the data points might overlap and it will be impossible to see
# if there are many points at the same location.
library(ggplot2)
N = 1000
dat = data.frame(xvar = rnorm(N), yvar = rnorm(N))
# Round xvar and yvar to the nearest 5
dat$xrnd <- round(dat$xvar/5)*5
dat$yrnd <- round(dat$yvar/5)*5
# Make each dot partially transparent, with 1/4 opacity
# For heavy overplotting, try using smaller values
ggplot(dat, aes(x=xrnd, y=yrnd)) +
  geom_point(shape=19,      # Use solid circles
             alpha=1/4)     # 1/4 opacity
# Jitter the points
# Jitter range is 1 on the x-axis, .5 on the y-axis
ggplot(dat, aes(x=xrnd, y=yrnd)) +
  geom_point(shape=1,      # Use hollow circles
             position=position_jitter(width=1,height=.5))
 
########################################
# Uniform dist in dim 10000 (20170329) #
########################################
# To show that all elements in high dimension are very far away one to 
# each other, under uniform distribution
N = 1000
m = 10000
a = matrix(runif(N*m), ncol = m)
dist_to_1 = sqrt(apply((t(t(a) - a[1,]))^2, 1, sum))
plot(sort(dist_to_1))

##################################
# Retrieve retrieve pdq of ARIMA #
##################################
library(forecast)
my_ts = ts(1:100)
my_autoarima = auto.arima(my_ts)
captured = capture.output(my_autoarima)[[2]]
captured = strsplit(captured, " ")[[1]][1]
captured2 = gsub("ARIMA\\(", "", captured)
captured2 = gsub("\\)", "", captured2)
p_d_q = as.numeric(strsplit(captured2, ",")[[1]])
print(p_d_q)

#########################################################
# Multiply rows of matrix by the same vector (20170106) #
#########################################################
# https://stackoverflow.com/questions/3643555
# Multiply rows of matrix by vector
(mat <- matrix(rep(1:3,each=5),nrow=3,ncol=5,byrow=TRUE))
vec <- 1:5
sweep(mat,MARGIN=2,vec,`*`)

################################################
# Write a string in the reverse order 20170719 #
################################################
# Example: revstring("bonjour") gives "ruojnob"
revstring <- function(s) paste(rev(strsplit(s,"")[[1]]),collapse="")
revstring("bonjour") # "ruojnob"

##########################################################################
# Sample uniform distribution on the surface of a unit sphere (20180501) #
##########################################################################
# http://mathworld.wolfram.com/HyperspherePointPicking.html
# Pick N points on S^{n-1}
sample_surface_sphere = function(N, n = 2) {
  M = matrix(rnorm(n * N), ncol = n)
  sample = M / sqrt(apply(M^2, 1, sum))
  return(sample)
}

# Example
n = 3 # dimension
N = 1000 # sample size
sample = sample_surface_sphere(N, n)

if(ncol(sample) == 2) {
  plot(sample, asp = 1)
} else if(ncol(sample) == 3) {
  library(rgl)
  plot3d(sample)
}