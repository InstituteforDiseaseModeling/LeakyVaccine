## Allen Roberts
## Nov 10, 2021
#@ Demonstrate new changes to ve_sim

## Example parameters. These can either be hard coded or obtained from sliders in shiny.
## Note that "riskMultiplier" is a new parameter that would need to be derived from a slider
## Beta, contactRate, and prev are no longer needed (and those sliders can be eliminated)
param <- list(
  # "beta" = 0.001,
  # "contactRate" = 0.25,
  # "prev" = 0.1,
  "riskMultiplier" = 10,
  "propHigh" = 0.1,
  "epsilon" = 0.3,
  "sampleSize" = 100,
  "inc" = 0.03,
  "nsteps" = 1000
)

source("model/ve_sim.R")

## Sweep over prop_high. Note that overall incidence (inc) is obtained from param (ie, obtained from the shiny slider). Plot title now also displays riskMultiplier (from param)
## In the console, for each value of prop_high, the implied low risk incidence that is needed to achieve the target overall cohort incidence is now printed. 
runSimByPropHigh(param)

## Sweep over overall cohort incidence (inc). Note that prop_high is now obtained from param (ie, obtained from the shiny slider), rather than being hard coded into the function.  Plot title now also displays riskMultiplier (from param)
## In the console, for each value of overall cohort incidence (inc), the implied low risk incidence that is needed to achieve the target overall cohort incidence is now printed. 
runSimByInc(param)

## Sweep over vaccine efficacy (epsilon). Note that prop_high and inc are now obtained from param (ie, obtained from the shiny slider), rather than being hard coded into the function.  Plot title now also displays riskMultiplier (from param)
## In the console, for each value of vaccine effiacy (epsilon), the implied low risk incidence that is needed to achieve the target overall cohort incidence is now printed. However, since epsilon does not affect overall cohort incidence (which is calculated in the absence of a vaccine), this calculation is identical for each value of epsilon. In other words, we keeping inc, prop_high, and risk the same for each value of epsilon.
runSimByEpsilon(param)
