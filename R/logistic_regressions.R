# Step 5.1 Logistic Regression without interaction
# Validate if there is target class bias or not
table(data$target)
data$target <- as.factor(data$target)
split=0.70
trainIndex <- createDataPartition(data$target, p=split, list=FALSE)
data_train <- data[ trainIndex,]
data_test <- data[-trainIndex,]
summary(data)
# Create Logistic Regression model with all features
logitMod <- glm(target ~ ., data=data_train, family=binomial(link="logit"))
predicted <- plogis(predict(logitMod, data_test))

# Finding optimal cutoff point for classification 
optCutOff <- optimalCutoff(data_test$target, predicted)

data_test$predTarget <- NA
data_test$predTarget[predicted < optCutOff] <- 0
data_test$predTarget[predicted > optCutOff] <- 1
data_test$predTarget <- as.factor(data_test$predTarget)

# Analyzing model quality
plotROC(data_test$target, predicted) # Finding ROC Curve and AUC
confusionMatrix(data_test$predTarget, data_test$target, positive="1")



vif(logitMod)

#Step 5.2, Logistic regression with 2-way interactions

twoWayMod <-glm(target ~ .*., data = data_train, family=binomial(link = "logit"))
summary(twoWayMod)

twoWayTest <- glm(target ~ feat13*feat66, data=data_train, family=binomial(link="logit"))
twoWayPredicted <- plogis(predict(twoWayTest, data_test))
sensitivity(data_test$target, twoWayPredicted, threshold = optCutOff)
pR2(twoWayTest)
summary(twoWayTest)