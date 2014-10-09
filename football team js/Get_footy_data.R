#install.packages("XML")
library(XML)
#install.package("caret")
library(caret)
#install.packages("lpSolve")
library(lpSolve)


date<-20141003
wknum<-6

###################################
## Take data from premier league website##
###################################

# URL of interest: 
mps <- "http://fantasy.premierleague.com/player-list/" 
# parse the document for R representation: 
mps.doc <- htmlParse(mps)
# get all the tables in mps.doc as data frames
mps.tabs <- readHTMLTable(mps.doc) 
summary(mps.tabs)
mps.tabs[[2]]


##################
####Manipulation##
##################
##Manipulate into table
mps.GK<-rbind(mps.tabs[[1]],mps.tabs[[2]])
mps.GK$Position<-as.factor("GK")
mps.DF<-rbind(mps.tabs[[3]],mps.tabs[[4]])
mps.DF$Position<-as.factor("DF")
mps.MD<-rbind(mps.tabs[[5]],mps.tabs[[6]])
mps.MD$Position<-as.factor("MD")
mps.FD<-rbind(mps.tabs[[7]],mps.tabs[[8]])
mps.FD$Position<-as.factor("FD")
##Bind for full data
footy.data<-rbind(mps.GK,mps.DF,mps.MD,mps.FD)
##Change storage of each variable
footy.data$Cost<-as.numeric(as.character(substring(footy.data$Cost,2)))
footy.data$Points<-as.numeric(as.character(footy.data$Points))
footy.data$Player<-as.character(footy.data$Player)
str(footy.data)

#ok
dim(footy.data) ##[1] 583   5

######################
##Produce Final Data##
######################

##SAVE FILE
eval(parse(text=paste0("footy.final.",date,".wk.",wknum,"<-footy.data")))
eval(parse(text=paste0("save(footy.final.",date,".wk.",wknum,",file=\"foot_data_",date,"_wk",wknum,".R\")")))


# URL of interest: 
#mps <- "http://www.footballdatabase.com/leagues.php?liga=200&season=201314" 
# parse the document for R representation: 
#mps.doc <- htmlParse(mps)
# get all the tables in mps.doc as data frames
#mps.tabs <- readHTMLTable(mps.doc) 
#summary(mps.tabs)
#mps.tabs[[2]]

#########################
##Optimum squad selector#
#########################

Opt.squad<-function(dat,cost,n.gk=2,n.df=5,n.md=5,n.fd=3) {
  #dat<-footy.data
  #cost<-100
  #n.gk=2
  #n.df=5
  #n.md=5
  #n.fd=3
    ##Attach play
  #attach(dat)
  #length(Cost)
  
  ##Create dummy variables
  fact.only<-dat[, which(sapply(dat, class)=="factor")]
  non.fact<-dat[, which(sapply(dat, class)!="factor")]
  dat.dummy<-model.matrix(~ Position + Team, data=fact.only, 
                                 contrasts.arg=list(Position=contrasts(fact.only$Position, contrasts=F), 
                                                    Team=contrasts(fact.only$Team, contrasts=F)))
  
  dat2<-dat.dummy[,-1]
  colnames(dat2)<-gsub("[^#A-Za-z0-9_]","",colnames(dat2))
  dat<-cbind(non.fact,dat2)
  ##Pick optimum team
  f.obj <- dat$Points
  nn<-length(f.obj)
  play  <- rep(1,nn)
  n.choose<-n.gk+n.df+n.md+n.fd
  f.con <- cbind(Cost=dat$Cost,dat[,colnames(dat) %in% colnames(dat2)],play)
  f.con<-t(f.con)
  f.dir <- c("<=","=","=","=","=", "<=","<=","<=","<=", "<=","<=","<=","<=", "<=","<=","<=","<=", "<=","<=","<=","<=", "<=","<=","<=","<=","=")
  f.rhs <- c(cost,n.gk,n.df,n.md,n.fd,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,n.choose)
  out1  <- lp("max", f.obj, f.con, f.dir, f.rhs,all.bin=TRUE)
  
  if (out1$status == 2) {
    print ("There was no optimal solution. Try a diferent form or increase decrease your total cost")
    } else {
      sol1  <- out1$solution
      total1 <- out1$objval 
      ###Take numbers and take out 
      pick1a <- rep(0,15)
      k     <- 0
      f.obj2<-f.obj
      for (j in 1:nn) {
        if (sol1[j]==1) {
          k        <- k+1
          pick1a[k] <- j
        }
      }
      final.pick<-dat[pick1a,1:3]
      final.pick
    }
}


#################################
##Pick best squad################
#################################

w1.pick<-Opt.squad(footy.data,cost=100,n.gk=2,n.df=5,n.md=5,n.fd=3) 
w1.pick

w1.pick.order<-w1.pick[order(w1.pick$Points,decreasing=TRUE),]


pick.bad<-Opt.squad(footy.data,cost=12.6,n.gk=0,n.df=1,n.md=1,n.fd=1)
pick.bad
pick.good<-Opt.squad(footy.data,cost=100-12.6,n.gk=2,n.df=4,n.md=4,n.fd=2)
pick.good






###WIP##########

opt.change<-function(dat,change,team.val,init.pick) {
  #dat<-dat.w1
  #change<-1
  #pick<-init.pick
  #team.val<-100
  
  
  
  attach(dat)
  
  f.obj <- Points
  nn<-length(f.obj)
  play  <- rep(1,nn)
  f.con <- cbind(Cost,GK,Defence,Midfield,Attack,Aston.Villa,Chelsea,Everton,Fulham,
                 Liverpool,Man.City,Man.Utd,Newcastle,Norwich,QPR,Reading,Southampton,
                 Stoke.City,Sunderland,Swansea,Tottenham,West.Brom,West.Ham,Wigan,play,pick)
  f.con <- t(f.con)
  f.dir <- c("<=","=", "=",">=",">=",">=", "<=","<=","<=","<=", "<=","<=","<=","<=", "<=","<=","<=","<=", "<=","<=","<=","<=", "<=","<=","<=","=",">=")
  f.rhs <- c(team.val,0,2,4,4,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,15,15-change)
  out1  <- lp ("max", f.obj, f.con, f.dir, f.rhs,all.bin=TRUE)
  sol1  <- out1$solution
  total1 <- out1$objval
  
  squad <- rep(0,15)
  k     <- 0
  for (j in 1:nn) {
    if (sol1[j]==1) {
      k        <- k+1
      squad[k] <- j
    }
  }
  squad.dat <- dat[squad,]
  
  detach(dat)
  attach(squad.dat)
  
  play      <- rep(1,15)
  f.obj     <- Points
  f.con     <- cbind(GK,Defence,Attack,play)
  f.con     <- t(f.con)
  f.dir     <- c("=",">=",">=","=")
  f.rhs     <- c(1,3,1,11)
  sol1      <- lp ("max", f.obj, f.con, f.dir, f.rhs,all.bin=TRUE)
  sol2      <- sol1$solution
  
  team     <- rep(0,11)
  k         <- 0
  for (j in 1:15) {
    if (sol2[j]==1) {
      k<-k+1
      team[k]<-j}
  }
  detach(dat)
  list(squad=squad,team=team)
}
