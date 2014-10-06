<<<<<<< HEAD
dat1<-read.csv("/Users/Andrew/Documents/general-work/R/data/openfoodtags.csv",header=FALSE)

colnames(dat1)<-c("rnum",
                 "recipe",
                 "url",
                 "author",
                 "author.nrecipe",
                 "tag")
dim(dat1)
## Lets double check the data:
### Take out recipes with no tags, authors or recipes
summary(dat1)

### Check that tag,recipes is unique across the data
length(unique(paste0(dat1$recipe,dat1$tag)))==nrow(dat1)
## Still to do

## how many times do the tags appear?
tag.agg<-aggregate(recipe~tag,dat1,FUN=length)
=======
##dat1<-read.csv("/Users/Andrew/Documents/general-work/R/data/openfoodtags.csv",header=FALSE)

dat1<-read.csv("P:/R repositories/general-work/general-work/R/data/openfoodtags.csv",
               colClasses=c("character","character","character","character","character","character"),
               col.names=c("rnum","recipe","url","author","author.nrecipe","tag"),
               header=FALSE
               )

###################################################
## Preliminary data checks and cleansing ##########
###################################################

##We want the data to be unique at a recipe,tag,author level.

##There may be some recipes with no tags, which we identified in our python script, so lets take those out.
dat1t<-dat1[dat1$tag!='No tags',]

### Check that tag,recipes is unique across the data

length(unique(paste(dat1t$recipe,",",dat1t$tag,",",dat1t$author)))==nrow(dat1t)
temp1<-aggregate(url~recipe+tag+author,dat1t,FUN=length)
temp1[temp1$url!=1,]

##There are some recipes that have been uploaded twice by the user - lets forget about those. We will keep temp1 and add on author notes to that.
author1<-aggregate(url~author+author.nrecipe,dat1t,FUN=length)[,-3]
recipe1<-aggregate(tag~recipe+author+author.nrecipe,dat1t,FUN=length)[-4]

length(unique(paste(recipe1$recipe,recipe1$author,recipe1$author.nrecipe)))
nrow(recipe1)
nrow(author1)
head(recipe1)

temp2<-merge(temp1[,-4],author1,by="author")
rdata<-merge(temp2,recipe1,by=c("recipe","author","author.nrecipe"))
head(rdata)

##Great, lets double check it is now aggregated to the right aggregation - This is without url so will have to put this in if I am to add it into one of the force directed layouts as info
length(unique(paste(rdata$recipe,",",rdata$tag,",",rdata$author)))==nrow(rdata)

##Brilliant! Lets just take the top 50 tags for now:
ntags<-aggregate(recipe~tag,rdata,FUN=length)
ntags.order<-ntags[order(ntags$recipe,decreasing=TRUE),]
top50.tag<-ntags.order[1:50,]
rdata.top50<-rdata[rdata$tag %in% top50.tag$tag,]
############################################################
### Function to create nodes and links from data ###########
############################################################

data=rdata.top50
node.var="tag"
link.var="recipe"
link.type="cooccur"
node.table<-data.frame(tag=unique(data[,node.var])[-c(1:10)],cluster=rbinom(length(unique(data[,node.var])[-c(1:10)]),12,0.8))
#node.table=NULL
###Calculate nodes part of data
if (is.null(node.table)) {
  nodes<-data.frame(data[,node.var],group=1)
} else {
  nodes<-merge(unique(data[,node.var,drop=FALSE]),
               node.table,
               by="tag",
               all.x=TRUE
  )
  nodes$cluster<-ifelse(is.na(nodes$cluster),0,nodes$cluster)
}


if(link.type=="cooccur") {
###Calculate links part of data
link.temp<-merge(data[,c(node.var,link.var)],data[,c(node.var,link.var)],by=link.var)
link.agg<-aggregate(recipe~tag.x+tag.y,link.temp,FUN=length)
head(link.agg)

link.agg$tag.xnum<-match(link.agg$tag.x,nodes$tag)
link.agg$tag.ynum<-match(link.agg$tag.y,nodes$tag)

head(link.agg)

links<-link.agg[,c(5,4,3)]
colnames(links)<-c("source","target","value")
}

