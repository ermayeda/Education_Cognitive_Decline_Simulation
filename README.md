# Life Course Epi Simulation (R) {.tabset}

Does selective survival prior to study enrollment attenuate estimated effects of education on rate of cognitive decline in older adults? A simulation approach for quantifying survival bias in lifecourse epidemiology.

R code to run simulation


## R Code for Simulation {.tabset}
There are 4 different R scripts, below is a summary of each file

Necessary R packages: 

 - `install.packages('lme4','ggplot2','MASS')`

### master_sim.R 
 - This is the master simulation file. 
 - requires: analysis.R, data_gen.R, parameter_gen.R
 - Assumes all R scripts are in the same working directory
 - Inputs:
     - Age: The age of your cohort, currently options are 60,75,90. These options can be expanded, however, additional work is necessary. 
     - Bsim: Number of simulations you would like to run (2000)
     
 - Outputs: 
     - output from simulation runs, a file saved out in current directory that specfices the age and scenario of the run in the title.
           - `file = paste0('results',I,'_Age',Age,'.RDA',sep = ''))}`
           - e.g. `results1_Age90.RDA` for age 90 run at scenario 1 (I = 1)

### parameter_gen.R      
- This script generates the full set of parameters necessary for all scenarios (1:10), at a particular cohort Age (60,75,90)
- Contains one function: `SInputs(Age,survAge)`
- generates causal structure design matrix (scenMat), see script for further details.

`survInfo`: a list containing survival age, survival probablities, and baseline hazards. Based on census information, mortality charts, and previous simulations. This is hardcoded. Cannot be changed without further work. Email author if you would like to explore different ages. 

    - df60 = average g0 of 2000 simulations for each scenario (1:10)
    - df75 = average g0 of 2000 simulations for each scenario (1:10)
    - df90 = average g0 of 2000 simulations for each scenario (1:10)
    - survInfo = list(Age = c(60,75,90), DeathP = c(.31,.65,.97), g.init = list(df60,df75,df90))

---

Study Sample

    - N = 100000,       number of participants at age 20
    - sampSize = 2000,  number of participants at age Age
    - t.int = 1.5,   time between observations
    - n.obs = 7,     number of observations
    - pexp = .4,    prevalence of low education
    - p = with(data.frame(survAge[1],survAge[2]), DeathP[Age==A]), probability of death for population
    
Variances and correlations

    - s2z0 = 0.2,    variance of random cognitive intercept
    - s2z1 = 0.005,  variance of random cognitive slope
    - sz01 = 0.01,    covariance of random intercept and random slope
    - s2e = 0.70,    variance of unexplained variation in Cij
    - rho = 0,       correlation between noise terms for Cij
    - s2d = 0,       variance of measurement error of Cij
    - b00 = 0,       cognitive intercept for unexposed
    - b01 = -0.5,    effect of exposure on cognitive intercept
    - b02 = 0,       effect of u1 on cognitive intercept
    - b03 = 0,       effect of U2 on cognitive intercept
    - b10 = -0.05,  cognitive slope for unexposed
    - b11 = c(rep(-0.0375,8),-0.0125,-0.0375), effect of exposure on cognitive slope
    - b12 = c(-0.025,rep(c(-0.025,-0.050,-0.025),2),rep(-0.025,3)), effect of U1 on cognitive slope
    - b13 = c(rep(-0.025,8),-0.075,-0.025), effect of U2 on cognitive slope
    
Survival Probability Parameters

    - g1 = c(rep(log(2),7),rep(log(sqrt(2)),2),log(2/sqrt(3))) education effect on probablity of death)
    - g2 = c(0,rep(log(2),2),log(3),rep(0,6)), U1 effect on probablity of death)
    - g3 = c(rep(0,7),rep(log(2),2),log(3)), U1*Education effect on probablity of death)
    - g4 = c(rep(0,4),rep(log(2),2),log(3),rep(0,3)) U2 effect on probablity of death
   
Education Effects

    - a0 = .5,        #Effect of education on pathology (U2)
    - a.sd = sqrt(1), #sd of effect of education 
    - g.init = if(A==60){unlist(survAge[[3]][1])}else{
    - if(A==75){unlist(survAge[[3]][2])}else{
      unlist(survAge[[3]][3])}} ,  initial value for optimization to find g0
 
### data_gen.R 

### analysis.R 

## R Code for Results Summary
