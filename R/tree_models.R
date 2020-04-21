# Step 5: Trees
# create a new target column, with values 'yes'/'no' instead of 0,1
# 0,1 are interpreted as integers, creating a regression tree instead of a classification tree
df_phy <- select(data,-exampleid)
df_phy$phy_target <- factor(ifelse(df_phy$target==0,'No','Yes'))
df_phy <- select(df_phy, phy_target, everything(), -target)

# splitting the datasets to train (75%) & test (25%)
set.seed(2)
train_phy=sample(1:nrow(df_phy), 0.75*nrow(df_phy))
test_phy=df_phy[-train_phy,]
real_target=df_phy$phy_target[-train_phy]

############################################################
# Random forest
# randomforest, uses less variables so mtry should be smaller
# mtry (number of featuers considered by model): for regression p=p/3
# mtry (number of featuers considered by model): for classification p=sqrt(p)
set.seed(1)
rf_phy=randomForest(phy_target~.,
                    data=df_phy,
                    subset=train_phy,
                    mtry=sqrt(length(colnames(df_phy))),
                    importance=TRUE)
predicted_rf=predict(rf_phy, newdata=df_phy[-train_phy,])
confusion_matrix_rf <- table(predicted_rf, real_target)
confusion_matrix_rf[1]+confusion_matrix_rf[4]/sum(confusion_matrix_rf) # a higher accuracy of 71 %

# importance to see importance of each variable
importance(rf_phy)

# plotting importance
varImpPlot(rf_phy)
############################################################
# boosting
set.seed(1)

# use distribution='gaussian' for regression
# use distribution='bernoulli' for classification
# n.trees option sets number of trees
# depth sets limit for each tree
boost_phy=gbm(phy_target~.,
              data=df_phy[train_phy,],
              distribution='multinomial',
              n.trees=100, 
              interaction.depth=4)
boost_phy_summ <- summary(boost_phy)

# partial dependence plots
boost_phy_summ$var
par(mfrow=c(1,2))
plot(boost_phy,i='feat13')
plot(boost_phy,i='feat14')

# using boosted model for prediction
predicted_boost_1=predict(boost_phy, 
                         newdata = df_phy[-train_phy,], 
                         n.trees=100,
                         type='response')

predicted_boost_1 = colnames(predicted_boost_1)[apply(predicted_boost_1, 1, which.max)]
confusion_matrix_boost1 <- table(predicted_boost_1, real_target)
confusion_matrix_boost1[1]+confusion_matrix_boost1[4]/sum(confusion_matrix_boost1) # slightly better performance of 72.5 %

# using different value for shrinkage parameter
boost_phy_2 = gbm(phy_target~.,
                  data=df_phy[train_phy,],
                  distribution='multinomial',
                  n.trees=100, 
                  interaction.depth = 4,
                  shrinkage = 0.2,
                  verbose=F)

predicted_boost_2=predict(boost_phy_2, 
                         newdata = df_phy[-train_phy,], 
                         n.trees=100,
                         type='response')

predicted_boost_2 = colnames(predicted_boost_2)[apply(predicted_boost_2, 1, which.max)]
confusion_matrix_boost2 <- table(predicted_boost_2, real_target)
confusion_matrix_boost2[1]+confusion_matrix_boost2[4]/sum(confusion_matrix_boost2) # 71.8 % increasing shrinkage parameter has a detrimental effect on performance
