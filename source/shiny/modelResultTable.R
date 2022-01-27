
showModelResultTable <- function (output) {

  hvtn705Data <- reactiveFileReader(10000, session = NULL, 
        filePath = "./data/sim.results.hvtn705.100k.threegroup.Rda", load, 
        envir = .GlobalEnv)
  fitRejHvtn705Data <- reactiveFileReader(10000, session = NULL, 
                                    filePath = "./data/fit.rej.hvtn705.100k.threegroup.Rda", load, 
                                    envir = .GlobalEnv)
  
  output$table1 <- renderTable(rownames = TRUE, colnames = FALSE,  {
    hvtn705Data()
    sim.results$sampled.modes
  })
  
  # output$table2 <- renderTable(rownames = TRUE, colnames = FALSE,  {
  #   fitRejHvtn705Data()
  #   browser()
  #   sim.results$sampled.modes
  # })

}