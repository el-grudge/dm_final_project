# Prediction Accuracy of Different Modeling Approaches on a Supervised 

## Executive Summary

The purpose of this project was to apply several different modeling techniques to a single dataset and analyze the differences in model efficacy.  The data science discipline is both art and science.  For any given dataset multiple models can “work” but this is where the art of data science is applied.  While there are models that tend to perform better as a general rule, it is possible to improve accuracy scores with any given model by applying methods of data preparation.  Our project included missing value imputation, feature selection and reduction, model creation, model analysis, model optimization and comparison of selected fitted models using various comparison statistics. 

## Model Testing and Accuracy

The four basic models that we used were logistic regression without interaction, logistic regression with two-way interactions, random forest and gradient boosting.  In general, simple logistic regression had the worst achieved accuracy of .69 and gradient boosting performed the best, with an achieved accuracy of .72.  However, we were able to slightly improve the accuracy of each of the models by performing basic data preparation and cleansing.  In the end, we selected the gradient boosting model because it presented the highest consistent accuracy and precision.

## Important Feature Determination

The original data set contained 50,000 observations across 80 different features.  In general, feature selection is an exercise in balancing bias and variance; too few features will result in a model that has an increased bias, while too many features will result in increased variance. Additionally, the number of features increases the computational complexity of building any model and so feature reduction, without decreased accuracy, is a desired step.  We decided to execute a series of feature reduction methods to try and determine which features were the most critical to the accuracy of the various models. These feature reduction outcomes included stepwise modeling, multicollinearity analysis, and determining the importance of features by utilizing random forest modeling.  Ultimately, we ended up with 19 features that we determined to be the most important.

## Impact of Important Features on Accuracy

We performed two broad feature reductions.  The first was a reduction to 37 features and the second was a reduction to 19 features.  We found that the reduction in features to 37 resulted in a decrease across almost all performance measurements for all models.  In fact, there was only oneregistered improvement in any measurement following the reduction to 37 features, and that was for the true positive rate for our logistic regression model with two-way interactions.  However, this trend reversed when we performed the final reduction to 19 features.  We saw an improvement to most measurements when modeling using the 19-feature set.  Overall, since the models remained at least as accurate, and in some cases improved, we can determine that these 19 most important features have a positive impact on the accuracy of all the models.

## Introduction

To begin our analysis, we took the raw dataset and imputed missing values (using the feature mean) and removed features that contained no data.  From this new dataset, we ran the various models and recorded the different statistics appropriate to each model.  This established a baseline for us to analyze how feature reduction may or may not affect the accuracy of each individual model.  After this baseline was established, we performed the various feature reduction methods one at a time while recording the impact that these feature reduction steps had on the performance of each of our models.  We then selected a model combined with our ideal feature set size as the final predictive model.

## Methodology

### Data Preparation and Model Testing

We started by importing the data into a dataframe in R and running a summary() function.  This provided us basic information about each feature and was the first step in determining how to perform a basic iteration of data preparation.  Since our first step in this project was to establish a baseline with as many features as possible, we decided to initially only remove the features that had zero variance in their values.  For example, features feat29, feat55, feat51, feat50, feat49, and feat47 all had values of “0” when the summary() function was ran (see Appendix – Table 1). Because these features would not contribute to the overall performance of the model, we removed them prior to running any modeling.  Additionally, we also removed the feature exampleid as it was also a non-contributing feature.  After removing the non-contributing features, we then proceeded to identify columns with missing values and then imputing those values.  The first step was to identify features with missing values and then create missing value indicators for each identified instance.  After the modified dataframe was validated as no longer containing missing values, we then imputed the missing values by using the mean of the feature in question.  We then validated that the derived value was an accurate mean by manually comparing to one of the features.  Following the validation step, we then applied our mean calculation to the entire dataframe and validated that the resultant dataframe contained zero missing values.  The end state dataframe after our initial data preparation and cleansing consisted of 50,000 observations and a feature set of 72.

Following the removal of the non-contributing features and imputation of missing values, we ran the initial logistic regression model with no interaction terms included.  We ran a no-interaction logistic regression model on three different versions of the original data set: a dataset with minimal cleansing (50,000 observations and 72 features), a dataset with feature reduction from random forest analysis combined with VIF multicollinearity analysis (50,000 observations and 37 features) and a dataset with feature reduction from stepwise modeling (50,000 observations and 19 features).  After running the logistic regression modeling on the three different feature sets, we decided that the best feature set to use was the one provided by the stepwise model.  The stepwise model reduced our feature set by 73% and improved the overall performance of the logistic regression model without interactions. 

