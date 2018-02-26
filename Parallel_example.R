###########################################################
# Smallest example of parallel computation using snowfall #
# 2016/09/12                                              #
###########################################################
library(snowfall)

##############
# Parameters #
##############
## Whether we want to use parallel computations
parallel = TRUE

## Number of cores to use
nb_cores = 4

## Which function we wish to compute?
# Note: In practice f must be complex, not a 'for loop' like here.
# Complex means such that we cannot use 'sapply' directly.
# With non complex functions, computations can be even slower in parallel...
f = function(x) {
  k_max = 1e7
  for(k in 1:k_max) {
    x = x + (-1)^k * log(k)
  }
  return(x)
}

## How to cut this function into nb_cores parts?
f_i = function(x, i, nb_cores) {
  if(nb_cores > 1) {
    cut_x = cut(x, nb_cores, labels = FALSE)
  } else {
    cut_x = rep(1, length(x))
  }
  x = x[which(cut_x == i)]
  f(x)
}

########
# Data #
########
x = 1:100

################
# Computations #
################
# In Windows, you can check CPU usage from Windows Task Manager
if(parallel == FALSE || nb_cores == 1) {
  # Only one big part if non parallel computations
  nb_cores = 1
  i = 1
  out = f_i(x, i, nb_cores)
} else {
  # Init parallelization with explicit settings.
  sfInit(parallel = TRUE, 
         cpus = nb_cores,
         slaveOutfile = file.path("logfile.txt"))
  
  # Check if it is correctly initialized
  if(sfParallel()) {
    cat("Running in parallel mode on", sfCpus(), "nodes.\n")
  } else {
    cat("Running in sequential mode.\n")
  }
  
  # List objects on each node (for now, nothing in each core)
  # sfClusterEval(ls())
  
  # Load snowfall package into global environment
  # (in this toy example, we do not need any additional package)
  sfLibrary("snowfall", character.only = TRUE)
  sfLibrary("data.table", character.only = TRUE)
  sfLibrary("magrittr", character.only = TRUE)
  sfLibrary("dplyr", character.only = TRUE)
  # Load some variables of data.table into global environment
  # data.table = data.table
  # '%>%' = dplyr::`%>%`
  # mutate = mutate
  
  # Export all global objects
  sfExportAll()
  
  # # List objects on each node
  # sfClusterEval(ls())
  
  # Calc something with parallel sfLappy
  out = sfLapply(1:nb_cores, function(i) {f_i(x, i, nb_cores)})
  
  # Remove all variables
  sfRemoveAll()
  
  # Close all the connections
  sfStop()
}

###########
# Results #
###########
out = unlist(out)
print(out)
