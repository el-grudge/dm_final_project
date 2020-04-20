library(mice)
library(VIM)
library(randomForest)
library(gbm)
library(tidyverse)

# Step 1: Understand the data by studying the reference file “Variables” 
data <- read.csv("data/PHY_TRAIN.csv");
summary(data)

# Step 2: Create missing value indicators for all variables with missing values.  
na_cols <- apply(is.na(data), 2, sum)
na_cols[na_cols > 0]
na_cols <- names(na_cols[na_cols > 0])
na_cols

# get percentage null values by row or column
pMiss <- function(x){sum(is.na(x))/length(x)*100}
na_perc <- apply(data,2,pMiss)
na_perc[na_perc > 0]

# get range values for columns with null values
for (i in 1:length(na_cols)){
  cat(sprintf("\"%s\" \"%s\" \"%s\"\n", na_cols[i], min(data[na_cols[i]][!is.na(data[na_cols[i]])]),
              max(data[na_cols[i]][!is.na(data[na_cols[i]])])))
}

# as shown here, feat29 and feat50 could don't have values, and therefore should be dropped
data <- select(data, -feat29, -feat55)


# Step 3: Missing value imputation is necessary when you use logistic regression to build a model
# using mice to impute the data. parameters
# m = number of imputed datasets to be generated - does not matter here since we are using the mean of the non-na values
# maxit = number of iterations per dataset - does not matter here since we are using the mean of the non-na values
# meth = imputation method
tempData <- mice(data,m=1,maxit=1,meth='mean',seed=500)
summary(tempData)
tempData$imp$feat20
data <- complete(tempData)
# validate
na_cols <- apply(is.na(data), 2, sum)
na_cols[na_cols > 0]
names(na_cols[na_cols > 0])


############
# Step 5: Trees
source('tree_models.R', print.eval=TRUE)