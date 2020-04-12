expl_vec1 <- c(4, 8, 12, NA, 99, - 20, NA) # Create your own example vector with NA's

is.na(expl_vec1) # The is.na() function returns a logical vector. The vector is TRUE in case
# of a missing value and FALSE in case of an observed value
which(is.na(expl_vec1)) # The which() function returns the positions with missing values in your vector.
# In our case there are NA's at positions 4 & 7
### [1] 4 7


expl_data1 <- data.frame(x1 = c(NA, 7, 8, 9, 3), # Numeric variable with one missing value
                         x2 = c(4, 1, NA, NA, 4), # Numeric variable with two missing values
                         x3 = c(1, 4, 2, 9, 6), # Numeric variable without any missing values
                         x4 = c("Hello", "I am not NA", NA, "I love R", NA)) # Factor variable with
# two missing values
expl_data1 # This is how our data with missing values looks like


which(is.na(expl_data1$x1)) # Same procedure as in Example 1, but this time with the column of a data frame;
# Missing value in x1 at position 1
which(is.na(expl_data1$x2)) # Variable x2 has missing values at positions 3 and 4
which(is.na(expl_data1$x3)) # The variable x3 in column 3 has no missing values
which(is.na(expl_data1$x4)) # Our factor variable x4 in column 4 has missing values at positions 3 and 5;
# The same procedure can be applied to factors


# As in Example one, you can create a data frame with logical TRUE and FALSE values; 
# Indicating observed and missing values
is.na(expl_data1)
apply(is.na(expl_data1), 2, which) # In order to get the positions of each column in your data set,
# you can use the apply() function


# Create matrix on the basis of the first three columns of our example data of Example 2
expl_matrix1 <- as.matrix(expl_data1[ , 1:3])
expl_matrix1

which(is.na(expl_matrix1[ , 1])) # The $ operator is invalid for columns of matrices.
# Therefore we have to select our matrix columns by squared brackets 
which(is.na(expl_matrix1[ , 2])) # Beside the change from the $ operator to squared brackets,
# we can apply the same functions as in the other examples
which(is.na(expl_matrix1[ , 3])) # Again, no missing values in x3


# We can check the missing values of the whole matrix with the same procedure as in Example 3
apply(is.na(expl_matrix1), 2, which)


# An alternative to the is.na() function is the function complete.cases(),
# which searches for observed values instead of missing values
which(complete.cases(expl_vec1)) # Identify observed values (opposite result as in Example 1)
which(complete.cases(expl_vec1) == FALSE) # Reproduce result of Example 1 by adding == FALSE
complete.cases(expl_data1) # If a data frame or matrix is checked by complete.case(),
# the function returns a logical vector indicating whether a row is complete


# With the sum() and the is.na() functions you can find the number of missing values in your data
sum(is.na(expl_vec1)) # Two missings in our vector
sum(is.na(expl_data1)) # The same method works for the whole data frame; Five missings overall
sum(is.na(expl_matrix1)) # The procedure works also for matrices; The NA count is three in our case


