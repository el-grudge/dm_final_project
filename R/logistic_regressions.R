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
InformationValue::sensitivity(testData$target, predicted, threshold = optCutOff) # Sensitivity; % of 1s accurately predicted
InformationValue::specificity(testData$target, predicted, threshold = optCutOff) # Specificity; % of 0s accurately predicted
InformationValue::confusionMatrix(testData$target, predicted, threshold = optCutOff) # Confusion Matrix; Col = actuals, Row = predicted
