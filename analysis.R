### analysis.R ###
## simResults() :
  ## source: data_gen.R
  ## for each iteration of sample generation, 1:Bsim, dataGen() generates a random population of size N
  ## select a random sample of size sampSize from those who survived to Age(60,75,90) (2000)
  ## fit linear mixed effect model for cognitive function, estimate total effect of education on rate of cognitive decline
  ## output relevant information
## writeResults():
  ## save output to working directory

##############################################
#### ~~ Function 1 of 2 (simResults) ~~ ######
##############################################

source('data_gen.R')

simResults = function(B,M,I){
  simSum = data.frame(t(sapply(1:B,function(b){
     dG = dataGen(M,I)
     size = dG$sampSize
     df.long = dG$df.long
     df = df.long[!duplicated(df.long$id),] 
     dGS = subset(df,survU==1)
     sampSize = sample(dGS$id,size,replace = FALSE)
     dfSamp.long = subset(df.long,id%in%sampSize)
     dfSamp = dfSamp.long[!duplicated(dfSamp.long$id),]
     unExposed = subset(dfSamp,exposure==0)
     Exposed = subset(dfSamp,exposure==1)
     
     ## run mixed effects model
  f1 = lmer(measured_cogfxn~exposure*time+(time|id),data = dfSamp.long)
  
    ## collect relevant output
  df.sum = data.frame(IScen = I,dG$tB, dG$g0,N,sum(dfSampU$survU),nrow(dfSamp)/nrow(dfSampU),
                      sum(dfSampU$exposure),
                      round(sum(df$survU)/N*100,2),
                      U1_TotalUnExp = mean(subset(df,exposure==0)$U1),
                      U1_TotalExp = mean(subset(df,exposure==1)$U1),
                      U1_SurvUnExp = mean(unExposed$U1),
                      U1_SurvExp = mean(Exposed$U1),
                      U2_TotalUnExp = mean(subset(df,exposure==0)$U2),
                      U2_TotalExp = mean(subset(df,exposure==1)$U2),
                      U2_SurvUnExp = mean(unExposed$U2),
                      U2_SurvExp = mean(Exposed$U2),
                      t(fixef(f1)),
                      t(diag(vcov(f1))^.5))
  }
  )))

  simSum = data.frame(apply(simSum,2,unlist))
  colnames(simSum) = c('IScen','trueB1','g0','N','SurvN','n.obs',"Exposed/N","SurvPerc",
                       'U1_TotalUnExp','U1_TotalExp','U1_SurvUnExp','U1_SurvExp',
                       'U2_TotalUnExp','U2_TotalExp','U2_SurvUnExp','U2_SurvExp',
                       'Int','Exposure','Slope','Exposure.Slope','sd.I','sd.EI','sd.time','sd.ET')
    tB1 = unique(simSum$trueB1)
  
  
  #####################################
  ### Calculate 95% CI and Coverage ###
  #####################################
  
  U_CI = mapply(function(x,y){x+1.96*y},x = simSum[,c('Int','Exposure','Slope','Exposure.Slope')],y = simSum[,c('sd.I','sd.EI','sd.time','sd.ET')])
  colnames(U_CI) = lapply(colnames(U_CI),function(x){paste(x,"U.CI")})
  
  L_CI = mapply(function(x,y){x-1.96*y},x = simSum[,c('Int','Exposure','Slope','Exposure.Slope')],y = simSum[,c('sd.I','sd.EI','sd.time','sd.ET')])
  colnames(L_CI) = lapply(colnames(L_CI),function(x){paste(x,"L.CI")})
  
  R1 = data.frame(simSum,U_CI,L_CI)
  R1$coverage = with(R1,mapply(function(x,y){ifelse(tB1<x&tB1>y,1,0)},x = Exposure.Slope.U.CI,y = Exposure.Slope.L.CI ))
  
  results = round(matrix(apply(R1[,c('Int','Exposure','Slope','Exposure.Slope','sd.I','sd.EI','sd.time','sd.ET')],2,mean),ncol = 2),6)
  results= cbind(results,apply(R1[,c('Int','Exposure','Slope','Exposure.Slope')],2,sd))
  
  rownames(results) = c('Int','Exposure','Slope','Exposure.Slope')
  colnames(results) = c('Beta_Avg','Est.SE','Emp.SE')
  res.df = data.frame(results)
  CovPerc = sum(R1$coverage)/B
  BiasPerc = (mean(R1$Exposure.Slope)-tB1)/tB1
  RMSE = sqrt((res.df$Beta_Avg[4] - tB1)^2 + res.df$Emp.SE[4]^2)
  fullresults = list(data = R1,result=res.df,CovPerc = CovPerc,BiasPerc = BiasPerc, RMSE = RMSE)
  
return(fullresults)

}


##############################################
#### ~~ Function 2 of 2 (writeResults) ~~ ####
##############################################
## writeResults function
## a function to run the simulation analysis

writeResults = function(B,M = scenMat,I,A = Age){
  r1 = simResults(B,M,I)
  saveRDS(r1,file = paste0('results',I,'_Age',A,'.RDA',sep = ''))}
