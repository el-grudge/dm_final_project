# Step 2: Create missing value indicators for all variables with missing values.  
na_cols <- apply(is.na(data), 2, sum)
na_cols[na_cols > 0]
na_cols <- names(na_cols[na_cols > 0])
na_cols

# get percentage null values by row or column
pMiss <- function(x){sum(is.na(x))/length(x)*100}
na_perc <- apply(data,2,pMiss)
na_perc[na_perc > 0]

# get range values for columns with null values
for (i in 1:length(na_cols)){
  cat(sprintf("\"%s\" \"%s\" \"%s\"\n", na_cols[i], min(data[na_cols[i]][!is.na(data[na_cols[i]])]),
              max(data[na_cols[i]][!is.na(data[na_cols[i]])])))
}

# as shown here, feat29 and feat55 could don't have values, and therefore should be dropped
data <- select(data, -feat29, -feat55)
