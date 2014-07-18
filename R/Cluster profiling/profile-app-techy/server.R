library(shiny)
require(rCharts)
library(reshape2)

shinyServer(function(input, output) {
  
  output$plot1<-renderChart({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions1,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions1,"classification","Frequency")
    data.agg.total<-merge(data.agg,aggregate(Frequency~classification,data.agg,sum),by="classification")
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    plot1 <- nPlot(proportion ~ classification, group = input$graphoptions1, data = data.agg.prop, type = "multiBarChart")
    plot1$set(dom="plot1")
    plot1$addParams(title = paste(input$graphoptions1,"Breakdown"))
    return(plot1)
    })
  
  output$plot1a<-renderChart({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions1,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions1,"classification","Frequency")
    data.agg.total<-eval(parse(text=paste0("merge(data.agg,aggregate(Frequency~",input$graphoptions1,",data.agg,sum),by='",input$graphoptions1,"')")))
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    plot1a <- eval(parse(text=paste0("nPlot(proportion ~ ",input$graphoptions1,", group = 'classification', data = data.agg.prop, type = 'multiBarChart')")))
    plot1a$set(dom="plot1a")
    plot1a$addParams(title = paste(input$graphoptions1,"Breakdown"))
    return(plot1a)
  })
  
  output$table1<-renderTable({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions1,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions1,"classification","Frequency")
    data.agg.total<-merge(data.agg,aggregate(Frequency~classification,data.agg,sum),by="classification")
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    data.agg.prop$proportion<-round(data.agg.prop$proportion,4)
    colnames(data.agg.prop)[5]<-"value"
    dcast(data.agg.prop[,c(1,2,5)],as.formula(paste0("classification~",input$graphoptions1)),mean)
    
  })
  
  output$table1a<-renderTable({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions1,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions1,"classification","Frequency")
    data.agg.total<-eval(parse(text=paste0("merge(data.agg,aggregate(Frequency~",input$graphoptions1,",data.agg,sum),by='",input$graphoptions1,"')")))
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    data.agg.prop$proportion<-round(data.agg.prop$proportion,4)
    colnames(data.agg.prop)[5]<-"value"
    dcast(data.agg.prop[,c(1,2,5)],as.formula(paste0(input$graphoptions1,"~classification")),mean)
    
  })
  
  output$plot2<-renderChart({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions2,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions2,"classification","Frequency")
    data.agg.total<-merge(data.agg,aggregate(Frequency~classification,data.agg,sum),by="classification")
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    plot2 <- nPlot(proportion ~ classification, group = input$graphoptions2, data = data.agg.prop, type = "multiBarChart")
    plot2$set(dom="plot2")
    plot2$addParams(title = paste(input$graphoptions2,"Breakdown"))
    return(plot2)
  })
  
  output$plot2a<-renderChart({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions2,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions2,"classification","Frequency")
    data.agg.total<-eval(parse(text=paste0("merge(data.agg,aggregate(Frequency~",input$graphoptions2,",data.agg,sum),by='",input$graphoptions2,"')")))
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    plot2a <- eval(parse(text=paste0("nPlot(proportion ~ ",input$graphoptions2,", group = 'classification', data = data.agg.prop, type = 'multiBarChart')")))
    plot2a$set(dom="plot2a")
    plot2a$addParams(title = paste(input$graphoptions2,"Breakdown"))
    return(plot2a)
  })
  
  output$table2<-renderTable({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions2,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions2,"classification","Frequency")
    data.agg.total<-merge(data.agg,aggregate(Frequency~classification,data.agg,sum),by="classification")
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    data.agg.prop$proportion<-round(data.agg.prop$proportion,4)
    colnames(data.agg.prop)[5]<-"value"
    dcast(data.agg.prop[,c(1,2,5)],as.formula(paste0("classification~",input$graphoptions2)),mean)
    
  })
  
  output$table2a<-renderTable({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions2,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions2,"classification","Frequency")
    data.agg.total<-eval(parse(text=paste0("merge(data.agg,aggregate(Frequency~",input$graphoptions2,",data.agg,sum),by='",input$graphoptions2,"')")))
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    data.agg.prop$proportion<-round(data.agg.prop$proportion,4)
    colnames(data.agg.prop)[5]<-"value"
    dcast(data.agg.prop[,c(1,2,5)],as.formula(paste0(input$graphoptions2,"~classification")),mean)
    
  })
  
  output$plot3<-renderChart({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions3,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions3,"classification","Frequency")
    data.agg.total<-merge(data.agg,aggregate(Frequency~classification,data.agg,sum),by="classification")
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    plot3 <- nPlot(proportion ~ classification, group = input$graphoptions3, data = data.agg.prop, type = "multiBarChart")
    plot3$set(dom="plot3")
    plot3$addParams(title = paste(input$graphoptions3,"Breakdown"))
    return(plot3)
  })
  
  output$plot3a<-renderChart({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions3,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions3,"classification","Frequency")
    data.agg.total<-eval(parse(text=paste0("merge(data.agg,aggregate(Frequency~",input$graphoptions3,",data.agg,sum),by='",input$graphoptions3,"')")))
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    plot3a <- eval(parse(text=paste0("nPlot(proportion ~ ",input$graphoptions3,", group = 'classification', data = data.agg.prop, type = 'multiBarChart')")))
    plot3a$set(dom="plot3a")
    plot3a$addParams(title = paste(input$graphoptions3,"Breakdown"))
    return(plot3a)
  })
  
  output$table3<-renderTable({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions3,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions3,"classification","Frequency")
    data.agg.total<-merge(data.agg,aggregate(Frequency~classification,data.agg,sum),by="classification")
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    data.agg.prop$proportion<-round(data.agg.prop$proportion,4)
    colnames(data.agg.prop)[5]<-"value"
    dcast(data.agg.prop[,c(1,2,5)],as.formula(paste0("classification~",input$graphoptions3)),mean)
    
  })
  
  output$table3a<-renderTable({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions3,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions3,"classification","Frequency")
    data.agg.total<-eval(parse(text=paste0("merge(data.agg,aggregate(Frequency~",input$graphoptions3,",data.agg,sum),by='",input$graphoptions3,"')")))
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    data.agg.prop$proportion<-round(data.agg.prop$proportion,4)
    colnames(data.agg.prop)[5]<-"value"
    dcast(data.agg.prop[,c(1,2,5)],as.formula(paste0(input$graphoptions3,"~classification")),mean)
    
  })
  
  output$plot4<-renderChart({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions4,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions4,"classification","Frequency")
    data.agg.total<-merge(data.agg,aggregate(Frequency~classification,data.agg,sum),by="classification")
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    plot4 <- nPlot(proportion ~ classification, group = input$graphoptions4, data = data.agg.prop, type = "multiBarChart")
    plot4$set(dom="plot4")
    plot4$addParams(title = paste(input$graphoptions4,"Breakdown"))
    return(plot4)
  })
  
  output$plot4a<-renderChart({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions4,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions4,"classification","Frequency")
    data.agg.total<-eval(parse(text=paste0("merge(data.agg,aggregate(Frequency~",input$graphoptions4,",data.agg,sum),by='",input$graphoptions4,"')")))
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    plot4a <- eval(parse(text=paste0("nPlot(proportion ~ ",input$graphoptions4,", group = 'classification', data = data.agg.prop, type = 'multiBarChart')")))
    plot4a$set(dom="plot4a")
    plot4a$addParams(title = paste(input$graphoptions4,"Breakdown"))
    return(plot4a)
  })
  
  output$table4<-renderTable({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions4,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions4,"classification","Frequency")
    data.agg.total<-merge(data.agg,aggregate(Frequency~classification,data.agg,sum),by="classification")
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    data.agg.prop$proportion<-round(data.agg.prop$proportion,4)
    colnames(data.agg.prop)[5]<-"value"
    dcast(data.agg.prop[,c(1,2,5)],as.formula(paste0("classification~",input$graphoptions4)),mean)
    
  })
  
  output$table4a<-renderTable({
    
    data.agg<-eval(parse(text=paste0("aggregate(.~",input$graphoptions4,"+classification,cluster.data,length)")))[,1:3]
    #data.agg
    colnames(data.agg)<-c(input$graphoptions4,"classification","Frequency")
    data.agg.total<-eval(parse(text=paste0("merge(data.agg,aggregate(Frequency~",input$graphoptions4,",data.agg,sum),by='",input$graphoptions4,"')")))
    data.agg.prop<-data.frame(data.agg.total,proportion=data.agg.total$Frequency.x/data.agg.total$Frequency.y)
    #data.agg.prop
    data.agg.prop$proportion<-round(data.agg.prop$proportion,4)
    colnames(data.agg.prop)[5]<-"value"
    dcast(data.agg.prop[,c(1,2,5)],as.formula(paste0(input$graphoptions4,"~classification")),mean)
    
  })
  
  

})