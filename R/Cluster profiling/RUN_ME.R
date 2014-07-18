########################################################
######### Shiny app for Profling comparisons ###########
########################################################

### If you have not already installed rCharts,reshape2,shiny then please do so now!
install.packages("devtools")
require(devtools)
install_github('rCharts','ramnathv')
install.packages("shiny")
install.packages("reshape2")

###Finally run the app for techy.
library(shiny)
library(reshape2)
runApp("~/Documents/R/Cluster profiling/profile-app-techy")