output<-list(nodes=nodes,links=links)

if(link.type=="IG") {
##Calcualte links part of data - using IG calculation.
  
}










## how many times do the tags appear?
tag.agg<-aggregate(cbind(recipe,author)~tag,dat1,FUN=length)
>>>>>>> 23e624c380a4a01c4ad9188a2091a7ce55794494
head(tag.agg)
dim(tag.agg)
nrecipe.temp<-ifelse(tag.agg$recipe>10,10,tag.agg$recipe)
hist(nrecipe.temp)
tag.agg<-tag.agg[tag.agg$recipe>=100,]
#Lets take out the nodes with only 1 recipe:

## how many times do the recipes appear? (How many tags they have)
recipe.agg<-aggregate(tag~recipe,dat1,FUN=length)
head(recipe.agg)

tag.total<-data.frame(tag.agg,totalrecipe=length(unique(dat1$recipe)))
tag.total$prob.watched<-tag.total$recipe/tag.total$totalrecipe

recipe.tag<-dat1[dat1$tag %in% tag.agg$tag,c(2,6)]
recipe.tag.cond<-merge(recipe.tag,recipe.tag,by="recipe")
recipe.tag.cond.agg<-aggregate(recipe~tag.x+tag.y,recipe.tag.cond,FUN=length)
colnames(recipe.tag.cond.agg)<-c("taga","tagb","conditional_count")

tag.cond.nrecipe1<-merge(recipe.tag.cond.agg,tag.total,by.x="taga",by.y="tag")
tag.cond.nrecipe2<-merge(tag.cond.nrecipe1,tag.total,by.x="tagb",by.y="tag")

tag.cond.data<-tag.cond.nrecipe2[,c(1,2,3,4,5,6,7,9)]

colnames(tag.cond.data)[4:8]<-c("taga_numrecipe",
                                "total_recipes",
                                "a",
                                "tagb_numrecipe",
                                "b"
                                )
colnames(tag.cond.data)
#[1] "tag2"              "tag1"              "conditional_count"
#[4] "taga_numrecipe"    "total_recipes"     "a"                
#[7] "tagb_numrecipe"    "b"    

tag.cond.data$ab1<-tag.cond.data$conditional_count/tag.cond.data$taga_numrecipe
tag.cond.data$ab0<-(tag.cond.data$tagb_numrecipe-tag.cond.data$conditional_count)/(tag.cond.data$total_recipes-tag.cond.data$taga_numrecipe)

head(tag.cond.data)

tag.cond.data$ratio<-tag.cond.data$ab1/tag.cond.data$ab0
summary(tag.cond.data$ratio)


Edges<-data.frame(
  Source = tag.cond.data$tag1,
  Target = tag.cond.data$tag2,
  Weight = tag.cond.data$ratio
  )
Edges<-Edges[Edges$Weight!=Inf,]

Nodes<-data.frame(
  aggregate(a~tag1,tag.cond.data,FUN=max)
  )
colnames(Nodes)<-c("Id","prob_watched")
## How many nodes do i have?
dim(Nodes)

##Nicked this bit of code from http://theweiluo.wordpress.com/2011/09/30/r-to-json-for-d3-js-and-protovis/
toJSONarray <- function(dtf){
  clnms <- colnames(dtf)
  
  name.value <- function(i){
    quote <- '';
    if(class(dtf[, i])!='numeric'){
      quote <- '"';
    }
    
    paste('"', i, '" : ', quote, dtf[,i], quote, sep='')
  }
  
  objs <- apply(sapply(clnms, name.value), 1, function(x){paste(x, collapse=', ')})
  objs <- paste('{', objs, '}')
  
  res <- paste('[', paste(objs, collapse=', '), ']')
  
  return(res)
}

Edges.json<-toJSONarray(Edges)
Nodes.json<-toJSONarray(Nodes)
write(Edges.json,file="/Users/Andrew/Documents/R/data/edges_json.txt")
write(Nodes.json,file="/Users/Andrew/Documents/R/data/nodes_json.txt")
