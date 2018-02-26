library(dplyr)
??dplyr::introduction
# Can be used with data_table, SQL data bases, ...

########
# Data #
########
# Convert df to tbl_df, to prevent printing a lot of data to the screen
library(nycflights13) # a datafrane
dim(flights)
head(flights)

###########################
# Main functions of dplyr #
###########################
# filter() (and slice()),
# arrange(),
# select() (and rename()),
# distinct(),
# mutate() (and transmute()),
# summarise(),
# sample_n() (and sample_frac()).

# General syntax:
# new_dataframe = action(dataframe, what_to_do_on_the_data_frame)

##
# Filter rows: Select a subset of rows in a data frame
##
filter(flights, month == 1, day == 1)
# The same as flights[flights$month == 1 & flights$day == 1, ]
filter(flights, month == 1 | month == 2)

##
# Slice rows: To select rows by position
##
slice(flights, 1:10)
# The same as flights[1:10,]

##
# Arrange rows: To reorder the dataframe
##
arrange(flights, year, month, day)

# Use desc() to order a column in descending order
arrange(flights, year, month, desc(day))
arrange(flights, desc(carrier))

# The same as flights[order(flights$year, flights$month, flights$day), ]
# flights[order(flights$arr_delay, decreasing = TRUE), ] or 
# flights[order(-flights$arr_delay), ]

##
# Select columns: Only select useful features
##
select(flights, year, month, day)
select(flights, year:day) # from year to day, i.e. year, month, day
select(flights, -(year:day))
# With select, there are some options to search specific features 
# (starting_with... ends_with..., matches... contains...)

##
# Rename columns: To rename features
##
rename(flights, deptim_new = dep_time) # renamed = old_name

##
# Extract distinct rows: Like unique() but much faster
##
distinct(flights, tailnum)
distinct(flights, month)

##
# Add new columns with mutate()
##
# Create new columns which are functions of existing columns
a = mutate(flights, gain = arr_delay - dep_delay,
                    speed = distance / air_time * 60)
select(a, carrier, gain:speed)

# You can refer to columns you've just created
a = mutate(flights, gain = arr_delay - dep_delay,
                    gain_per_hour = gain / (air_time / 60))
select(a, carrier, gain:gain_per_hour)

##
# Change a column to another one with transmute()
##
# Like mutate, but here only keep the new variables
transmute(flights, gain = arr_delay - dep_delay,
                   gain_per_hour = gain / (air_time / 60))

##
# Summarise values: Collapse a data frame to a single row
##
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

##
# Randomly sample rows
##
# n elements of the data set
sample_n(flights, 10)

# a fraction of the data set
sample_frac(flights, 0.01)

# We can use replace = TRUE to perform a bootstrap sample.
# We can use a weight argument.

######################
# Grouped operations #
######################
# Using group_by() function to apply the functions to groups of observations
# within a dataset (i.e. a group of rows).
by_tailnum = group_by(flights, tailnum) # group by the individual planes
delay = summarise(by_tailnum, count = n(), # n = the number of obs in the group
                              dist = mean(distance, na.rm = TRUE),
                              delay = mean(arr_delay, na.rm = TRUE))
delay = filter(delay, count > 20, dist < 2000)

# Interestingly, the average delay is only slightly related to the
# average distance flown by a plane.
library(ggplot2)
ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()

# With summarize, you can use the following functions:
# * n() : The number of observations in the current group,
# * n_distinct(x) : The number of unique values in x (With x a feature),
# * first(x) : Work like x[1],
# * last(x) : Work like x[length(x)],
# * nth(x, n) : Work like x[n],
# * The base R functions : min(), max(), mean(), sum(), sd(), median(), IQR(),
# * All functions manually written.
#
# For example:
destinations <- group_by(flights, dest)
summarise(destinations, planes = n_distinct(tailnum),
                        flights = n())

# Rolling up summaries is possible (but be careful for weighting while rolling
# up means, variances...)
daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))

##
# Chaining
##
# The function %>% is like the + in ggplot, to have a more elegant code,
# instead of doing: b = f(a), c = f2(b), d = f3(c) ...
flights %>%
  group_by(year, month, day) %>%
  select(arr_delay, dep_delay) %>%
  summarise(arr = mean(arr_delay, na.rm = TRUE),
            dep = mean(dep_delay, na.rm = TRUE)) %>%
  filter(arr > 30 | dep > 30)
