# loading libraries
source('R/libraries.R')

# Step 1: Understand the data by studying the reference file “Variables” 
data <- read.csv("data/PHY_TRAIN.csv")

# Step 2: Create missing value indicators for all variables with missing values.  
source('R/creating_missing_values.R', print.eval=TRUE)

# Step 3: Missing value imputation is necessary when you use logistic regression to build a model
source('R/missing_value_imputation.R', print.eval=TRUE)

  # Step 4 Logistic Regression without interaction
#source('R/logistic_regressions.R', print.eval=TRUE)

# Step 5: Trees
source('R/tree_models.R', print.eval=TRUE)

