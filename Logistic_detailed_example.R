#######################################
# Introduction to logistic regression #
# 2016/11/18                          #
#######################################
# Logistic regression can solve a classification task, where:
# - explaining variables = continuous or categorical
# - target = categorical variable
#
# We detail how logistic regression works, assuming that model has been
# already trained
# (we do not detail how to train a logistic regression here)

# Data came from http://www.ats.ucla.edu/stat/data/binary.csv 
# Saved here as admission_gre_gpa.csv.
# This is the classic admit/gre/gpa/rank data frame.
# A sample version is saved as admission_gre_gpa_sample.csv.
# We want to predict "admit" feature which has 2 classes: 0 and 1.

# References
# https://en.wikipedia.org/wiki/Logistic_regression
# http://stat.ethz.ch/R-manual/R-patched/library/stats/html/glm.html
# http://ww2.coastal.edu/kingw/statistics/R-tutorials/logistic.html
# http://statistics.ats.ucla.edu/stat/r/dae/logit.htm

setwd("E:/gitperso/warehouse/")
data_folder = "data/Logistic_detailed_example"
library(RUnit)

mydata <- read.csv(file.path(data_folder, "admission_gre_gpa_sample.csv"))
head(mydata)
summary(mydata)
sapply(mydata, sd)

x = mydata$gre # explaining factor, here continuous
y = mydata$admit # target, here 0/1
plot(x,y, xlab = "GRE", ylab = "Admission?")

# We want to do classification:
# - In 1D: Given GRE, can we predict whether there is admission?
# - In 2D: Given GRE and GPA, can we predict whether there is admission?

#############################################
# 1- Why we shouldn't use linear regression #
#############################################

##
# a/ classic linear regression computation
##
plot(x,y, main="Linear regression on categorical data (not good)")
reg=lm(y~x) 
abline(reg, col="black", lty=2)

## plotted prediction in orange
lines(x, predict(reg), col="orange", type="p") 

## example of prediction for a point
k=23
lines(c(x[k],x[k]), c(y[k], predict(reg)[k]), type="l", col="orange") 

##
# b/ threshold of 0.5
##
threshold = 0.5
plot(x,y, main="Classification using linear regression (not good)")
abline(reg, col="black", lty=2)
abline(h=threshold)
# The intersection point is the limit. 
# With 'a' the slope of the regression and 'b' the intersect,
# x0 = (0.5 - b)/a.
x0 = (threshold - reg$coefficients[1])/reg$coefficients[2]

##
# c/ classification
##
plot(x,y, main="Classification using linear regression (not good)")
abline(v=x0, col="orange")
idx_no = which(predict(reg) < threshold)
idx_yes = which(predict(reg) > threshold)
lines(x[idx_no],y[idx_no], type="p", col="red")
lines(x[idx_yes],y[idx_yes], type="p", col="blue")
# The classification seems working, because only 4 points are misclassified.
# But this method is too sensitive to outliers, and should not be used, 
# as shown in d/

##
# d/ adding a new point: 6000 with answer 1.
##
x2 = c(x, 6000)
y2 = c(y, 1)
plot(x2,y2, main="Classification using linear regression (not good)")
reg2 = lm(y2~x2) 
abline(reg2, col="black", lty=2)

threshold = 0.5
idx_no_2 = which(predict(reg2) < threshold)
idx_yes_2 = which(predict(reg2) > threshold)
lines(x2[idx_no_2],y2[idx_no_2], type="p", col="red")
lines(x2[idx_yes_2],y2[idx_yes_2], type="p", col="blue")
# All points with answer 1 are misclassified excepting two of them.
# The logistic regression will correct this problem, by constraining the
# regression to be in ]0,1[.

##########################################################
# 2- Logistic regression in 1D: one input and one output #
##########################################################

##
# a/ sigmoid function
##
# The sigmoid function goes from 0 to 1, taking the value 0.5 in 0.
sigm = function(x) {1/(1+exp(-x))}
x=seq(from=-5, to=5, length.out = 100)
plot(x, sigm(x), type="l", main="Sigmoid function")

##
# b/ training model
##
# Trained with glm. We do not detail how it was trained.
mylogit <- glm(admit ~ gre, data = mydata, family = binomial(logit))

##
# c/ plot fitted sigmoid
##

## Plotting points
plot(mydata$gre, mydata$admit, xlab="x", ylab="Answer 0 or 1")

## Adding fitted sigmoid
# As for 1D linear regression, 2 coefficients have been trained: a and b.
# This linear part is computed with inside_lin_reg:
inside_lin_reg = function(x, mylogit) {coef(mylogit)[1]+x*coef(mylogit)[2]}
checkEqualsNumeric(inside_lin_reg(mydata$gre, mylogit), predict.glm(mylogit))
x = seq(from=min(mydata$gre), to=max(mydata$gre), length.out = 100)
linear = inside_lin_reg(x, mylogit)

