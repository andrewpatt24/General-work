#require(devtools)
#install_github('rCharts','ramnathv')
library(rCharts)
library(reshape2)
#install.packages("shiny")
library(shiny)

## Iris data
data(iris)




##Get micro cluster data
load(file="I:/201404/Mine4/02 Data/Sprint3/Clustering Solutions/micro_clusters.RData")
str(micro_clusters)
##Get original data for profiling.
load(file="I:/201404/Mine4/02 Data/Sprint3/sprint3_mine4_data_final.RData")
load(file='I:/201404/Mine4/02 Data/Sprint3/techi clusters/techy_pred.RData')

cluster.data.temp<-merge(sprint3.mine4.data,techy_pred,by="scv_id")
cluster.data.temp2<-merge(cluster.data.temp,micro_clusters[,c(1,7:10)],by="scv_id")
cluster.data.temp2$tenure_decile<-cut(cluster.data.temp2$tenure,
                                breaks=quantile(cluster.data.temp2$tenure, probs=seq(0,1, by=0.1)),
                                include.lowest=TRUE)
str(cluster.data.temp2)

##Lets take only the variables we want:

###What variables do I want?
##Basic demographics
##age
##age_band
##gender
##tenure
##Experian affluence
##exp_h_property_type_v2_desc
##exp_h_outstand_mortgag_v2_desc
##exp_h_reg_n_hhld_inc_bnd_desc 
##exp_h_reg_n_property_bnd_desc

## Experian lifestage
##exp_h_family_lifestg_2011_desc
##exp_h_mosaic_uk_group_desc
##exp_h_child_in_hhld_2011_desc
##exp_p_true_touch_group_desc
#create tenure_decile
## We then want to include the probability of being techy as a the grouping - I will turn this into a factor for ease.

col.to.keep<-c(
  "age_band",
  "gender",
  "exp_h_property_type_v2_desc",
  "exp_h_outstand_mortgag_v2_desc",
  "exp_h_reg_n_hhld_inc_bnd_desc ",
  "exp_h_reg_n_property_bnd_desc",
  "exp_h_family_lifestg_2011_desc",
  "exp_h_mosaic_uk_group_desc",
  "exp_h_child_in_hhld_2011_desc",
  "exp_p_true_touch_group_desc",
  "tenure_decile",
  "classification",
  "platform_desc",
  "platform_desc_alt",
  "tod_desc",
  "content_desc"
)
cluster.data<-cluster.data.temp2[,colnames(cluster.data.temp2) %in% col.to.keep]
cluster.data$classification<-as.factor(cluster.data$classification)
levels(cluster.data$classification)<-c("non-techy","techy")
str(cluster.data)

write.csv(cluster.data,file="I:\\201404\\Mine4\\02 Data\\Sprint3\\Cluster profiling\\profile-app\\data\\cluster_data.csv",row.names=FALSE)
#cluster.data2 <- read.csv("I:\\201404\\Mine4\\02 Data\\Sprint3\\Cluster profiling\\profile-app\\data\\cluster_data.csv")




#### Development ####

input<-list()
input$graphoptions1<-"platform_desc"

data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions1,"+classification,cluster.data,length)")))[,1:3]
#data.agg
colnames(data.agg)<-c(input$graphoptions1,"classification","Frequency")
data.agg.total<-merge(data.agg,aggregate(Frequency~platform_desc,data.agg,sum),by="platform_desc")
data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
#data.agg.prop
plot1 <- eval(parse(text=paste0("nPlot(proportion ~ ",input$graphoptions1,", group = 'classification', data = data.agg.prop, type = 'multiBarChart')")))
plot1$set(dom="plot1")
plot1$addParams(title = paste(input$graphoptions1,"Breakdown"))
return(plot1)



data.agg.prop




####Run the following code to push the app:
runApp("I:\\201404\\Mine4\\02 Data\\Sprint3\\Cluster profiling\\profile-app")