After establishing a baseline feature set for logistic regression with no interactions, we then proceeded to go through the same process with two-way interactions to see if the results were the same.  The three features we chose for our two-way interactions were feat13, feat66 and feat40. We chose these features as a combination of analysis of the random forest variance importance plot (see Appendix – Figures 8, 9), the multicollinearity of the VIF function and simple trial and error.  What we noticed when we began testing was that simply choosing the three “highest” or “best” features on any single given analysis did not result in the best performing models.  This was confirmed when an analysis of the model showed that our selected features for interaction had a statistically significant p-value (<.05) and therefore were collinear with each other. 

For the random forest model, we again began with the full dataset of 72 features to get baseline performance prior to running the model on feature-optimized datasets.  We did modify the model to provide a ranking of the importance of the features provided to the model.  This importance was ranked in two different ways, by the mean decrease in both Gini and accuracy if this feature were removed from the model.  We used these measurements as a part of our analysis when determining critical features to include in our reduced feature set (see Appendix – Figures 8,9). Our random forest model ultimately performed best on the dataset with all features included.

Lastly, we performed the same three dataset test using the gradient boosting method.  The biggest change we made to the gradient boosting method was the ability to utilize both Out-of-Bag (OOB) and Cross-Validation (CV) estimates to arrive at the optimal number of trees to utilize in the gradient boosting method (see Appendix – Figures 10,11).  The final model that we selected for the gradient boosting method was one that utilized 373 trees, which we found by utilizing the CV estimates. This method using 373 trees performed best on the dataset with 19 features.

## Modeling Performance Measures

We measured each of our models by using five standard performance measures: confusion matrix, accuracy, true positive rate (or sensitivity), false positive rate and precision.  The definitions of these measurements and the results of our models are listed below.

![alt text](./table1.png)

### Logistic Regression with no Interactions

![alt text](./table2.png)

### Logistic Regression with Two-Way Interactions

![alt text](./table3.png)

### Random Forest

![alt text](./table4.png)

### Gradient Boosting

![alt text](./table5.png)

## Model Selection and Reasoning

We used a combination of five different measurements to determine the most effective model for the dataset.  These measurements included accuracy, defined as the number of cases predicted correctly (both positive and negative) divided by the total number of cases; true positive rate (or sensitivity), defined as the total number of correctly predicted positive outcomes over all positive outcomes; false positive rate, defined as the number of incorrect positive predictions over the total number of negative outcomes; and precision, defined as the number of accurately predicted positive results over the total number of positive predictions.  Additionally, we also included the Area Under the Curve (AUC) measurement each model, which is a representation of how capable the model is of distinguishing between the positive class and the negative class.  We only included this measurement for the best performing feature set. 

When attempting to determine which model is “best”, consideration needs to be taken into account as to what the model is measuring.  For example, certain situations may desire a model that minimizes the false positive rate, such as drug screening or other toxicology applications.  Other situations may require a model that maximizes the rate at which the positive outcome is accurately predicted, such environmental testing for toxicants.  Simply put, each situation requires an analysis of the task at hand to decide which measurements should be maximized, or minimized, to receive the label of being “the best”.

In this case, the dataset provided was from a sample derived from a particle physics experiment in 2004.  At its core, the issue was that when these experiments are conducted it is difficult to accurately determine if the particles belong to one of two classes.  To try and solve this problem, 78 features of these particles were provided along with 50,000 observations.  In the realm of hard sciences, accuracy tends to be the most important factor, followed closely by precision; precision comes after accuracy because being precisely wrong is of little to no use.  Also, AUC is also looked at as a measure of how well a model is fit, but in this case we use it as a supporting measurement since accuracy and precision are more important in a problem such as this.  

Using this reasoning, we decided that the best fit model is the gradient boosting model. This model performed best across the 19-feature dataset, but only marginally so as compared to the full 72-feature set.  However, because one aspect of effective model creation is achieving maximum results with the minimum number of features, the ability to reduce the number of features by 73% while also increasing accuracy makes the gradient boost model on the reduced feature set the clear winner.  This model resulted in an accuracy of .725, a true positive rate of .711, a false positive rate of .272, a precision of .72 and an AUC of .855.  

## Conclusion

The process of selecting a model is equal parts art and science.  They are two sides of the same coin and attempting to apply both equally to solving a problem will lead to the best results.  We conducted this experiment for the express purpose of taking a supervised learning dataset and apply four different modeling techniques to see if we could determine which of these four would be the most effective at building a model that could correctly place any given observation into one of two binary classes.  Through a process of data familiarization, feature reduction, multicollinearity analysis, feature importance ranking using random forest modeling, experimentation and analysis, we arrived at the conclusion that the most efficient model was the gradient boosting model ran across an optimized feature set of the 19 most important features.

## Appendix

### ROC Curves for each Model

![alt text](./table6.png)

![alt text](./table7.png)

![alt text](./table8.png)

### Feature Importance, Ranked by Random Forest Model

![alt text](./table9.png)

![alt text](./table10.png)

### Optimal number of Trees for Gradient Boosting

![alt text](./table11.png)

![alt text](./table12.png)


