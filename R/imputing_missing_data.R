# read data
data <- airquality
data[4:10,3] <- rep(NA,7)
data[1:5,4] <- NA

# remove categorical columns, imputing categorical variables is not advisable
data <- data[-c(5,6)]
summary(data)

# get null values by row or column
pMiss <- function(x){sum(is.na(x))/length(x)*100}
apply(data,2,pMiss)
apply(data,1,pMiss)

# load mice package
install.packages("mice")
library(mice)

# visualize missing data - heatmap
md.pattern(data) 

# load VIM package
install.packages("VIM")
library(VIM)

# visualize missing data - barchart, heat map
aggr_plot <- aggr(data, 
                  col=c('navyblue','red'), 
                  numbers=TRUE, 
                  sortVars=TRUE, 
                  labels=names(data), 
                  cex.axis=.7, 
                  gap=3, 
                  ylab=c("Histogram of missing data","Pattern"))

# visualize missing data - boxplot
marginplot(data[c(1,2)])

# normal imputation
data$feat20
non_na_vals <- data$feat20[!is.na(data$feat20)]
data$feat20[c(is.na(data$feat20))] <- mean(non_na_vals)

# view missing data
tempData <- mice(data,m=5,maxit=50,meth='pmm',seed=500)
summary(tempData)

# view available imputation methods
methods(mice)

# view imputed data
tempData$imp$Ozone
tempData$meth

# fill-in the missing data
completedData <- complete(tempData,1)

densityplot(tempData)
