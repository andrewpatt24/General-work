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
head(tag.agg)
dim(tag.agg)
nrecipe.temp<-ifelse(tag.agg$recipe>10,10,tag.agg$recipe)
hist(nrecipe.temp)
tag.agg<-tag.agg[tag.agg$recipe>=10,]
#Lets take out the nodes with only 1 recipe:

## how many times do the recipes appear? (How many tags they have)
recipe.agg<-aggregate(tag~recipe,dat1,FUN=length)
head(recipe.agg)

tag.total<-data.frame(tag.agg,totalrecipe=length(unique(dat1$recipe)))
tag.total$prob.watched<-tag.total$recipe/tag.total$totalrecipe

recipe.tag<-dat1[,c(2,6)]
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
