#------------------------------------------------------------------------------
# for creating cumulative infections plot
#------------------------------------------------------------------------------


createCumulativeInfectionsPlot <- function(output, reac) {
  output$CumulativeInfectionsPlot <- renderPlot({
    mod <- runSim(reac)
    par(mar=c(5, 5, 5, 10), xpd=TRUE)
    plot(mod, y = c("Ip", "total.Iph.Ipm.Ipl"), 
         alpha = 0.8, 
         main = "Cumulative infections in the placebo arm",
         legend = FALSE,
         ylab = "infected",
         xlab = "days",
         col = c("blue", "red"))
    legend("bottomright",
           inset = c(-0.2,0), legend = c("homogeneous risk", "heterogeneous risk"), col = c("blue", "red"), lwd = 2, cex = 0.9, bty = "n")
    })
}

#------------------------------------------------------------------------------
# for creating placebo incidence plot
#------------------------------------------------------------------------------
createPlaceboRiskPlot <- function(output, reac) {
  output$PlaceboRiskPlot <- renderPlot({
    mod <- runSim(reac)
    par(mar=c(5, 5, 5, 10), xpd=TRUE)
    plot(mod, y=c("rate.Placebo", "rate.Placebo.het"),
         alpha = 0.8,
         ylim = c(0, 6.0),
         main = "Incidence in the placebo arm",
         xlab = "days",
         ylab = "infections per 100 person yrs",
         legend = FALSE,
         col = c("blue", "red"))
    legend("bottomright", inset = c(-0.23,0),
           legend = c("homogen. risk", "heterogen. risk"), col = c("blue", "red"), lwd = 2, cex = 0.9, bty = "n")
    
    par(mfrow=c(1,1))
  })
}

#------------------------------------------------------------------------------
# for creating placebo vaccine risk plot
#------------------------------------------------------------------------------
createPlaceboVaccineRiskPlot <- function(output, reac) {
  output$PlaceboVaccineRiskPlot <- renderPlot({
    mod <- runSim(reac)
    par(mar=c(5, 5, 5, 12), xpd=TRUE)
    plot(mod, y=c("rate.Placebo", "rate.Vaccine", "rate.Placebo.het", "rate.Vaccine.het"),
         alpha = 0.8,
         ylim = c(0, 6.0),
         main = "Incidence in placebo and vaccine arms",
         xlab = "days",
         ylab = "infections per 100 person yrs",
         legend = FALSE,
         col = c("blue", "green", "red", "orange"))
    legend("bottomright", inset = c(-0.24,0), legend = c("placebo,\nhomogeneous risk", "vaccine,\nhomogeneous risk", 
                                     "placebo,\nheterogeneous risk", "vaccine,\nheterogeneous risk"),y.intersp=2, 
           col = c("blue", "green", "red", "orange"), lwd = 2, cex = 0.9, bty = "n")
  })
}

#------------------------------------------------------------------------------
# for creating vaccine efficacy plot
#------------------------------------------------------------------------------
createVEPlot <- function(output, reac) {
  output$VEPlot <- renderPlot({
    mod <- runSim(reac)
    par(mar=c(5, 5, 5, 10), xpd=TRUE)
    plot(mod, y=c("VE1.inst", "VE2.inst"),
       alpha = 0.8,
       main = "Clinical vaccine efficacy",
       legend = FALSE, 
       xlab = "days",
       ylab = "Clinical vaccine efficacy",
       col = c("blue", "red"))
    legend("topright", inset = c(-0.2,0), y.intersp=2, 
           legend = c("VE, \nhomogeneous risk", "VE, \nheterogeneous risk"), col = c("blue", "red"), lwd = 2, cex = 0.9, bty = "n")
  })
  
}

