library(tidyverse)
library(mice)
library(VIM)
library(InformationValue)

# Step 1: Understand the data by studying the reference file “Variables” 
data <- read.csv("C:/Users/Sweet/Desktop/Data Mining/Final/dm_final_project/data/PHY_TRAIN.csv");
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

# as shown here, feat29 and feat55 could don't have values, and therefore should be dropped
data <- select(data, -feat29, -feat55)


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

# Step 4 Logistic Regression without interaction
# Validate if there is target class bias or not
table(data$target)

# Since there is no target bias, split the data into training and test sets
target_ones <- data[which(data$target == 1), ] 
target_zero <- data[which(data$target == 0), ]

set.seed(100)  # set seed for repeatability

# Create training size for both 1 and 0 of 70% target_ones' size
target_ones_training_rows <- sample(1:nrow(target_ones), 0.75*nrow(target_ones))
target_zeros_training_rows <- sample(1:nrow(target_zero), 0.75*nrow(target_ones))

# Create training set for 1 and 0
training_ones <- target_ones[target_ones_training_rows, ]  
training_zeros <- target_zero[target_zeros_training_rows, ]

# Bind 1 and 0 training set into one data frame
trainingData <- rbind(training_ones, training_zeros)

# Create test data set into single data frame
test_ones <- target_ones[-target_ones_training_rows, ]
test_zeros <- target_zero[-target_zeros_training_rows, ]
testData <- rbind(test_ones, test_zeros) 

# Create Logistic Regression model with no interactions
logitMod <- glm(target ~ ., data=trainingData, family=binomial(link="logit"))
predicted <- plogis(predict(logitMod, testData))

# Finding optimal cutoff point for classification 
optCutOff <- optimalCutoff(testData$target, predicted)

# Performing model analysis
misClassError(testData$target, predicted, threshold = optCutOff) # Misclassification Rate
plotROC(testData$target, predicted) # Finding ROC Curve and AUC
Concordance(testData$target, predicted) # Finding concordance
sensitivity(testData$target, predicted, threshold = optCutOff) # Sensitivity; % of 1s accurately predicted
specificity(testData$target, predicted, threshold = optCutOff) # Specificity; % of 0s accurately predicted
confusionMatrix(testData$target, predicted, threshold = optCutOff) # Confusion Matrix; Col = actuals, Row = predicted

