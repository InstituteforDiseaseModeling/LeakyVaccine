
lambda <- 0.003   # per-exposure infection probability
exposures <- seq(1, 1000, by=1)
#infection.probability <- 1 - (1 - lambda)^(exposures)
epsilon = 0.5

infection.probs <- function(lambda, exposures, epsilon){
  
  placebo.infection.probability <- 1 - (1 - lambda)^exposures
  vaccine.infection.probability = 1 - (1 - lambda*(1-epsilon))^exposures
  df <- as.data.frame(cbind(placebo.infection.probability, vaccine.infection.probability))                                                                          
  return(df)
  
}

df <- infection.probs(lambda, exposures, epsilon)

plot(log10(exposures), df$placebo.infection.probability)




