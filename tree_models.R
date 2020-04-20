# create a new target column, with values 'yes'/'no' instead of 0,1
# 0,1 are interpreted as integers, creating a regression tree instead of a classification tree
df_phy <- select(data,-exampleid)
df_phy$phy_target <- factor(ifelse(df_phy$target==0,'No','Yes'))
df_phy <- select(df_phy, -target)

# splitting the datasets
set.seed(2)
train_phy=sample(1:nrow(df_phy), 0.75*nrow(df_phy))
test_phy=df_phy[-train_phy,]
test_target=df_phy$phy_target[-train_phy]


# # basic tree building, with evaluation
# tree_phy=tree(phy_target~.,df_phy,subset=train_phy)
# tree_pred=predict(tree_phy,test_phy,type='class')
# table(tree_pred,test_target)
# (4020+4321)/(4020+1881+2278+4321)
# 
# summary(tree_phy)
# plot(tree_phy)
# text(tree_phy,pretty=0)
# 
# # considering pruning the tree
# # size -> number of terminal nodes
# # dev -> cross.validation error
# # k -> cost complexity parameter
# set.seed(3)
# cv_phy=cv.tree(tree_phy, FUN=prune.misclass)
# names(cv_phy)
# cv_phy
# 
# # plot error rate as a function of size & k
# par(mfrow=c(1,2))
# plot(cv_phy$size, cv_phy$dev, type="b")
# plot(cv_phy$k, cv_phy$dev, type="b")
# 
# # prouning the tree
# prune_phy=prune.misclass(tree_phy, best=2)
# plot(prune_phy)
# text(prune_phy)
# 
# # measuring predictive performance of pruned tree
# test_phy_pruned=predict(prune_phy, test_phy, type='class')
# table(test_phy_pruned, test_target)
# (4020+4321)/(4020+1881+2278+4321) # a tree of size 2 has performs similar to a tree of size 5

############################################################
# bagging and random forest
# randomforest, uses less variables so mtry should be smaller
# mtry (number of featuers considered by model): for regression p=p/3
# mtry (number of featuers considered by model): for classification p=sqrt(p)
#library(randomForest)
set.seed(1)
rf_phy=randomForest(phy_target~.,
                    data=df_phy,
                    subset=train_phy, 
                    mtry=sqrt(length(colnames(df_phy))), 
                    importance=TRUE)
phy_target_rf=predict(rf_phy, newdata=df_phy[-train_phy,])
table(phy_target_rf, test_target)
(4513+4393)/(4513+1809+1785+4393) # a higher accuracy of 71 %

# importance to see importance of each variable
importance(rf_phy)
 
# plotting importance
varImpPlot(rf_phy)
 

############################################################
# boosting
#library(gbm)
set.seed(1)

# use distribution='gaussian' for regression
# use distribution='bernoulli' for classification
# n.trees option sets number of trees
# depth sets limit for each tree
#df_phy$phy_target_bool <- ifelse(df_phy$phy_target=='No',0,1)
boost_phy=gbm(phy_target~.,
              data=df_phy[train_phy,],
              distribution='multinomial',
              n.trees=5000, 
              interaction.depth=4)
boost_phy_summ <- summary(boost_phy)

# partial dependence plots
boost_phy_summ$var
par(mfrow=c(1,2))
plot(boost_phy,i='feat13')
plot(boost_phy,i='feat14')

# using boosted model for prediction
phy_target_boost=predict(boost_phy, 
                         newdata = df_phy[-train_phy,], 
                         n.trees=5000)
table(phy_target_boost, test_target)

# using different value for shrinkage parameter
boost_phy_2 = gbm(phy_target~.,
                  data=df_phy[train_phy,],
                  distribution='multinomial',
                  n.trees=5000, 
                  interaction.depth = 4,
                  shrinkage = 0.2,
                  verbose=F)

phy_target_boost2=predict(boost_phy_2, 
                         newdata = df_phy[-train_phy,], 
                         n.trees=5000)

table(phy_target_boost2, test_target)