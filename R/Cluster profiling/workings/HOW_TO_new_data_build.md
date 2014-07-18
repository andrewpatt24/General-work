Building new data for profiling
========================================================

This is a document to walkthough how to build a dataset for a new a profiling app. The app is built, that given the right data, will automatically update so no need for editing.

We are going to work with our first profiling: Techy vs. non-techy


```r
library(rCharts)
library(reshape2)
# install.packages('shiny')
library(shiny)
```

```
## Warning: package 'shiny' was built under R version 3.0.3
```

```r

## Get micro cluster data
load(file = "I:/201404/Mine4/02 Data/Sprint3/Clustering Solutions/micro_clusters.RData")
str(micro_clusters)
```

```
## 'data.frame':	20000 obs. of  10 variables:
##  $ scv_id           : Factor w/ 20000 levels "0000b54f-1d0f-4d0a-9981-e9b5fe2b3f04",..: 6213 6224 6252 3048 3043 3042 10202 10189 10218 10214 ...
##  $ age_band         : Factor w/ 4 levels "16_24","25_34",..: 2 2 4 1 1 2 2 2 2 2 ...
##  $ gender           : Factor w/ 2 levels "f","m": 2 1 2 1 2 1 1 2 1 2 ...
##  $ platform         : int  2 2 2 2 2 3 2 2 2 3 ...
##  $ tod              : int  3 2 3 2 3 2 2 2 1 2 ...
##  $ content          : int  10 16 15 10 14 1 7 16 11 4 ...
##  $ platform_desc    : chr  "C4COM" "C4COM" "C4COM" "C4COM" ...
##  $ platform_desc_alt: chr  "PC" "PC" "PC" "PC" ...
##  $ tod_desc         : chr  "WKDAY_DAY" "MIXED_TIMES" "WKDAY_DAY" "MIXED_TIMES" ...
##  $ content_desc     : chr  "TEEN_COMDRAM_MINOR" "MIXED_VIEWING" "DARK_DRAMA" "TEEN_COMDRAM_MINOR" ...
```

```r
## Get original data for profiling.
load(file = "I:/201404/Mine4/02 Data/Sprint3/sprint3_mine4_data_final.RData")
load(file = "I:/201404/Mine4/02 Data/Sprint3/techi clusters/techy_pred.RData")

cluster.data.temp <- merge(sprint3.mine4.data, techy_pred, by = "scv_id")
cluster.data.temp2 <- merge(cluster.data.temp, micro_clusters[, c(1, 7:10)], 
    by = "scv_id")
cluster.data.temp2$tenure_decile <- cut(cluster.data.temp2$tenure, breaks = quantile(cluster.data.temp2$tenure, 
    probs = seq(0, 1, by = 0.1)), include.lowest = TRUE)
head(cluster.data.temp2[, c(1:10)])
```

```
##                                 scv_id age age_band gender salutation
## 1 0000b54f-1d0f-4d0a-9981-e9b5fe2b3f04  42    35_54      f         Ms
## 2 000bda3a-77c0-4de2-8592-e1bb7903ce06  36    35_54      f         Ms
## 3 000d0d48-dce9-43e2-965c-ec03e31c4103  20    16_24      m         Mr
## 4 000f8eba-d231-4d2c-ac62-eeb63043e221  41    35_54      f         Ms
## 5 00133568-b98c-413f-8604-da13c0b550d2  27    25_34      f         Ms
## 6 0014c941-1dd7-4950-8354-ba7b6cba7982  61   55plus      m         Mr
##   postcode_area geo_region social_grade is_housewife has_children
## 1                                                                
## 2                                                                
## 3                                                                
## 4                                                                
## 5                                                                
## 6
```


You can see that our temporary data is at a scv_id level with the necessary inforamtion for modelling.


```r
summary(cluster.data.temp2$classification)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.000   0.000   0.000   0.123   0.000   1.000
```


It is very important that the profiling variable is called "classification", as this is what the code will search for when u put it into the app.

Lets pull out a subset of data to use for profiling:

```r
col.to.keep <- c("age_band", "gender", "exp_h_property_type_v2_desc", "exp_h_outstand_mortgag_v2_desc", 
    "exp_h_reg_n_hhld_inc_bnd_desc ", "exp_h_reg_n_property_bnd_desc", "exp_h_family_lifestg_2011_desc", 
    "exp_h_mosaic_uk_group_desc", "exp_h_child_in_hhld_2011_desc", "exp_p_true_touch_group_desc", 
    "tenure_decile", "classification", "platform_desc", "platform_desc_alt", 
    "tod_desc", "content_desc")
cluster.data <- cluster.data.temp2[, colnames(cluster.data.temp2) %in% col.to.keep]
```


We also need to make sure the classification is a factor, and that it has meaningful factorl evels. This is also very important as this helps build out some of the commentary on the graphs and headline.


```r
cluster.data$classification <- as.factor(cluster.data$classification)
levels(cluster.data$classification) <- c("non-techy", "techy")
```


Easy Peasy! You now have a dataset at a single user level, with a factor variable called "classification". THats all the app needs now to run so savethis into the data directory of your app. the current directory is below:


```r
write.csv(cluster.data, file = "I:\\201404\\Mine4\\02 Data\\Sprint3\\Cluster profiling\\profile-app\\data\\cluster_data.csv", 
    row.names = FALSE)
```


You're done! Now just run the app using shiny's runApp:


```r
runApp("I:\\201404\\Mine4\\02 Data\\Sprint3\\Cluster profiling\\profile-app")
```

