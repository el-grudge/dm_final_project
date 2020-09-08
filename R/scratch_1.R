##########################################################################################################
# SCRATCH
# we can see that columns feat29 & feat55 still have null values
# this is one of the limitaions of the mice method, it only deals with quantitative variables
# the good thing about it is that it imputes all the columns in one-go
# we will use the mode to impute the categorical variables
# unique(data$feat29)
# unique(data$feat55)

##########################################################################################################
##########################################################################################################
# RETRIEVE NULL VALUES TUTORIAL
# expl_vec1 <- c(4, 8, 12, NA, 99, - 20, NA) # Create your own example vector with NA's
# 
# is.na(expl_vec1) # The is.na() function returns a logical vector. The vector is TRUE in case
# # of a missing value and FALSE in case of an observed value
# which(is.na(expl_vec1)) # The which() function returns the positions with missing values in your vector.
# # In our case there are NA's at positions 4 & 7
# ### [1] 4 7
# 
# 
# expl_data1 <- data.frame(x1 = c(NA, 7, 8, 9, 3), # Numeric variable with one missing value
#                          x2 = c(4, 1, NA, NA, 4), # Numeric variable with two missing values
#                          x3 = c(1, 4, 2, 9, 6), # Numeric variable without any missing values
#                          x4 = c("Hello", "I am not NA", NA, "I love R", NA)) # Factor variable with
# # two missing values
# expl_data1 # This is how our data with missing values looks like
# 
# 
# which(is.na(expl_data1$x1)) # Same procedure as in Example 1, but this time with the column of a data frame;
# # Missing value in x1 at position 1
# which(is.na(expl_data1$x2)) # Variable x2 has missing values at positions 3 and 4
# which(is.na(expl_data1$x3)) # The variable x3 in column 3 has no missing values
# which(is.na(expl_data1$x4)) # Our factor variable x4 in column 4 has missing values at positions 3 and 5;
# # The same procedure can be applied to factors
# 
# 
# # As in Example one, you can create a data frame with logical TRUE and FALSE values; 
# # Indicating observed and missing values
# is.na(expl_data1)
# apply(is.na(expl_data1), 2, which) # In order to get the positions of each column in your data set,
# # you can use the apply() function
# 
# 
# # Create matrix on the basis of the first three columns of our example data of Example 2
# expl_matrix1 <- as.matrix(expl_data1[ , 1:3])
# expl_matrix1
# 
# which(is.na(expl_matrix1[ , 1])) # The $ operator is invalid for columns of matrices.
# # Therefore we have to select our matrix columns by squared brackets 
# which(is.na(expl_matrix1[ , 2])) # Beside the change from the $ operator to squared brackets,
# # we can apply the same functions as in the other examples
# which(is.na(expl_matrix1[ , 3])) # Again, no missing values in x3
# 
# 
# # We can check the missing values of the whole matrix with the same procedure as in Example 3
# apply(is.na(expl_matrix1), 2, which)
# 
# 
# # An alternative to the is.na() function is the function complete.cases(),
# # which searches for observed values instead of missing values
# which(complete.cases(expl_vec1)) # Identify observed values (opposite result as in Example 1)
# which(complete.cases(expl_vec1) == FALSE) # Reproduce result of Example 1 by adding == FALSE
# complete.cases(expl_data1) # If a data frame or matrix is checked by complete.case(),
# # the function returns a logical vector indicating whether a row is complete
# 
# 
# # With the sum() and the is.na() functions you can find the number of missing values in your data
# sum(is.na(expl_vec1)) # Two missings in our vector
# sum(is.na(expl_data1)) # The same method works for the whole data frame; Five missings overall
# sum(is.na(expl_matrix1)) # The procedure works also for matrices; The NA count is three in our case
# 
# 
##########################################################################################################
##########################################################################################################
# IMPUTING MISSING VALUES TUTORILA
# # read data
# data <- airquality
# data[4:10,3] <- rep(NA,7)
# data[1:5,4] <- NA
# 
# # remove categorical columns, imputing categorical variables is not advisable
# data <- data[-c(5,6)]
# summary(data)
# 
# # get null values by row or column
# pMiss <- function(x){sum(is.na(x))/length(x)*100}
# apply(data,2,pMiss)
# apply(data,1,pMiss)
# 
# # load mice package
# install.packages("mice")
# library(mice)
# 
# # visualize missing data - heatmap
# md.pattern(data) 
# 
# # load VIM package
# install.packages("VIM")
# library(VIM)
# 
# # visualize missing data - barchart, heat map
# aggr_plot <- aggr(data, 
#                   col=c('navyblue','red'), 
#                   numbers=TRUE, 
#                   sortVars=TRUE, 
#                   labels=names(data), 
#                   cex.axis=.7, 
#                   gap=3, 
#                   ylab=c("Histogram of missing data","Pattern"))
# 
# # visualize missing data - boxplot
# marginplot(data[c(1,2)])
# 
# # normal imputation
# data$feat20
# non_na_vals <- data$feat20[!is.na(data$feat20)]
# data$feat20[c(is.na(data$feat20))] <- mean(non_na_vals)
# 
# # view missing data
# tempData <- mice(data,m=5,maxit=50,meth='pmm',seed=500)
# summary(tempData)
# 
# # view available imputation methods
# methods(mice)
# 
# # view imputed data
# tempData$imp$Ozone
# tempData$meth
# 
# # fill-in the missing data
# completedData <- complete(tempData,1)
# 
# densityplot(tempData)
##########################################################################################################
# # ##########################################################################################################
# # DECISION TREE TUTORIAL ISLR
# 
# # The tree library
# library(tree)
# 
# # loading the data
# library(ISLR)
# attach(Carseats)
# 
# # creating a binary variable to be used as a target value
# High=ifelse(Sales <=8,"No","Yes")
# 
# # merging new binary variable with original dataset
# Carseats=data.frame(Carseats,High)
# 
# # tree model
# tree.carseats=tree(High~.-Sales, Carseats)
# 
# # lists the variables that are used as internal nodes in the tree,
# # the number of terminal nodes,
# # and the (training) error rate.
# summary(tree.carseats)
# 
# # plotting the tree, The argumentpretty=0instructsRto include the category names for any qualitative pre-dictors,
# # rather than simply displaying a letter for each category.
# plot(tree.carseats)
# text(tree.carseats,pretty=0)
# 
# # branch outputs
# # the split criterion,
# # the number of observations in that branch,
# # the deviance,
# # the overall predictionfor the branch (Yes or No),
# # and the fraction of observations in that branchthat take on values of Yes and No.
# # Branches that lead to terminal nodes areindicated using asterisks.
# c(tree.carseats) # typing the tree object doesn't work as expected !!!
# 
# # to properly evaluate the performance, by utilising a train-test split
# set.seed(2)
# train=length(sample(1:nrow(Carseats), 200))
# Carseats.test=Carseats[-train ,]
# High.test=High[-train]
# tree.carseats=tree(High~.-Sales,Carseats,subset=train)
# tree.pred=predict(tree.carseats,Carseats.test,type="class")
# table(tree.pred,High.test)
# (108+77)/200
# 
# # considering pruning the tree
# # size -> number of terminal nodes
# # dev -> cross.validation error
# # k -> cost complexity parameter
# set.seed(3)
# cv.carseats=cv.tree(tree.carseats, FUN=prune.misclass)
# names(cv.carseats)
# cv.carseats
# 
# # plot error rate as a function of size & k
# par(mfrow=c(1,2))
# plot(cv.carseats$size, cv.carseats$dev, type="b")
# plot(cv.carseats$k, cv.carseats$dev, type="b")
# 
# # prouning the tree
# prune.carseats=prune.misclass(tree.carseats, best=12)
# plot(prune.carseats)
# text(prune.carseats)
# 
# # measuring predictive performance of pruned tree
# tree.pred=predict(prune.carseats, Carseats.test, type='class')
# table(tree.pred, High.test)
# (108+77)/200
# 
# ############################################################
# 
# # regression trees
# library(MASS)
# set.seed(1)
# train=sample(1:nrow(Boston), nrow(Boston)/2)
# tree.boston=tree(medv~.,Boston, subset=train)
# summary(tree.boston)
# plot(tree.boston)
# text(tree.boston,pretty = 0)
# 
# # using cv.tree to see whether pruning will imporve performance
# cv.boston=cv.tree(tree.boston)
# plot(cv.boston$size, cv.boston$dev, type='b')
# 
# # pruning the tree
# prune.boston=prune.tree(tree.boston, best=5)
# plot(prune.boston)
# text(prune.boston, pretty = 0)
# 
# # use pruned tree to make prediction
# yhat=predict(tree.boston, newdata=Boston[-train,])
# boston.test=Boston[-train,'medv']
# plot(yhat, boston.test)
# abline(0,1)
# 
# #test mse
# mean((yhat-boston.test)^2)
# 
# ############################################################
# 
# # bagging and random forest
# # using randonmForest() function for bagging
# library(randomForest)
# set.seed(1)
# bag.boston=randomForest(medv~.,data=Boston, subset=train, mtry=13, importance=TRUE)
# bag.boston
# 
# # measuring performance on test set
# yhat.bag=predict(bag.boston, newdata=Boston[-train,])
# plot(yhat.bag, boston.test)
# abline(0,1)
# mean((yhat.bag-boston.test)^2)
# 
# # changing number of trees grown using ntree argument
# bag.boston=randomForest(medv~.,data=Boston,subset=train,mtry=13, ntree=25)
# yhat.bag=predict(bag.boston, newdata = Boston[-train,])
# mean((yhat.bag-boston.test)^2)
# 
# # randomforest, uses less variables so mtry should be smaller
# # for regression p=p/3
# # for classification p=sqrt(p)
# set.seed(1)
# rf.boston=randomForest(medv~.,data=Boston,subset=train, mtry=6, importance=TRUE)
# yhat.rf=predict(rf.boston, newdata=Boston[-train,])
# mean((yhat-boston.test)^2)
# 
# # importance to see importance of each variable
# importance(rf.boston)
# 
# # plotting importance
# varImpPlot(rf.boston)
# 
# ############################################################
# # boosting
# library(gbm)
# set.seed(1)
# 
# # use distribution='gaussian' for regression
# # use distribution='bernoulli' for classification
# # n.trees option sets number of trees
# # depth sets limit for each tree
# boost.boston=gbm(medv~.,data=Boston[train,],distribution='gaussian',n.trees=5000, interaction.depth=4)
# summary(boost.boston)
# 
# # partial dependence plots
# par(mfrow=c(1,2))
# plot(boost.boston,i='rm')
# plot(boost.boston,i='lstat')
# 
# names(Boston)
# hist(Boston$medv,
#      breaks=15)
# 
# hist(yhat.boost,
#      breaks=15)
# 
# # using boosted model for prediction
# yhat.boost=predict(boost.boston, newdata = Boston[-train,],
#                    n.trees=5000)
# mean((yhat.boost-boston.test)^2)
# 
# # using different value for shrinkage parameter
# boost.boston = gbm(medv~.,data=Boston[train,],distribution='gaussian',
#                    n.trees=5000, interaction.depth = 4,shrinkage = 0.2,verbose=F)
# yhat.boost=predict(boost.boston, newdata=Boston[-train,],n.trees=5000)
# mean((yhat.boost-boston.test)^2)
# ##########################################################################################################
# partialPlot(boost.boston, pred.data=Boston[-train,], x.var='lstat')
# partialPlot(rf.boston, pred.data=Boston[-train,], x.var='lstat')
# attach(Boston)
# library(pdp)
# partial(rf.boston, pred.var = "lstat", plot = TRUE, rug = TRUE)
# partial(boost.boston, 
#         pred.var = "lstat", 
#         plot = TRUE, 
#         train=Boston, 
#         n.trees=5000)
# 
# partial(boost_phy, 
#         pred.var = "feat13", 
#         type='classification',
#         plot = TRUE, 
#         train=df_phy, 
#         n.trees=100)
# 
# partial(boost_phy, 
#         pred.var = "feat63", 
#         type='classification',
#         plot = TRUE, 
#         train=df_phy, 
#         n.trees=100)
# 
# 
# 
# 
# %>%
#   plotPartial(smooth=TRUE,
#               train=Boston[train,], 
#               rug=TRUE,
#               lwd=2)
# partial(pred.var = "lat", plot=FALSE, train = ceta_dd_final, n.trees = 2400) %>%
#   plotPartial(smooth = TRUE, train = ceta_dd_final, rug = TRUE,
#               lwd = 2, ylab = expression(f(lat)))
# 
# gpb
# 
# # cat(sprintf("AUC = \"%s\"", ModelMetrics::auc(modelObject=rf_phy, actual = as.numeric(as.character(real_target_rf)), 		 predicted = as.numeric(as.character(predicted_rf)))))
# # cat(sprintf("AUC = \"%s\"", ModelMetrics::auc(modelObject=rf_phy, actual = as.numeric(as.character(real_target_boost)), predicted = as.numeric(as.character(predict_boost_1)))))
# # 
# # ModelMetrics::auc(modelObject=rf_phy, actual = as.numeric(as.character(real_target_rf)), 		 predicted = as.numeric(as.character(predicted_rf)))
# # ModelMetrics::auc(modelObject=rf_phy, actual = as.numeric(as.character(real_target_boost)), predicted = as.numeric(as.character(predict_boost_1)))