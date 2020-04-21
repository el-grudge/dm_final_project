# Step 3: Missing value imputation is necessary when you use logistic regression to build a model
# using mice to impute the data. parameters
# m = number of imputed datasets to be generated - does not matter here since we are using the mean of the non-na values
# maxit = number of iterations per dataset - does not matter here since we are using the mean of the non-na values
# meth = imputation method
tempData <- mice(data,m=1,maxit=1,method ='mean',seed=500)
summary(tempData)
tempData$imp$feat20
data <- complete(tempData)
# validate
na_cols <- apply(is.na(data), 2, sum)
na_cols[na_cols > 0]
names(na_cols[na_cols > 0])
