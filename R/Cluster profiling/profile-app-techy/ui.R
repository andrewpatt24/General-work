<<<<<<< HEAD
library(shiny)
library(rCharts)
library(reshape2)

shinyUI(fluidPage(
  
  titlePanel(paste0("Cluster Comparison - Proportion ",paste(levels(cluster.data$classification),collapse= " vs "))),
  
  fluidRow(
    column(2,
           selectInput("graphoptions1", label = h5("Select description for graph1"),choices = graphoptions, selected = graphoptions[1]),
           selectInput("graphoptions2", label = h5("Select description for graph2"),choices = graphoptions, selected = graphoptions[2]),
           selectInput("graphoptions3", label = h5("Select description for graph3"),choices = graphoptions, selected = graphoptions[3]),
           selectInput("graphoptions4", label = h5("Select description for graph4"),choices = graphoptions, selected = graphoptions[4])
    ),
    column(5,
           tabsetPanel(
             tabPanel("Desc Barchart",showOutput("plot1","Nvd3")
                      ),
             tabPanel("Class Barchart",showOutput("plot1a","Nvd3")
             ),
             tabPanel("Table",
                      tableOutput("table1"),
                      tableOutput("table1a")
                      )
             )
           ),
    column(5,
           tabsetPanel(
             tabPanel("Desc Barchart",showOutput("plot2","Nvd3")
                      ),
             tabPanel("Class Barchart",showOutput("plot2a","Nvd3")
             ),
             tabPanel("Table",tableOutput("table2"),
                      tableOutput("table2a")
                      )
           )
             )
           ),
  fluidRow(
    column(5,offset=2,
           tabsetPanel(
             tabPanel("Desc Barchart",showOutput("plot3","Nvd3")
             ),
             tabPanel("Class Barchart",showOutput("plot3a","Nvd3")
             ),
             tabPanel("Table",tableOutput("table3"),
                      tableOutput("table3a")
                      )
           )
           ),
    column(5,
           tabsetPanel(
             tabPanel("Desc Barchart",showOutput("plot4","Nvd3")
             ),
             tabPanel("Class Barchart",showOutput("plot4a","Nvd3")
             ),
             tabPanel("Table",tableOutput("table4"),
                      tableOutput("table4a")
                      )
           )
           )
    )
)
)

=======
library(shiny)
library(rCharts)
library(reshape2)

shinyUI(fluidPage(
  
  titlePanel(paste0("Cluster Comparison - Proportion ",paste(levels(cluster.data$classification),collapse= " vs "))),
  
  fluidRow(
    column(2,
           selectInput("graphoptions1", label = h5("Select description for graph1"),choices = graphoptions, selected = graphoptions[1]),
           selectInput("graphoptions2", label = h5("Select description for graph2"),choices = graphoptions, selected = graphoptions[2]),
           selectInput("graphoptions3", label = h5("Select description for graph3"),choices = graphoptions, selected = graphoptions[3]),
           selectInput("graphoptions4", label = h5("Select description for graph4"),choices = graphoptions, selected = graphoptions[4])
    ),
    column(5,
           tabsetPanel(
             tabPanel("Desc Barchart",showOutput("plot1","Nvd3")
                      ),
             tabPanel("Class Barchart",showOutput("plot1a","Nvd3")
             ),
             tabPanel("Table",
                      tableOutput("table1"),
                      tableOutput("table1a")
                      )
             )
           ),
    column(5,
           tabsetPanel(
             tabPanel("Desc Barchart",showOutput("plot2","Nvd3")
                      ),
             tabPanel("Class Barchart",showOutput("plot2a","Nvd3")
             ),
             tabPanel("Table",tableOutput("table2"),
                      tableOutput("table2a")
                      )
           )
             )
           ),
  fluidRow(
    column(5,offset=2,
           tabsetPanel(
             tabPanel("Desc Barchart",showOutput("plot3","Nvd3")
             ),
             tabPanel("Class Barchart",showOutput("plot3a","Nvd3")
             ),
             tabPanel("Table",tableOutput("table3"),
                      tableOutput("table3a")
                      )
           )
           ),
    column(5,
           tabsetPanel(
             tabPanel("Desc Barchart",showOutput("plot4","Nvd3")
             ),
             tabPanel("Class Barchart",showOutput("plot4a","Nvd3")
             ),
             tabPanel("Table",tableOutput("table4"),
                      tableOutput("table4a")
                      )
           )
           )
    )
)
)

>>>>>>> 23e624c380a4a01c4ad9188a2091a7ce55794494
