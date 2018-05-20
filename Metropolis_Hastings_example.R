##
# A simple example of Metropolis-Hastings algorithm
# 2016.4.1
##
# This code introduces a simple example of the algorithm, in the case
#   where the instrumental distribution is chosen symmetric.
#
# The aim is to simulate a sample following a distribution (target 
# distribution). Density of this target distribution is only known up to a
# multiplicative constant.
# The idea is to perform simulations through another distribution (instrumental
#   distribution). This instrumental distribution is chosen to be easy to
#   compute. 
# The simulations through the instrumental distribution are "corrected".
#   To do this, we construct a Markov chain which admits a unique
#   stationary distribution which is the target distribution.
#   In practice, steps of the chain follows the instrumental distribution,
#   but step can be rejected with a certain probability.
#
# In this example, we want to simulate a sample of the standard normal
#   distribution knowing that the values are greater than a limit 5. If we
#   want to obtain this sample directly by reject algorithm, most of values
#   are rejected.
library(ggplot2)
set.seed(2713)
limit = 5 # we want to compute N(. | >limit), where N is normal distribution
x_test = rnorm(10000)
max(x_test) # close to 3.5
which(x_test > limit) # no element, all are rejected 

# Therefore, we will use a Metropolis-Hastings algorithm to sample this
#   distribution. To do this, we first need the density of this target
#   distribution up to a constant. This is easily available, by cutting
#   the normal distribution.
# Target density (this density is only known up to a constant)
pi_func0 = function(x, limit) {
  if(x < limit) {
    return(0)
  } else {
    return(dnorm(x, mean = 0, sd = 1))
  }
}
pi_func = function(x) {pi_func0(x, limit)}

# Then, we need an instrumental distribution which can be easily simulated.
#   To simplify computations, we take it symmetric. Here, the normal
#   distribution centered in x and with standard deviation of sd = 0.01 is 
#   chosen. To simulate this distribution is easy.
# Simulation of the instrumental distribution
q_func_symm = function(x, sd = 0.01) {
  y = rnorm(1,x,sd)
  return(y)
}

# The parameter sd indicates the range of each step. When sd is small, each
#   step is small and the probability to be accepted is larger. However, the
#   Markov chain is moving slowly and many steps are necessary to reach
#   stationary distribution. When sd is large, larger steps are done, but are
#   accepted less often.

# The density of the instrumental distribution is not needed here, since
#   the instrumental distribution is symmetric. Another version of Metropolis-
#   Hastings can be done without this assumption of symmetry.

# The step to compute x_{t+1} knowing x_{t} is done in the following function.
#   From the initial x_{t}, we simulate the instrumental distribution q(x).
#   Then we accept it with a probability of alpha(x,q(x)).
iterate_t_to_t_plus_1 = function(x_t, sd) {
  y_t_plus_1 = q_func_symm(x_t, sd)
  alpha_current = alpha(x_t, y_t_plus_1)
  x_t_plus_1 = NA
  if(runif(1) < alpha_current) { # move
    x_t_plus_1 = y_t_plus_1
  } else {
    x_t_plus_1 = x_t
  }
  return(x_t_plus_1)
}

# The probability to accept the move is simply the quotient of probability
#   of the target distribution, since the instrumental distribution is
#   symmetric.
alpha = function(x_t, y_t_plus_1) {
  alpha_out = min(pi_func(y_t_plus_1) / pi_func(x_t), 1)
  return(alpha_out)
}

# Now, we can begin an example of this algorithm.
N = 1000000 # length of the chain
sd = 3 # standard deviation of the steps move
x_1 = limit # initialization of the chain

# x_{t} contains the chain from date 1 to N
x_t_vect = rep(NA, N)
x_t_vect[1] = x_1
for(i in 2:N) {
  if(i %% 10000 == 0) {
    print(i)
  }
  x_t_vect[i] = iterate_t_to_t_plus_1(x_t_vect[i-1], sd)
}

# Two consecutives elements of the chain are correlated. Then, we only
#   consider one element every "step" elements, to get our output sample.
step = 1000
simulated_distr = x_t_vect[seq(from = step, by = step, to = length(x_t_vect))]
# We obtain a sample of length N/step following the normal distribution knowing
#   that values are greater than limit.
#png("metropolis_sample_large.png", 600, 400)
#png("metropolis_sample.png", 375, 375)
qplot(1:length(simulated_distr), simulated_distr, 
      xlab = "Index", ylab = "Sampled element", ylim = c(5, 6.43)) + theme_light()
#dev.off()

# From direct formula (i.e. without Metropolis-Hastings algorithm)
#png("true_sample.png", 375, 375)
N_direct = 1000
set.seed(2713)
simulated_distr_direct = qnorm(pnorm(limit) + runif(N_direct) * (1 - pnorm(limit)))
qplot(1:length(simulated_distr_direct), simulated_distr_direct, 
      xlab = "Index", ylab = "Sampled element", ylim = c(5, 6.43)) + theme_light()
#dev.off()

# We check results by plotting the histogram of our sample, and the
#   density of N(. | >limit) known up to a multiplicative constant. We
#   observe that the shape is similar.
hist(simulated_distr, main = "Histogram of the sample, and true density in red",
     xlab = "value")
x = seq(from=limit, to = limit+1, by = 0.05)
lines(x, 300000000*sapply(x, pi_func), col = "red")
