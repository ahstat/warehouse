###
# Three ways to sample logistic and probit distributions
#
# In all cases, the model is of the form:
#     E(Y) = g^{-1}(ax+b),
# where Y is a Bernoulli distribution.
#
# For the logistic model, we take g as the sigmoid function.
# For the probit model, we take g as the Normal probability distribution.
###

##
# Define x values, and parameters of the model
##
n = 100000
x = runif(n, -4, 4)

a = 3
b = 4

## Method 1
# https://en.wikipedia.org/wiki/Logistic_regression 
# (section Latent variable interpretation)
eps = rlogis(n, 0, 1) # logistic model
y_logis1 = ifelse(a*x + b + eps > 0, 1, 0)

eps = rnorm(n, 0, 1) # probit model
y_probit1 = ifelse(a*x + b + eps > 0, 1, 0)

## Method 2
# https://stats.stackexchange.com/questions/20523/difference-between-logit-and-probit-models
y_probit2 = rbinom(n, size=1, prob=pnorm(a*x+b, sd=1))
y_logis2 = rbinom(n, size=1, prob=plogis(a*x+b, scale=1))

## Method 3
# From the definition in the GLM
U = runif(n)
y_logis3 = ifelse(U < plogis(a*x+b), 1, 0)
y_probit3 = ifelse(U < pnorm(a*x+b), 1, 0)

##
# Verification that sample is correct
##
plot_empirical_distribution = function(x, y, nb_cuts = 100,
                                       comparison = plogis) {
  # comparison should be plogis or pnorm.
  # plogis(x) is simply sigmoid(x) = 1/(1+exp(-x))
  cuts = cut(x, nb_cuts, labels = FALSE)
  xval = quantile(x, probs = (1:nb_cuts)/nb_cuts)
  empiric = sapply(1:nb_cuts, function(i){mean(y[which(cuts == i)])})
  plot(xval, empiric, main = "Empirical and true distribution function",
       xlab = "x", ylab = "P(X<x)")
  lines(xval, comparison(a*xval+b), col = "red")
}

plot_empirical_distribution(x, y_logis1, comparison = plogis)
plot_empirical_distribution(x, y_logis2, comparison = plogis)
plot_empirical_distribution(x, y_logis3, comparison = plogis)

plot_empirical_distribution(x, y_probit1, comparison = pnorm)
plot_empirical_distribution(x, y_probit2, comparison = pnorm)
plot_empirical_distribution(x, y_probit3, comparison = pnorm)

##
# Verification of the coefficients
##
logitModel1 = glm(y_logis1~x, family=binomial(link="logit"))
logitModel2 = glm(y_logis2~x, family=binomial(link="logit"))
logitModel3 = glm(y_logis3~x, family=binomial(link="logit"))

probitModel1 = glm(y_probit1~x, family=binomial(link="probit"))
probitModel2 = glm(y_probit2~x, family=binomial(link="probit"))
probitModel3 = glm(y_probit3~x, family=binomial(link="probit"))

summary(logitModel1)
summary(logitModel2)
summary(logitModel3)

summary(probitModel1)
summary(probitModel2)
summary(probitModel3)