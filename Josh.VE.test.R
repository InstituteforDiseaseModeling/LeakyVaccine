
#beta <- 0.003   # per-exposure infection probability
#(1 - beta)  # per-exposure probability of remaining negative
#(1 - beta)^exposures  # probability of remaining negative after # of exposures
#1 - (1 - beta)^(exposures) # probability of infection after # of exposures

#epsilon = 0.3
exposures <- seq(1, 1000, by=1)

# Function to calculate cumulative infection probabilities
infection.probs <- function(beta, exposures, epsilon){
  placebo.infection.probability <- 1 - (1 - beta)^exposures
  vaccine.infection.probability <- 1 - (1 - (1-epsilon)*beta)^exposures
  df <- as.data.frame(cbind(placebo.infection.probability, vaccine.infection.probability))
  df$VE <- 1 - (df$vaccine.infection.probability/df$placebo.infection.probability)
  df$exposures <- exposures
  return(df)
}

df.beta.001 <- infection.probs(beta = 0.001, exposures, epsilon = 0.5)
df.beta.008 <- infection.probs(beta = 0.008, exposures, epsilon = 0.5)

### Plot of cumulative infection probability ###

plot(exposures, df.beta.001$placebo.infection.probability, 
     log = "x",
     col = "red",
     xlab = "HIV exposures (log10)",
     ylab = "cumulative infection probability",
     xaxt = "n",
     yaxt = "n",
     ylim = c(0, 1),
     main = "epsilon (per-contact efficacy) = 0.5",
     cex = 0.5,
     pch = 16)
axis(1, c(1, 10, 100, 1000))
axis(2, seq(0, 1, 0.25), las=2)     
legend("topleft", legend = c("placebo, beta = 0.001", 
                             "vaccine, beta = 0.001",
                             "placebo, beta = 0.008",
                             "vaccine, beta = 0.008"),
                col = c("red", "orange", "blue4", "blue"), 
                pch = 16,
                cex = 0.75,
                bty = "n")
points(exposures, df.beta.001$vaccine.infection.probability, pch = 16, cex = 0.5, col = "orange")
points(exposures, df.beta.008$placebo.infection.probability, pch = 16, cex = 0.5, col = "blue4")
points(exposures, df.beta.008$vaccine.infection.probability, pch = 16, cex = 0.5, col = "blue")

### Plot of clinical vaccine efficacy ###

plot(exposures, df.beta.001$VE,
     ylim = c(0, 1),
     log = "x",
     xaxt = "n",
     yaxt = "n",
     xlab = "HIV exposures (log10)",
     ylab = "clinical vaccine efficacy",
     col = "red",
     main = "epsilon (per-contact efficacy) = 0.5",
     cex = 0.5)
axis(1, c(1, 10, 100, 1000))
axis(2, seq(0, 1, 0.25), las=2)  
legend("topleft", legend = c("beta = 0.001", 
                             "beta = 0.008"),
       col = c("red", "blue"), 
       pch = c(1, 2),
       cex = 0.75,
       bty = "n")
points(exposures, df.beta.008$VE, pch = 2, cex = 0.5, col = "blue")


