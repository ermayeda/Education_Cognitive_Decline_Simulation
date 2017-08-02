##### Master Simulation File #####

# This scripts runs the simulation analyses, it is necessary that three other scripts are in
# the same working directory: parameter_gen.R, data_gen.R, analysis.R
# Changes to all parameter settings can be made in the parameter_gen.R file. 
# This master_sim.R script allows the user to input which scenarios (1:10) to run, which Age (60,75,90) to run
# and how many iterations of sample generation (S) to run. 

##################################
####### ~ Run Simulation ~ #######
##################################

## source: analysis.R 
## scenMat: a casual structure matrix created in the parameter_gen.R script. 
##
## Age: Age of cohort analysis, used in analysis.R, parameter_gen.R, data_generation.R
##
## Bsim: Number of iterations of sample generation to run 
##
## I: - a unique Causal Structure and input parameter combination (Scenario), ranges from 1:10. 
##    - Row I of simInputs is used to generate output file from parameterGeneration.R 
##    - See documentation for details on each level of I.
##
## scenarios: - a vector (1:10) designates which Causal Structure and Severity level combinations (I) you would like to run
##            - for all scenarios, set scenarios = 1:10
##
## writeResults():  - function created in analysis.R. Saves simulation results to current working directory. 
##                  - saves file out as file = paste0('results',I,'_Age',Age,'.RDA',sep = ''))}
## set.seed(082173)  #un-comment and set a seed here if you would like 

library(MASS)
library(lme4)
Age = 90  
Bsim = 5        # suggested to test with a small Bsim, after, run at Bsim>=1000
scenarios = 1:2 #for all scenarios set to 1:10

source('analysis.R')

## runs Bsim iterations of sample generation for cohort age 'Age' for Causal Structure and input parameter combination, 'scenarios'. 

sapply(scenarios,function(x){
  writeResults(B = Bsim, M = scenMat, I = x, A = Age) #see above for description
  })

#end
