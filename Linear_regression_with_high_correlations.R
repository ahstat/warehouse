###########################################
# Linear regression y~x1+x2 in two cases: #
# 1/ x1 and x2 are highly correlated      #
# 2/ x1 and x2 are not correlated         #
# (2016/04/14)                            #
###########################################

#############################################################
# 1/ Linear regression when x1 and x2 are highly correlated #
#############################################################
# We have 2 variables x1 and x2, and we predict y with a linear regression.
# - x1 and x2 each explains y well,
# - x1 explains y better than x2 can do,
# - x1 and x2 are highly correlated.
#
# Consequences after linear regression:
# - x2 will be hidden by x1.
# In particular, using fitted function f to predict y from x2 only will give
# bad results (i.e. to do estimated_new_y = f(mean(training_x1), new_x2)).
# This is done for example when x1 is a missing value.

##
# Model
##
## Sample data
N = 1000
x1 = rnorm(N,6)
x2 = x1 + rnorm(N,0, 0.2)
y = x1 + rnorm(N,0,0.5)

## Linear model
reg = lm(y ~ x1+x2)
summary(reg) # x2 is hidden by x1

##
# y as a function of x1
##
plot(x1, y)
# We assume that new data is (x1, x2) with x2 = NA, 
# so we replace x2 with mean(training_x2)
# Conclusion: All is working well, because we do not really need x2 
# in our model
x1_new = seq(from = min(x1), to = max(x1), length.out = N) 
x2_new_q5 = rep(quantile(x2, 0.05), N)
x2_new = rep(mean(x2), N)
x2_new_q95 = rep(quantile(x2, 0.95), N)

predictions = predict(reg, data.frame(x1 = x1_new, x2 = x2_new))
lines(x1_new, predictions, type="l", col = "blue")

predictions = predict(reg, data.frame(x1 = x1_new, x2 = x2_new_q5))
lines(x1_new, predictions, type="l", col = "blue", lty = 2)

predictions = predict(reg, data.frame(x1 = x1_new, x2 = x2_new_q95))
lines(x1_new, predictions, type="l", col = "blue", lty = 2)

##
# y as a function of x2
##
plot(x2, y)
# We assume that new data is (x1, x2) with x1 = NA, 
# so we replace x1 with mean(training_x1)
# Conclusion: Nothing is working, because our model do not use any information
# from x2, it only get information through x1.
x2_new = seq(from = min(x2), to = max(x2), length.out = N) 
x1_new_q5 = rep(quantile(x1, 0.05), N)
x1_new = rep(mean(x1), N)
x1_new_q95 = rep(quantile(x1, 0.95), N)

predictions = predict(reg, data.frame(x1 = x1_new, x2 = x2_new))
lines(x2_new, predictions, type="l", col = "blue")

predictions = predict(reg, data.frame(x1 = x1_new_q5, x2 = x2_new))
lines(x2_new, predictions, type="l", col = "blue", lty = 2)

predictions = predict(reg, data.frame(x1 = x1_new_q95, x2 = x2_new))
lines(x2_new, predictions, type="l", col = "blue", lty = 2)

##########################################################
# 2/ Linear regression when x1 and x2 are not correlated #
##########################################################
# In this case, it works as expected, no problem to replace missing x1 by NA,
# or missing x2 by NA.

##
# Model
##
## Sample data
N = 1000
x1 = rnorm(N,6)
x2 = rnorm(N,0, 0.2)
y = x1 + x2 + rnorm(N,0,0.5)

## Linear model
reg = lm(y ~ x1+x2)
summary(reg)

##
# y as a function of x1
##
plot(x1, y)
x1_new = seq(from = min(x1), to = max(x1), length.out = N) 
x2_new_q5 = rep(quantile(x2, 0.05), N)
x2_new = rep(mean(x2), N)
x2_new_q95 = rep(quantile(x2, 0.95), N)

predictions = predict(reg, data.frame(x1 = x1_new, x2 = x2_new))
lines(x1_new, predictions, type="l", col = "blue")

predictions = predict(reg, data.frame(x1 = x1_new, x2 = x2_new_q5))
lines(x1_new, predictions, type="l", col = "blue", lty = 2)

predictions = predict(reg, data.frame(x1 = x1_new, x2 = x2_new_q95))
lines(x1_new, predictions, type="l", col = "blue", lty = 2)

##
# y as a function of x2
##
plot(x2, y)
x2_new = seq(from = min(x2), to = max(x2), length.out = N) 
x1_new_q5 = rep(quantile(x1, 0.05), N)
x1_new = rep(mean(x1), N)
x1_new_q95 = rep(quantile(x1, 0.95), N)

predictions = predict(reg, data.frame(x1 = x1_new, x2 = x2_new))
lines(x2_new, predictions, type="l", col = "blue")

predictions = predict(reg, data.frame(x1 = x1_new_q5, x2 = x2_new))
lines(x2_new, predictions, type="l", col = "blue", lty = 2)

predictions = predict(reg, data.frame(x1 = x1_new_q95, x2 = x2_new))
lines(x2_new, predictions, type="l", col = "blue", lty = 2)
