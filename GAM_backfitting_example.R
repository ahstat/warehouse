###############################################################
# Step by step execution of backfitting algorithm used in GAM #
# 2015/07/27                                                  #
###############################################################
# Backfitting algorithm is one of the methods to fit functions f1, f2 etc.
# used in the GAM (generalized additive model).
# See https://en.wikipedia.org/wiki/Generalized_additive_model
#
# We compute step by step the iterative backfitting algorithm 
# with a cubic smoothing spline, following:
# https://en.wikipedia.org/wiki/Backfitting_algorithm
#
# We only consider a case with 2 functions f1 and f2.
#
# Note: In practice, it is already implemented in gam packages.

###############
# Sample data #
###############
N=100
set.seed(1)

## x
x1 = runif(N, 1, 10)
x2 = runif(N, 1, 10)
x = data.frame(x1=x1, x2=x2)

## y
f1_original = function(x){log(abs(x))}
f2_original = function(x){sqrt(abs(x))}
y = f1_original(x1) + f2_original(x2)

##########################################
# Backfitting algorithm in dimension two #
##########################################
n = nrow(x)
n_points = 10000

mean_sq = c()
alpha = mean(y)

## Prepare to predict on training set
f1 = rep(0, N)
f2 = rep(0, N)

## Prepare to predict on the set (x, x)
range_points = range(x) + c(-1, 1)
x_points = seq(from=range_points[1], to=range_points[2], length.out = n_points)
x_all = data.frame(x1=x_points, x2=x_points)
f1_all = rep(0, n_points)
f2_all = rep(0, n_points)

## Helper functions
mse = function(y, hat_y) {
  mean((hat_y - y)^2)
}

predict_spline = function(sm, x, coord = 2) {
  xi = x[[coord]]
  fj = predict(sm, xi)$y
  fj = fj - mean(fj) # to circumvent numerical issues, not needed in theory
  return(fj)
}

## Initialize prediction on training set
hat_y = rep(alpha, n)

## Iterative predictions
iter = 5
for(j in 1:iter) {
  # Apply backfitting algorithm
  sm = smooth.spline(x2, y - alpha - f2)
  f1 = predict_spline(sm, x, coord = 2)
  f1_all = predict_spline(sm, x_all, coord = 2)
  
  sm = smooth.spline(x1, y - alpha - f1)
  f2 = predict_spline(sm, x, coord = 1)
  f2_all = predict_spline(sm, x_all, coord = 1)
  
  # Prediction for this iteration
  hat_y = alpha + f1 + f2
  
  # Append vector of mean squared errors
  mean_sq = c(mean_sq , mean((hat_y - y)^2))
  
  # Plot y vs y_hat on training set
  par(mfrow=c(1,2))
  interval = 1:10
  plot(x1[interval], y[interval], xlab = "x1", ylab = "y")
  lines(x1[interval], hat_y[interval], type="p", col="red")
  plot(x2[interval], y[interval], xlab = "x2", ylab = "y")
  lines(x2[interval], hat_y[interval], type="p", col="red")
  title = paste0("Predicted y (red) and true y (black) as a function of x1 and x2",
                 " [iter ", j, "]")
  mtext(title, side = 1, line = -21, outer = TRUE, font = 2)
  
  # Plot y vs y_hat computed/predicted on the (x, x) straight line
  plot(x_points, f1_all, type="l", col="red", xlab = "x1", ylab = "y")
  lines(x_points, f1_original(x_points)-mean(f1_original(x_points)),
        type="l", col="black")
  plot(x_points, f2_all, type="l", col="red", xlab = "x2", ylab = "y")
  lines(x_points, f2_original(x_points)-mean(f2_original(x_points)),
        type="l", col="black")
  title = paste0("Predicted y (red) and true y (black) for new inputs (x, x)",
                 " [iter ", j, "]")
  mtext(title, side = 1, line = -21, outer = TRUE, font = 2)
}

plot(mean_sq, xlab = "iter", ylab = "MSE", 
     title = "MSE on training set as a function of iterations")
# MSE decreases quickly on training set, but beware of overfitting