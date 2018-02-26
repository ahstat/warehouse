##############################################
# Multinomial logistic regression with caret #
# 2017/01/05                                 #
##############################################
# Multinomial logistic regression can solve a classification task with:
# - explaining variables = continuous or categorical
# - target = categorical variable with more than 2 classes
#
# Example of target: 3 factors named "0", "1", "2"
#
# References:
# http://hunch.net/~jl/projects/reductions/wap/wap.pdf
# http://www.mit.edu/~9.520/spring09/Classes/multiclass.pdf
# http://stats.stackexchange.com/questions/21343/extending-2-class-models-to-multi-class-problems
# http://stackoverflow.com/questions/15585501/usage-of-caret-with-gbm-method-for-multiclass-classification
library(caret)
library(glmnet)
set.seed(2713)

####################
# Helper functions #
####################
## classify is the following mapping
#      y      classify(y)
#  ]-inf, 0[            1
#    [0, 10]            2
# ]10, +inf[            3
classify = function(y) {
  out = y
  out = ifelse(out < 0, 1, out)
  out = ifelse(out > 10, 3, out)
  out = ifelse(!(out %in% c(1,3)), 2, out)
  return(out)
}

## percentage of misclassified elements
misclassified_rate = function(y_true, y_predicted) {
  mean(y_true != y_predicted)
}

###############
# Sample data #
###############
N = 1000

## Observed features
x1 = rnorm(N, 0, 10)
x2 = rnorm(N, 0, 10)
x = cbind(x1, x2)

## Observed classified objects
eps = rnorm(N, 0, 1)
y = classify(0.75*x1 + 0.25*x2 + eps)

## Final df
df = data.frame(cbind(y, x))
colnames(df) = c("y", "x1", "x2")
df[,1] = factor(df[,1])

# Training and test sets
idx_train = 1:(floor(3*N/4))
idx_test = (floor(3*N/4)):N

## Plot sample data
plot(x1, y)
plot(x2, y)
plot(0.75*x1 + 0.25*x2, y)

##########################################################
# Best prediction we can do in theory, knowing x1 and x2 #
##########################################################
## Best prediction
y_best_prediction = classify(0.75*x1 + 0.25*x2)

## Best theoretical misclassification rate
table(y[idx_test], y_best_prediction[idx_test])
misclassified_rate(y[idx_test], y_best_prediction[idx_test])

###############################################################################
# Training and prediction using glmnet package directly (not the best method) #
###############################################################################
fit = glmnet(x[idx_train,], y[idx_train], family="multinomial")
predicted = predict(fit, newx=x[idx_test,], type="response", s=0.01)
predicted = predicted[,,1]
y_predicted = apply(predicted, 1, which.max)

table(y[idx_test], y_predicted)
misclassified_rate(y[idx_test], y_predicted)

#############################################################
# Training and prediction using caret package (best method) #
#############################################################
fitControl <- trainControl(method="repeatedcv",
                           number=5,
                           repeats=1,
                           verboseIter=FALSE)

fit_caret <- train(y ~ ., data=df[idx_train,],
                   method="glmnet",
                   family = "multinomial",
                   trControl=fitControl)

y_predicted_caret = as.numeric(predict(fit_caret, newdata=x[idx_test,]))
table(y[idx_test], y_predicted_caret)
misclassified_rate(y[idx_test], y_predicted_caret)

###############
# Comparisons #
###############
N # when N increases, misclassification of trained models decreases
misclassified_rate(y[idx_test], y_best_prediction[idx_test]) # 0.03585657
misclassified_rate(y[idx_test], y_predicted) # 0.05976096
misclassified_rate(y[idx_test], y_predicted_caret) # 0.03984064

## Conclusion: In this case, caret gives better results over direct glmnet
# (because of cross validation).
