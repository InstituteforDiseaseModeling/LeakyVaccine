
library(shiny)
library(ggplot2)
library(plotly)

library(deSolve)
library(tidyverse)
library(EpiModel)
library(survival)
library(EasyABC)
library(shinythemes)
library(shinycssloaders)

source("model/ve_sim.R")
source("model/sim_fns.R")
source("shiny/tabContent.R")
source("shiny/sim_plots.R")
source("shiny/Paul-visualization.R")
source("shiny/licenseDialog.R")
source("model/modelFitting.R")

server <- function(input, output, session) {
  
  updateTabsetPanel(session, "page-nav", "About this tool")
  
  #-------------------------------------------------------------------------
  # below are the reactiveValues for the Parameter Sweeps tab
  #-------------------------------------------------------------------------
  reacOld <- reactiveValues()
  
  observe({reacOld$beta = input$betaOld})
  observe({reacOld$contactRate = input$contactRateOld})
  observe({reacOld$prev = input$prevOld})
  observe({reacOld$epsilon = input$epsilonOld})
  observe({reacOld$inc = input$incOld})
  observe({reacOld$sampleSize = input$sampleSizeOld})
  observe({reacOld$nsteps = input$nstepsOld})

  output$plotOld1  <-  renderPlotly(runSimByPropHigh(reacOld))
  output$plotOld2  <-  renderPlotly(runSimByInc(reacOld))
  output$plotOld3  <-  renderPlotly(runSimByEpsilon(reacOld))
  
  #-------------------------------------------------------------------------
  # below are the reactiveValues for the Initial Example Plots tab
  #-------------------------------------------------------------------------
  
  reac <- reactiveValues()

  observe({reac$beta = input$beta})
  observe({reac$contactRate = input$contactRate})
  observe({reac$prev = input$prev})
  observe({reac$epsilon = input$epsilon})
  observe({reac$risk = input$risk}) 
  
  #--------------------------------------------------
  # below are the reactiveValues for the Model Fitting tab
  #--------------------------------------------------
  
  observe({reac$lambdaTest = input$lambdaTest})  
  observe({reac$epsilonTest = input$epsilonTest}) 
  observe({reac$riskTest = input$riskTest}) 
  observe({reac$numExecution = input$numExecution}) 
  
  #----------------------
  # plots for the Initial Examples tab
  #----------------------
  
  createCumulativeInfectionsPlot(output, reac)
  createPlaceboRiskPlot(output,reac)
  #createPlaceboVaccinePlot(output,reac)
  createPlaceboVaccineRiskPlot(output,reac)
  createVEPlot(output,reac)
  
  createVisualization(output,reac)
  
  # for the infobutton content
  observeEvent(input$infobutton, {
    createLicenseDialog()
  })
  
}

#------------------------------------------------------------------------------
# for creating UI
#------------------------------------------------------------------------------
ui <- navbarPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesContent.css"),
    tags$head(tags$script(src = "message-handler.js")),
    actionButton(label="", inputId = "infobutton",  width="35px" ,icon = icon("info-circle", class="infoIcon"), class = "infoIconButton")
  ),
  title ="Leaky vaccines and exposure heterogeneity",
  id = "page-nav",
  theme = shinytheme("cerulean"),
  
  #tabs
  getAboutContent(),
  getModelDescriptionContent(),
  getInitialExamplePlotsContent(),
  getParameterSweepContent(),
  getCalibrationContent(),
  getTestTab()
  
)


#Run ----
shinyApp(ui = ui, server=server)
