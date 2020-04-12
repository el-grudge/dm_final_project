# we can see that columns feat29 & feat55 still have null values
# this is one of the limitaions of the mice method, it only deals with quantitative variables
# the good thing about it is that it imputes all the columns in one-go
# we will use the mode to impute the categorical variables
unique(data$feat29)
unique(data$feat55)
