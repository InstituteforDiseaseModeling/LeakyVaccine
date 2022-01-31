## First, you will need to install these packages:
library(deSolve)
library(tidyverse)
library(EpiModel)
library(survival)
library(EasyABC)

si_odeFn <- function(times, init, param){
  with(as.list(c(init, param)), {
    
    # Flows
    # the number of people moving from S to I at each time step
    #Susceptible, Infected, placebo
    SIp.flow <- lambda*Sp
    SIv.flow <- lambda*(1-epsilon)*Sv
    
    #Susceptible, Infected, placebo, high, medium, low
    SIph.flow <- risk*lambda*Sph
    SIpm.flow <- lambda*Spm
    SIpl.flow <- 0*lambda*Spl  #0 to give this group zero exposures
    
    #Susceptible, Infected, vaccine, high, medium, low
    SIvh.flow <- risk*lambda*(1-epsilon)*Svh
    ### Paul found this line has two bugs:
    ### SIvm.flow <- lambda*(1-epsilon)*Spl
    SIvm.flow <- lambda*(1-epsilon)*Svm
    SIvl.flow <- 0*lambda*(1-epsilon)*Svl  #0 to give this group zero exposures
    
    # ODEs
    # placebo; homogeneous risk
    dSp <- -SIp.flow
    dIp <- SIp.flow  #lambda*Sp
    
    # vaccine; homogeneous risk
    dSv <- -SIv.flow
    dIv <- SIv.flow  #lambda*epsilon*Sv
    
    # placebo; heterogeneous risk
    dSph <- -SIph.flow
    dIph <- SIph.flow  #risk*lambda*Sph
    dSpm <- -SIpm.flow
    dIpm <- SIpm.flow  #lambda*Spm
    dSpl <- -SIpl.flow
    dIpl <- SIpl.flow  #0*lambda*Spl
    
    # vaccine; heterogeneous risk
    dSvh <- -SIvh.flow
    dIvh <- SIvh.flow  #risk*lambda*(1-epsilon)*Svh
    dSvm <- -SIvm.flow
    dIvm <- SIvm.flow  #lambda*Svm
    dSvl <- -SIvl.flow
    dIvl <- SIvl.flow  #0*lambda*(1-epsilon)*Svl
    
    #Output
    list(c(dSp,dIp,
           dSv,dIv,
           dSph,dIph,
           dSpm,dIpm,
           dSpl,dIpl,
           dSvh,dIvh,
           dSvm,dIvm,
           dSvl,dIvl,
           SIp.flow,SIv.flow,
           SIph.flow,SIpm.flow,SIpl.flow,
           SIvh.flow,SIvm.flow,SIvl.flow))
  })
}

