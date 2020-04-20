# The tree library
library(tree)

# loading the data
library(ISLR)
attach(Carseats)

# creating a binary variable to be used as a target value
High=ifelse(Sales <=8,"No","Yes")

# merging new binary variable with original dataset
Carseats=data.frame(Carseats,High)

# tree model
tree.carseats=tree(High~.-Sales, Carseats)

# lists the variables that are used as internal nodes in the tree, 
# the number of terminal nodes, 
# and the (training) error rate.
summary(tree.carseats)

# plotting the tree, The argumentpretty=0instructsRto include the category names for any qualitative pre-dictors, 
# rather than simply displaying a letter for each category.
plot(tree.carseats)
text(tree.carseats,pretty=0)

# branch outputs
# the split criterion, 
# the number of observations in that branch, 
# the deviance, 
# the overall predictionfor the branch (Yes or No), 
# and the fraction of observations in that branchthat take on values of Yes and No. 
# Branches that lead to terminal nodes areindicated using asterisks.
c(tree.carseats) # typing the tree object doesn't work as expected !!!

# to properly evaluate the performance, by utilising a train-test split
set.seed(2)
train=length(sample(1:nrow(Carseats), 200))
Carseats.test=Carseats[-train ,]
High.test=High[-train]
tree.carseats=tree(High~.-Sales,Carseats,subset=train)
tree.pred=predict(tree.carseats,Carseats.test,type="class")
table(tree.pred,High.test)
(108+77)/200

# considering pruning the tree
# size -> number of terminal nodes
# dev -> cross.validation error
# k -> cost complexity parameter
set.seed(3)
cv.carseats=cv.tree(tree.carseats, FUN=prune.misclass)
names(cv.carseats)
cv.carseats

# plot error rate as a function of size & k
par(mfrow=c(1,2))
plot(cv.carseats$size, cv.carseats$dev, type="b")
plot(cv.carseats$k, cv.carseats$dev, type="b")

# prouning the tree
prune.carseats=prune.misclass(tree.carseats, best=12)
plot(prune.carseats)
text(prune.carseats)

# measuring predictive performance of pruned tree
tree.pred=predict(prune.carseats, Carseats.test, type='class')
table(tree.pred, High.test)
(108+77)/200

############################################################

# regression trees
library(MASS)
set.seed(1)
train=sample(1:nrow(Boston), nrow(Boston)/2)
tree.boston=tree(medv~.,Boston, subset=train)
summary(tree.boston)
plot(tree.boston)
text(tree.boston,pretty = 0)

# using cv.tree to see whether pruning will imporve performance
cv.boston=cv.tree(tree.boston)
plot(cv.boston$size, cv.boston$dev, type='b')

# pruning the tree
prune.boston=prune.tree(tree.boston, best=5)
plot(prune.boston)
text(prune.boston, pretty = 0)

# use pruned tree to make prediction
yhat=predict(tree.boston, newdata=Boston[-train,])
boston.test=Boston[-train,'medv']
plot(yhat, boston.test)
abline(0,1)

#test mse
mean((yhat-boston.test)^2)

############################################################

# bagging and random forest
# using randonmForest() function for bagging
library(randomForest)
set.seed(1)
bag.boston=randomForest(medv~.,data=Boston, subset=train, mtry=13, importance=TRUE)
bag.boston

# measuring performance on test set
yhat.bag=predict(bag.boston, newdata=Boston[-train,])
plot(yhat.bag, boston.test)
abline(0,1)
mean((yhat.bag-boston.test)^2)

# changing number of trees grown using ntree argument
bag.boston=randomForest(medv~.,data=Boston,subset=train,mtry=13, ntree=25)
yhat.bag=predict(bag.boston, newdata = Boston[-train,])
mean((yhat.bag-boston.test)^2)

# randomforest, uses less variables so mtry should be smaller
# for regression p=p/3
# for classification p=sqrt(p)
set.seed(1)
rf.boston=randomForest(medv~.,data=Boston,subset=train, mtry=6, importance=TRUE)
yhat.rf=predict(rf.boston, newdata=Boston[-train,])
mean((yhat-boston.test)^2)

# importance to see importance of each variable
importance(rf.boston)

# plotting importance
varImpPlot(rf.boston)

############################################################
# boosting
library(gbm)
set.seed(1)

# use distribution='gaussian' for regression
# use distribution='bernoulli' for classification
# n.trees option sets number of trees
# depth sets limit for each tree
boost.boston=gbm(medv~.,data=Boston[train,],distribution='gaussian',n.trees=5000, interaction.depth=4)
summary(boost.boston)

# partial dependence plots
par(mfrow=c(1,2))
plot(boost.boston,i='rm')
plot(boost.boston,i='lstat')

# using boosted model for prediction
yhat.boost=predict(boost.boston, newdata = Boston[-train,],
                   n.trees=5000)
mean((yhat.boost-boston.test)^2)

# using different value for shrinkage parameter
boost.boston = gbm(medv~.,data=Boston[train,],distribution='gaussian',
                   n.trees=5000, interaction.depth = 4,shrinkage = 0.2,verbose=F)
yhat.boost=predict(boost.boston, newdata=Boston[-train,],n.trees=5000)
mean((yhat.boost-boston.test)^2)
