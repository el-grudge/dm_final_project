# Step 2: Create missing value indicators for all variables with missing values.  
# summary statistics
summ_df <- data.frame(summary(data))
summ_df$Var2 <- as.character(summ_df$Var2)
summ_df$Var2 <- sub("^\\s+", "", summ_df$Var2)
summ_df$Freq <- as.character(summ_df$Freq)
summ_df$Freq[is.na(summ_df$Freq)] <- "NA's   :0  "
summ_df <- cbind(summ_df, str_split_fixed(summ_df$Freq, ":", 2))
summ_df <- dplyr::select(summ_df, -Freq, -Var1)
names(summ_df) <- c('Feature', 'Stat', 'Value')
summ_df$Stat <- sub("^\\s+", "", summ_df$Stat)
summ_df$Value <- sub("^\\s+", "", summ_df$Value)
summ_df <- summ_df %>% tidyr::spread(Stat, Value)

skew <- data.frame(moments::skewness(data))
colnames(skew) <- 'Skewness'
skew$Feature <- rownames(skew)
skew[is.na(skew),]$Skewness <- "NA"
summ_df <- dplyr::left_join(summ_df, skew, by='Feature')

write.csv(summ_df, file='summ_df.csv')


# get range values for all columns
for (i in 1:ncol(data)){
  cat(sprintf("\"%s\" \"%s\" \"%s\"\n", colnames(data)[i], min(data[,i]),max(data[,i])))
}

# based on the summary and range values we drop columns 47-51 because they have one value: 0
data <- dplyr::select(data, -feat47, -feat48, -feat49, -feat50, -feat51)

# get columns that have null values
na_cols <- apply(is.na(data), 2, sum)
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
# we're also removing the exampleid feature
data <- dplyr::select(data, -feat29, -feat55, -exampleid)