#------------------------------------------------------------------------------
# sim execution
#------------------------------------------------------------------------------
runSim_Paul <- function(reac) {}
  
  #time <- c(180,360,540,720,900,1080)  # every 6 months for 3 years
  time <- 3*365; # End of the trial.
  
  ## Note here actually want to target the average incidence over time, rather than the incidence at the end of the trial, since with multiple risk groups there is waning expected. I have changed this in the ABC function f, below.
  placebo.incidence.target <- rep( reac$placeboIncidenceTarget, length( time ) )    # flat incidence of 3.5% per 100 person years
  
  ### Paul notes this is not going to work, if efficacy is waning you can't match a constant efficacy over time. We should match just one time, probably duration of 702 trial.
  VE.target <- rep(reac$veTarget, length( time ))
  target.stats <- data.frame(time, VE.target, placebo.incidence.target )
  
  ## Outside of a function
  lambdaTemp <- reac$lambdaTest;
  epsilonTemp <- reac$epsilonTest;
  riskTemp <- reac$riskTest;
  beta <- 0.002;   #transmission rate (per contact)
  c <- 90/365;    #contact rate (contacts per day)
  prev <- 0.01;    #needs some more consideration
  
  run.and.compute.run.stats <- function (
    epsilon = epsilonTemp,  #per contact vaccine efficacy
    lambda = lambdaTemp, #beta*c*prev,
    risk = riskTemp  #risk multiplier
  ) {
    
    param <- param.dcm(lambda = lambda, epsilon = epsilon, risk = risk )
    init <- init.dcm(Sp = 10000, Ip = 0,
                     Sv = 10000, Iv = 0,
                     Sph = 1000, Iph = 0,    #placebo, high risk
                     Spm = 7000, Ipm = 0,   #placebo, medium risk
                     Spl = 2000, Ipl = 0,    #placebo, low risk
                     Svh = 1000, Ivh = 0,    #vaccine
                     Svm = 7000, Ivm = 0,   #vaccine
                     Svl = 2000, Ivl = 0,    #vaccine
                     SIp.flow = 0, SIv.flow = 0, 
                     SIph.flow = 0, SIpm.flow = 0, SIpl.flow = 0,
                     SIvh.flow = 0, SIvm.flow = 0, SIvl.flow = 0)
    
    control <- control.dcm(nsteps = 365*3, new.mod = si_odeFn)
    mod <- dcm(param, init, control)
    #print( mod )
    
    mod.with.stats <- mod.manipulate( mod )
    #print( mod.with.stats )
    mod.with.stats.df <- as.data.frame( mod.with.stats )
    
    # homogeneous risk:
    #hom.VE <- mod.with.stats.df$VE1.inst[target.stats$time]
    # heterogeneous risk:
    het.VE <- mod.with.stats.df$VE2.inst[target.stats$time]
    
    #out <- mod.with.stats.df$rate.Placebo.het[target.stats$time]
    ## Paul changed the placebo incidence out stat as the mean over time up to each time in target.stats$time.
    .x <- mod.with.stats.df$rate.Placebo.het;
    het.meanPlaceboIncidence <-
      sapply( target.stats$time, function( .time ) { mean( .x[ 1:.time ] ) } );
    #out <- .x[ target.stats$time ];
    
    return( c( het.VE = het.VE, het.meanPlaceboIncidence = het.meanPlaceboIncidence ) );
  } # run.and.compute.run.stats (..)
  
  # So for example in the heterogeneous model you can get to the 0.3% placebo incidence and 50% VE with the following parameters, if the other things are at their defaults (10x risk for high risk group, and risk group distribution counts).
  # run.and.compute.run.stats( epsilon = 0.10, lambda = beta*c*prev )
  #                  het.VE het.meanPlaceboIncidence 
  #                0.297827                 2.982687 
  
  # Specify bounds for the initial conditions; these are used as priors.
  # In order of "x" in the above function.
  bounds <- list(#c(0.003, 0.008),      # beta
    #c(60/365, 120/365))    # c 
    epsilon = c(1E-10, 1-(1E-10)),
    #              lambda = c(0.000005, 0.0001),  # lambda
    lambda = c(5E-6, 1E-4), #1E-5),  # lambda
    risk = c(1, 20))            # risk multiplier
  
  ## Trying to use optim. Best for 2 dimensions.
  make.optim.fn <- function ( target ) {
    function( x ) {
      abs( mean( run.and.compute.run.stats( epsilon = x[ 1 ], lambda = x[ 2 ], risk = x[ 3 ] ) - as.numeric( target ) ) );
    }
  }
  
  .f <- make.optim.fn( target.stats[-1] )
  
  lower.bounds <- sapply( bounds, function ( .bounds.for.x ) { .bounds.for.x[ 1 ] } );
  upper.bounds <- sapply( bounds, function ( .bounds.for.x ) { .bounds.for.x[ 2 ] } );
  
  # lambda <- beta*c*prev
  # epsilon <- 0.30  #per contact vaccine efficacy
  # risk <- 10.0   #risk multiplier
  
  # optim( c( epsilon = 0.30, lambda = beta*c*prev, risk = 10 ), .f, lower = lower.bounds, upper = upper.bounds, method = "L-BFGS-B" )
  
  # With three params, optim fails here, presumably because it is nonconvex (multiple optima, saddles, as I have suspected; a potential option is reparameterization, I will think on that, but here we are going with ABC as suggested by Sam.
  
  ### ABC
  make.abc.fn <- function ( target ) {
    function( x ) {
      run.and.compute.run.stats( epsilon = x[ 1 ], lambda = x[ 2 ], risk = x[ 3 ] )
    }
  }
  
  # In order of "x" in the above function.
  priors  <- lapply( bounds, function( .bounds ) { c( "unif", unlist( .bounds ) ) } );
  
  .f.abc <- make.abc.fn( target.stats[-1] )
  fit.rej <- ABC_rejection(model = .f.abc,
                           prior = priors,
                           nb_simul = reac$numExecution,
                           summary_stat_target = as.numeric( target.stats[-1] ),
                           tol = 0.25,
                           progress_bar = TRUE)
  
  fit <- fit.rej
}