# We apply the sigmoid function:
f = sigm(linear)
lines(x, f, type="l", col="orange")

## Adding separation between prediction 0 and 1 with a threshold:
# When beta_0 + beta_1 * x = 0 i.e. sigm = 0.5
min_value_for_one = -coef(mylogit)[1]/coef(mylogit)[2] 
abline(v=min_value_for_one, col="orange")

## Prediction of training set
linear = inside_lin_reg(mydata$gre, mylogit)
changed_gre = sigm(linear)
plot(mydata$gre, changed_gre)
abline(h=0.5,col="orange")
idx_no = which(mydata$admit == 0)
idx_yes = which(mydata$admit == 1)
lines(mydata$gre[idx_yes], changed_gre[idx_yes], col="blue", type="p")
lines(mydata$gre[idx_no], changed_gre[idx_no], col="red", type="p")

## Conclusion: classification is working, few misclassified elements.

###########################################################
# 3- Logistic regression in 2D: two inputs and one output #
###########################################################

##
# a/ training model
##
# Trained with glm. We do not detail how it was trained.
mylogit <- glm(admit ~ gre+gpa, data = mydata, family = binomial(logit))

##
# c/ plot fitted sigmoid
##
## Now we plot in 2D, and color indicates whether admitted or not
plot(mydata$gre, mydata$gpa, xlab="gre", ylab="gpa")
idx_no = which(mydata$admit == 0)
idx_yes = which(mydata$admit == 1)
lines(mydata$gre[idx_yes], mydata$gpa[idx_yes], col="blue", type="p")
lines(mydata$gre[idx_no], mydata$gpa[idx_no], col="red", type="p")

## Adding results from model
# The limit is when beta_0 + beta_1 * x + beta_2 * y = 0
# Then y = - beta_0 / beta_2 - (beta_1 / beta_2) *x
abline(a = -coef(mylogit)[1] / coef(mylogit)[3], 
       b = -coef(mylogit)[2] / coef(mylogit)[3], col="orange")

## Coming back to the linear space:
# Points under 0 are classified as 0,
# Points over 0 are classified as 1.
plot(predict.glm(mylogit)[idx_yes], col="blue", 
     ylab = "logistic model before applying sigm")
lines(predict.glm(mylogit)[idx_no], col="red", type="p")
abline(h=0)

######################################################################
# 4- Logistic regression with both continuous and categorical inputs #
######################################################################
# This part is almost 100% from internet, see references in the intro.

mydata <- read.csv(file.path(data_folder, "admission_gre_gpa.csv"))
## view the first few rows of the data
# admit = admit or not in the school
# gre = Graduate Record Exam scores 
# gpa = grade point average
# rank = prestige of undergraduate school (1 = highest prestige)

## two-way contingency table of categorical outcome and predictors we want
## to make sure there are not 0 cells
xtabs(~admit + rank, data = mydata)

# rank should be treated as a categorical variable.
# Note: we do not consider that "rank" is also ordered variable: 1 > 2 > 3 > 4
mydata$rank <- factor(mydata$rank)

# a logistic regression model using the glm (generalized linear model) function
#mylogit <- glm(admit ~ gre + gpa + rank, data = mydata, family = "binomial") # same as the following
mylogit <- glm(admit ~ gre + gpa + rank, data = mydata, family = binomial(logit))

summary(mylogit)

## CIs using profiled log-likelihood
confint(mylogit)

## CIs using standard errors
confint.default(mylogit)

## Effect of gre and rank on admission (with gpa fixed to mean value).
gre_to_predict = rep(seq(from = 200, to = 800, length.out = 100), 4)
rank_to_predict = factor(rep(1:4, each = 100))
newdata2 <- with(mydata, data.frame(gre = gre_to_predict,
                                    gpa = mean(gpa),
                                    rank = rank_to_predict))
newdata3 <- cbind(newdata2, predict(mylogit, newdata = newdata2, 
                                    type = "link", se = TRUE))
newdata3 <- within(newdata3, {
  PredictedProb <- plogis(fit)
  LL <- plogis(fit - (1.96 * se.fit))
  UL <- plogis(fit + (1.96 * se.fit))
})

head(newdata3)

library(ggplot2)
ggplot(newdata3, aes(x = gre, y = PredictedProb)) + 
  geom_ribbon(aes(ymin = LL, ymax = UL, fill = rank), alpha = 0.2) +
  geom_line(aes(colour = rank), size = 1)
