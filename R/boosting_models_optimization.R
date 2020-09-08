# Train with a n.trees large number of trees, and compare OOB & CV to determine best b.trees
# Model 1: Will be measured using out-of-bag performance
boost_phy_oob=gbm(target~.,
                  data=train_boost,
                  distribution='bernoulli',
                  n.trees=500,
                  interaction.depth=4)

# Model 2: Will be measured using cross validation performance
boost_phy_cv=gbm(target~.,
                 distribution='bernoulli',
                 data=train_boost,
                 n.trees=500,
                 cv.folds=3,
                 interaction.depth=4)

# Measuring model 1 using OOB
ntree_opt_oob <- gbm.perf(object = boost_phy_oob, 
                          method = 'OOB')

# Measuring model 2 using CV
ntree_opt_cv <- gbm.perf(object = boost_phy_cv, 
                          method = 'cv')

# Top features
par(mfrow=c(1,2))
boost_phy_summ_oob <- summary(boost_phy_oob)
boost_phy_summ_cv <- summary(boost_phy_cv)

compare_ft_imp <- data.frame(cbind(boost_phy_summ_oob,boost_phy_summ_cv))
rownames(compare_ft_imp) <- seq(1:nrow(x))
colnames(compare_ft_imp) <- c('OOB_Feature', 'OOB_Importance', 'CV_Feature', 'CV_Importance')
compare_ft_imp$similar_rank <- ifelse(boost_phy_summ_oob$var == boost_phy_summ_cv$var, 'yes', 'no')
write.csv(compare_ft_imp, file='comparison.csv')

# partial dependence plots
# OOB
boost_phy_summ_oob$var
par(mfrow=c(1,1))
plot(boost_phy_oob,i=rownames(boost_phy_summ_oob)[1])
plot(boost_phy_oob,i=rownames(boost_phy_summ_oob)[2])

# CV
boost_phy_summ_cv$var
par(mfrow=c(1,2))
plot(boost_phy_cv,i=rownames(boost_phy_summ_cv)[1])
plot(boost_phy_cv,i=rownames(boost_phy_summ_cv)[2])

# Predicting
# OOB Prediction
predict_boost_oob <- predict.gbm(boost_phy_oob, 
                                 newdata = test_boost, 
                                 n.trees=500,
                                 type='response')

predict_boost_oob_opt <- predict.gbm(boost_phy_oob, 
                                 newdata = test_boost, 
                                 n.trees=ntree_opt_oob,
                                 type='response')

# CV Prediction
predict_boost_cv <- predict.gbm(boost_phy_cv, 
                                 newdata = test_boost, 
                                 n.trees=500,
                                 type='response')

predict_boost_cv_opt <- predict.gbm(boost_phy_cv, 
                                newdata = test_boost, 
                                n.trees=ntree_opt_cv,
                                type='response')

# Confustion Matrix
# OOB
confusion_boost_oob <- InformationValue::confusionMatrix(ifelse(predict_boost_oob > 0.5,1,0),real_target_boost)
confusion_boost_oob_opt <- InformationValue::confusionMatrix(ifelse(predict_boost_oob_opt > 0.5,1,0),real_target_boost)

# CV
confusion_boost_cv <- InformationValue::confusionMatrix(ifelse(predict_boost_cv > 0.5,1,0),real_target_boost)
confusion_boost_cv_opt <- InformationValue::confusionMatrix(ifelse(predict_boost_cv_opt > 0.5,1,0),real_target_boost)

# Metrics
# OOB
cat(sprintf("Accuracy (500 trees)= \"%s\"",
            (confusion_boost_oob['0','0']+confusion_boost_oob['1','1'])/sum(confusion_boost_oob))) # a higher accuracy of 0.69168

cat(sprintf("Accuracy (optimal OOB n.trees)= \"%s\"",
            (confusion_boost_oob_opt['0','0']+confusion_boost_oob_opt['1','1'])/sum(confusion_boost_oob_opt))) # a higher accuracy of 0.69168


cat(sprintf("AUC (500 trees)= \"%s\"",
            ModelMetrics::auc(modelObject=boost_phy_oob, actual = as.numeric(as.character(real_target_boost)), 
                              predicted = as.numeric(as.character(predict_boost_oob))))) # AUC = "0.781921870028507"

cat(sprintf("AUC  (optimal OOB n.trees)= \"%s\"",
            ModelMetrics::auc(modelObject=boost_phy_oob, actual = as.numeric(as.character(real_target_boost)), 
                              predicted = as.numeric(as.character(predict_boost_oob_opt))))) # AUC = "0.781921870028507"

# CV
cat(sprintf("Accuracy (500 trees with CV)= \"%s\"",
            (confusion_boost_cv['0','0']+confusion_boost_cv['1','1'])/sum(confusion_boost_cv))) # a higher accuracy of 0.69168

cat(sprintf("Accuracy (optimal n.trees with CV)= \"%s\"",
            (confusion_boost_cv_opt['0','0']+confusion_boost_cv_opt['1','1'])/sum(confusion_boost_cv_opt))) # a higher accuracy of 0.69168

cat(sprintf("AUC (500 trees with CV)= \"%s\"",
            ModelMetrics::auc(modelObject=boost_phy_cv, actual = as.numeric(as.character(real_target_boost)), 
                              predicted = as.numeric(as.character(predict_boost_cv))))) # AUC = "0.781921870028507"

cat(sprintf("AUC (optimal n.trees with CV)= \"%s\"",
            ModelMetrics::auc(modelObject=boost_phy_cv, actual = as.numeric(as.character(real_target_boost)), 
                              predicted = as.numeric(as.character(predict_boost_cv_opt))))) # AUC = "0.781921870028507"

# ROC Boost
# OOB 500 trees
plotROC(
  real_target_boost,
  predict_boost_oob
)

# OOB optimal trees
plotROC(
  real_target_boost,
  predict_boost_oob_opt
)

# CV 500 trees
plotROC(
  real_target_boost,
  predict_boost_cv
)

# CV optimal trees
plotROC(
  real_target_boost,
  predict_boost_cv_opt
)
