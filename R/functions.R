###http://www.coppelia.io/gist-dftojson/
#install.packages("rjson")
library(rjson)
#install.packages("stringr")
library(stringr)
dfToJSON<-function(df, mode='vector'){
  
  colToList<-function(x, y){
    
    col.json<-list()
    
    #Build up a list of coordinates
    
    for (i in 1:length(x)){
      
      ni<-list(x=x[i], y=y[i])
      col.json[[length(col.json)+1]]<-ni
    }
    
    return(col.json)
    
  }
  
  
  if (mode=='vector'){
    
    for.json<-list()
    
    for (j in 1:ncol(df)){
      for.json[[length(for.json)+1]]<-list(name=colnames(df)[j] , data=df[,j])
    }
    
  }
  
  if (mode=='coords') {
    
    for.json<-list()
    
    for (j in 2:ncol(df)){
      for.json[[length(for.json)+1]]<-list(name=colnames(df)[j] , data=colToList(x=df[,1], y=df[,j]))
    }
    
  }
  
  if (mode=='rowToObject') {
    
    for.json<-list()
    
    for (j in 1:nrow(df)){
      for.json[[length(for.json)+1]]<-df[j,]
    }
    
  }
  
  jj<-toJSON(for.json)
  
  return(jj)
  
}


############################################################
### Function to create nodes and links from data ###########
############################################################
data=rdata.top50
node.var="tag"
link.var="recipe"




calculateNodesAndLinks<-function(data,node.var,link.var,link.type="cooccur",node.table=NULL,min.link=50) {
  #housekeeping
  
  
  ###Calculate nodes part of data
  if (is.null(node.table)) {
    nodes<-data.frame(data[,node.var],group=1)
  } else {
    nodes<-merge(unique(data[,node.var,drop=FALSE]),
                 node.table,
                 by=node.var,
                 all.x=TRUE
    )
    nodes$cluster<-ifelse(is.na(nodes$cluster),0,nodes$cluster)
  }
  colnames(nodes)<-c("name","group")
  
  
  
  if(link.type=="cooccur") {
    
    ###Calculate links part of data
    link.temp<-merge(data[,c(node.var,link.var)],data[,c(node.var,link.var)],by=link.var)
    eval(parse(text=paste0("link.agg<-aggregate(",link.var,"~",node.var,".x+",node.var,".y,link.temp,FUN=length)")))
    
    eval(parse(text=paste0("link.agg$tag.xnum<-match(link.agg$",node.var,".x,nodes$name)-1")))
    eval(parse(text=paste0("link.agg$tag.ynum<-match(link.agg$",node.var,".y,nodes$name)-1")))
    
    links<-link.agg[,c(5,4,3)]
    eval(parse(text=paste0("links<-links[links$",link.var,">=min.link,]")))
    colnames(links)<-c("source","target","value")
  }
  
  output<-list(nodes=nodes,links=links)
  return(output)
}