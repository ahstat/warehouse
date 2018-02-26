###########################
# Minimal tutorial on LDA #
# 2016/04/13              #
###########################
# Latent Dirichlet Allocation (LDA) is a topic model used in
# Natural Language Processing (NLP).
#
# In part 1, we describe the most simple example with 2 topics,
# In part 2, it is a modified example from a tutorial on r-bloggers.com
library(RTextTools)
library(topicmodels)
set.seed(2713)

##################################
# 1. Own example introducing LDA #
##################################

##
# Inputs
##

## 'data' is the set of documents.
# Each document consists of words.
# Each document has an hidden topic we wish to find.
# In the following example, there are 2 topics: "cat" and "dog".
# We will use LDA model to cluster documents and identify those 2 topics.
data = c("the dog dog the dog woof",
         "cat the cat cat the meow",
         "cat milk cat the milk",
         "dog dog woof",
         "the woof",
         "the cat cat",
         "milk is meow",
         "woof is woof dog",
         "woof the cat",
         "dog meow meow meow meow")
# There are 10 documents, indexed with i
length(data)

# Each document i is indexed word by word using j
# For example, document 3 is "cat milk cat the milk", 
# w_{i,j} = "the" for i = 3, j = 4.
data[3]

## K is the number of topics, indexed with k
# We need to give it to LDA, like for GMM.
# We assume we already know it is 2:
K = 2

# z_{i,j} is the true topic for word j of document i

##
# Prepare and train model
##

## Create the document-term matrix
matrix = create_matrix(cbind(as.vector(data)),
                       language="english", 
                       removeNumbers=TRUE, # remove the numbers
                       stemWords=TRUE) # seeking for radicals of words
                       #weighting) # default is term frequency to weight words 
## Train LDA 
lda <- LDA(matrix, K, control = list(nstart=100)) #, alpha = 0.1

##
# Terms of each topic
##
terms(lda)
# Output as expected:
# Topic 1 Topic 2 
# "cat"   "dog" 

##
# What is the topic of each document
##
topics(lda)
as.vector(terms(lda)[topics(lda)])

# Predicted: "dog" "cat" "cat" "dog" "dog" "cat" "cat" "dog" "cat" "cat"
#   Correct: "dog" "cat" "cat" "dog" "dog" "cat" "cat" "dog" "???" "???"

##
# Estimation of beta
##
# Distribution of words in topic k follows a Dirichlet(beta_k) distribution
posterior(lda)$terms 
#    cat  dog meow milk woof
# 1 0.47 0.00 0.35 0.18 0.00
# 2 0.00 0.54 0.00 0.00 0.46
# (Note that common English words such as "the" have been removed)

##
# Estimation of theta
##
# For a document d, theta_d is the topic distribution 
posterior(lda)$topics
# From this distribution, we can see that topic identification
# for the 2 last documents is not sure. 

#################################
# 2. Tutorial from the internet #
#################################
# http://www.r-bloggers.com/
# getting-started-with-latent-dirichlet-allocation-using-rtexttools-topicmodels
#
# This dataset contains headlines from front-page NYTimes articles. 
# We will take a random sample of 1000 articles for the purposes of 
# this tutorial
data(NYTimes)
data <- NYTimes[sample(1:3104,size=1000,replace=FALSE),]
head(data)
names(data)

# create_matrix is an object of RTextTools
# The purpose is to use it for LDA function.
matrix = create_matrix(cbind(as.vector(data$Title),
                             as.vector(data$Subject)), 
                       language="english", 
                       removeNumbers=TRUE, # remove the numbers
                       stemWords=TRUE) # seeking for radicals of words

# number of topics, already known since already categorized manually
k <- length(unique(data$Topic.Code)) 

# LDA can be run with this number of topics
lda <- LDA(matrix, k)

# Terms of each topic
terms(lda)

# What is the topic of each document
topics(lda)