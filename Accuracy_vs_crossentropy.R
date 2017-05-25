###
# This code illustrates different behaviors between accuracy and cross entropy
# in the context of logistic regression。
#
# Three different samples can be selected:
# * An example where the lowest cross entropy is not where there is the maximum
# accuracy (with 5 points in the set),
# * An example where the accuracy can begin to increase, even with very high
# values of the parameter (indicating overfitting), but where the cross entropy
# is also increasing (with 100 points in the set),
# * An example where the accuracy and the cross entropy are closely related
# (with 10000 points in the set).
#
# See https://stats.stackexchange.com/questions/258166/good-accuracy-despite-high-loss-value/281651
# for more explanations.
###

##
# Helper functions
##
cross_entropy = function(y, y_hat) {
  cross_current = -(y*log(y_hat)+(1-y)*log(1-y_hat))
  return(mean(cross_current))
}

accuracy = function(y, y_hat) {
  y_hat_int = ifelse(y_hat > 0.5, 1, 0)
  acc_current = y_hat_int == y
  return(mean(acc_current))
}

compute_grid = function(x, y, grid_a, grid_b) {
  nrow = length(grid_a)
  ncol = length(grid_b)
  
  cross_entropy_all = matrix(NA, nrow, ncol)
  accuracy_all = matrix(NA, nrow, ncol)
  for(i in 1:nrow) {
    for(j in 1:ncol) {
      a = grid_a[i]
      b = grid_b[j]
      y_hat = plogis(a*x+b)
      cross_entropy_all[i,j] = cross_entropy(y, y_hat)
      accuracy_all[i,j] = accuracy(y, y_hat)
    }
  }
  
  return(list(cross = cross_entropy_all, acc = accuracy_all))
}

create_sample = function(n, a = 1, b = 0, seed = 1234) {
  set.seed(seed)
  x = runif(n, -1, 1)
  
  # from https://stats.stackexchange.com/questions/20523/difference-between-logit-and-probit-models
  y = rbinom(n, size=1, prob=plogis(a*x+b, scale=1)) # logistic model
  #y = rbinom(n, size=1, prob=pnorm(a*x+b, scale=1)) # probit model
  
  return(list(x=x, y=y))
}

##
# x/y set and grid (select one of those 3 sets)
##

# Small set to show difference
xy_set = list(x = c(-1, -0.3, 0, 0.9, 1),
              y = c( 0,    0, 1,   0, 1))
grid_a = seq(from = -5, to = 5, by = 0.1)
grid_b = seq(from = -5, to = 5, by = 0.1)

# Intermediate set
xy_set = create_sample(n = 100, a = 0.3, b = 0.5, seed = 845)
grid_a = seq(from = 0, to = 10, by = 0.1)
grid_b = seq(from = -5, to = 5, by = 0.1)

# Ok set
xy_set = create_sample(n = 10000, a = 1, b = 0, seed = 1234)
grid_a = seq(from = 0, to = 10, by = 0.1)
grid_b = seq(from = -5, to = 5, by = 0.1)

##
# Code (to do with each set)
##
x = xy_set$x
y = xy_set$y

plot(x, y)

## Compute for a grid
output = compute_grid(x, y, grid_a, grid_b)
cross = output$cross
acc = output$acc

## Compute minimum for cross-entropy
reg = glm(y ~ x, family = binomial)
y_hat = plogis(predict.glm(reg))
cross_ML = cross_entropy(y, y_hat)
acc_ML = accuracy(y, y_hat)

a_ML = reg$coefficients[2]
b_ML = reg$coefficients[1]

##
plot(cross, acc, xlab = "cross entropy", ylab = "accuracy",
     main = "Relationship between accuracy and cross entropy 
     for values on the grid")
points(cross_ML, acc_ML, col = "red", pch = 19)

## View for a fixed a
a = a_ML
#
idx_a = which.min(abs(grid_a-a))
plot(grid_b, cross[idx_a,], ylim = c(0.5,1),
     xlab = "b", ylab = "cross entropy (black) or accuracy (red)",
     main = paste("With a=", round(a_ML,2), 
                  ", values of cross entropy and accuracy when b varies",
                  sep = ""))
lines(grid_b, acc[idx_a,], col = "red", type = "o")

## View for a fixed b
b = b_ML
#
idx_b = which.min(abs(grid_b-b))
plot(grid_a, cross[,idx_b], ylim = c(0,1),
     xlab = "a", ylab = "cross entropy (black) or accuracy (red)",
     main = paste("With b=", round(b_ML,2), 
                  ", values of cross entropy and accuracy when a varies",
                  sep = ""))
lines(grid_a, acc[,idx_b], col = "red", type = "o")

## See where accuracy is maximum
idx = which(output$acc == max(output$acc), arr.ind = TRUE)
which_a = grid_a[idx[,1]]
which_b = grid_b[idx[,2]]
plot(which_a, which_b,
     xlab = "a", ylab = "b",
     main = "Position on the grid where the accuracy is maximum")

yhat_cross_min = plogis(a_ML * x + b_ML)
accuracy(y, yhat_cross_min)
-(y*log(yhat_crossmin)+(1-y)*log(1-yhat_crossmin))

# For 'small set' only
yhat_best_acc_1 = plogis(5*x+ 0.5)
accuracy(y, yhat_best_acc_1)
-(y*log(yhat_best_acc_1)+(1-y)*log(1-yhat_best_acc_1))

yhat_best_acc_2 = plogis(5*x-4.8)
accuracy(y, yhat_best_acc_2)
-(y*log(yhat_best_acc_2)+(1-y)*log(1-yhat_best_acc_2))