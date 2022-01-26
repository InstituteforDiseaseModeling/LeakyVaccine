
#------------------------------------------------------------------------------
# for creating About tab content
#------------------------------------------------------------------------------
getAboutContent <- function() {
  return(tabPanel("About",
                   
    HTML("<div class='mainPanel main'>"),
    p("This is an online tool to explore the effects of exposure heterogeneity on HIV vaccine efficacy, given a leaky vaccine."),
    p("A potential outcome of exposure heterogeneity is that vaccine efficacy measured from a trial (i.e. the clinical efficacy) is lower than the biological vaccine efficacy (i.e. the per-exposure or per-contact vaccine efficacy). This distinction, between the per-exposure vaccine efficacy and the clinical efficacy, or the population effectiveness, of the same vaccine, is our focus."),
    p("Many authors have previously explored this issue, e.g. Halloran et al., 1992; White et al., 2010; O'Hagan et al., 2013; Edlefsen, 2014; Coley et al., 2016; Gomes et al., 2016; Kahn et al., 2018."), 
    p("From M. Gomes et al., 2016:  \"This effect is more pronounced in the control group as individuals within it experience higher rates of infection overall. Consequently, the ratio of disease rates in vaccinated over control groups increases, and vaccine efficacy, as measured by simple rate ratios, decreases as the trial progresses. Finally, the magnitude of this effect increases with the intensity of transmission.\"  "),
    p("Here we use simple epidemic models to explore this issue, within and across populations, in the context of HIV prevention trials or longitudinal studies. Our goals are to:"),
    HTML("<ol type='1'>"),
    HTML("<li>Raise awareness of the distinction between per-exposure vaccine efficacy, clinical vaccine efficacy, and population vaccine effectiveness.</li>"),
    HTML("<li>Assess if this effect might contribute to the difference between the RV144 and HVTN 702 vaccine trial outcomes.</li>"),
    #HTML("<li>In acute infection studies it seems like many participants get infected early. What is the magnitude of this effect that might be due to frailty bias?</li>"),
    HTML("<li>Assist in the design or interpretation of HIV prevention trials, from this exposure heterogeneity framework.</li>"),
    HTML("</ol>"),
    p("The separate tabs in this R Shiny app include:"),
    HTML("<ol type='1'>"),
    HTML("<li>Model description, showing the structure of the model and the parameters included.</li>"),
    HTML("<li>Initial example plots, showing how the model works and what simulated epidemic and trial outputs we focus on.</li>"),
    HTML("<li>Parameter sweeps, which allows you to compare the impact of multiple parameter values in the same plots.</li>"),
    HTML("<li>Model fitting, in which we use the model to examine specific trial results.</li>"),
    HTML("</ul>"),
    HTML("</div>"),
    titlePanel(htmlTemplate("template.html"))
  ))
}


#------------------------------------------------------------------------------
# for creating Model Description tab content
#------------------------------------------------------------------------------
getModelDescriptionContent <- function() {
  return(tabPanel("Model description",
    class="modelDescription",
    HTML("<div class='mainPanel main'>"),
    h3("Model structure"),
    p("We model a vaccine trial using an SI deterministic compartmental model; this is a simple epidemic model that has two populations, the Susceptible (S) and the Infected (I).
    We start the model with all trial individuals in the S group; over time S individuals move into the I group as they become infected."), 
    HTML("<p>Note that this is specfically a vaccine trial model and not a more commonly used epidemic model (e.g. there are no births or deaths, and no recovery); we are not modeling infections from the I to S compartments, but rather only infections from a theoretical, un-modeled, outside (non-trial) population.
    We do this with one parameter, <code>lambda</code>, which is the rate that individuals in S get infected (move to I). This model structure also removes the possibility of indirect effects from vaccination.</p>"),
    h3("Parameters"),
    HTML(paste("<div class='code'>", 
               "<div class='flex'><div class='definition'>beta</div><div>transmission rate (per contact)</div></div>",
               "<div class='flex'><div class='definition'>c</div><div>exposure rate (serodiscordant sexual contacts per time)</div></div>",
               "<div class='flex'><div class='definition'>prev</div><div>prevalence  (prevalence of viremic individuals)</div></div>",
               "<div class='flex'><div class='definition'>lambda</div><div>lambda = beta * c * prev (this parameter defines the rate of infection)</div></div>",
               "<div class='flex'><div class='definition'>risk</div><div>risk multiplier</div></div>",
               "<div class='flex'><div class='definition'>epsilon</div><div>per contact vaccine efficacy; vaccine-induced reduction in the risk of HIV infection from a single exposure</div></div>",
               "</div><br/>")),
    HTML("<p>The infection rate per time step is a combination of population prevalence <code>prev</code> (of viremic individuals), the exposure rate
    (serodiscordant sexual exposure per time) <code>c</code>, and the transmission rate (per exposure) <code>beta</code>.</p>"),
    HTML("<p>The per exposure effect of vaccination is <code>epsilon</code>; <code>epsilon</code> is not time-varying (the per-exposure vaccine effect does not decay over time) and assumes a homogeneous effect
    (does not vary by viral genotype or individual traits).</p>"),
    HTML("<p>We include three subgroups in the heterogeneous exposure population: high, medium, and low exposure. 
    In reality we never fully know the correct size of HIV risk subgroups (i.e. fraction of the population) or their relative contribution to overall incidence.</p>"),
    HTML("<p>The <code>risk</code> parameter (the risk multiplier) is an amalgam of increases in transmission risk that could be due to higher per-contact transmission or infection risk,
    higher exposure rate (number of contacts), or higher prevalence of HIV viremia in partners. Individual risk of infection can vary for
    these separately or in combination. Note that exposure heterogeneity, i.e. variation among individuals in the risk of infection, is most commonly discussed as variation in the number of HIV exposures.
    It can also include variation in the individual per-contact risk of acquisition, perhaps due to co-infections, viral load in the source individual or host genetics. Our <code>risk</code> parameter only multiplies the baseline risk of the medium risk subgroup, and it 
    possible (in the underlying code) for the low risk subgroup to have zero risk.</p>"),
    HTML("</div>"),
    titlePanel(htmlTemplate("template.html"))
  ))
}


#------------------------------------------------------------------------------
# for creating Initial Example Plots tab content
#------------------------------------------------------------------------------

getInitialExamplePlotsContent <- function() {
  tabPanel("Initial example plots", 
           HTML("<div class='mainPanel'>"),
             mainPanel(
               p("The plots below allow you to see how the model works. You can change individual parameter values and observe the resulting changes in infections, incidence, and clinical vaccine efficacy."),
               class = "initialSampleTextHeader"
             ),
            mainPanel(
             #class = "mainPanel",
             sidebarPanel(  
               sliderInput('beta', 'beta (per-contact transmission probability):', min=0.001, max=0.01,
                           value=0.004, step=0.001, round=-4),
               sliderInput('contactRate', 'c (sexual contacts per day):', min=0.001, max=1,
                           value=90/365, step=0.01, round=FALSE),
               sliderInput('prev', 'prev (population prevalence of viremic individuals):', min=0.001, max=0.3,
                           value=0.10, step=0.1, round=FALSE),
               sliderInput('epsilon', 'epsilon (per-exposure vaccine efficacy):', min=0, max=1,
                           value=0.5, step=0.1, round=FALSE),
               sliderInput('risk', 'risk (risk multiplier; relative force of infection for high risk group):', min=0, max=100,
                           value=25, step=1, round=FALSE),
               class="sidePanel"
             ),
             mainPanel(
              plotOutput("CumulativeInfectionsPlot") %>% withSpinner(color="#0dc5c1"),
              p("Figure 1. Cumulative infections in the placebo arms of a vaccine trial, for populations with homogeneous risk and heterogeneous risk. Note that the infections in the heterogeneous risk population accumulate faster early in the trial, as the high-risk individuals are infected."),
              plotOutput("PlaceboRiskPlot") %>% withSpinner(color="#0dc5c1"),
              p("Figure 2. Incidence in the placebo arm of a vaccine trial. As expected from the cumulative infections plot above, the incidence in the heterogeneous risk population decreases over the course of the trial."),
              plotOutput("PlaceboVaccineRiskPlot") %>% withSpinner(color="#0dc5c1"),
              p("Figure 3. Incidence in the placebo and vaccine arms of a trial, for populations with homogeneous risk and heterogeneous risk."),
              plotOutput("VEPlot") %>% withSpinner(color="#0dc5c1"),
              p("Figure 4. Clinical vaccine efficacy over time in two vaccine trial population trials, one with homogeneous risk and the other with heterogeneous risk. 
              Remember that the per-exposure vaccine is the value of the epsilon slider on the left."),
              class = "plotPanel"
             ),
             class = "mainInitialExampleContent"
            ),
           HTML("</div>"),
           titlePanel(htmlTemplate("template.html"))
           
  )
}



#------------------------------------------------------------------------------
# for creating Parameter Sweeps content
#------------------------------------------------------------------------------
getParameterSweepContent <- function() {
  tabPanel("Parameter sweeps", 
           HTML("<div class='mainPanel'>"),
           mainPanel(
             p("The plots below allow you to see how clinical vaccine efficacy changes over the course of a trial under a range of parameter values."),
             class = "initialSampleTextHeader"
           ),
           mainPanel(
             sidebarPanel(  
               sliderInput('sweepRiskMultiplier', 'risk (risk multiplier; relative force of infection for high risk group):', min=1, max=50,
                           value=20, step=1, round=FALSE),
               sliderInput('sweepEpsilon', 'epsilon (per-exposure vaccine efficacy):', min=0, max=1,
                           value=0.5, step=0.05, round=FALSE),
               sliderInput('sweepPropHigh', 'proportion high risk:', min=0.01, max=0.5,
                           value=0.1, step=0.01, round=FALSE),
               sliderInput('sweepN', 'size of each trial arm:', min=0, max=10000,
                           value=5000, step=500, round=FALSE),
               sliderInput('sweepInc', 'annual incidence (%)', min=0.5, max=6,
                           value=3, step=0.5, round=FALSE),
               sliderInput('sweepNsteps', 'time (1 to 5 years):', min=1, max=5,
                           value=3, step=0.5, round=FALSE),
               class = "sidePanel"
             ),
             
             mainPanel(
               plotlyOutput("plotOld1") %>% withSpinner(color="#0dc5c1"),
               p("Figure 1. The effect of varying the size of the high-risk subgroup in a vaccine trial population.
               On the left is clinical vaccine efficacy measured using cumulative incidence.
               On the right is clinical vaccine efficacy measured using instantaneous incidence, or hazard."),
               plotlyOutput("plotOld2") %>% withSpinner(color="#0dc5c1"),
               p("Figure 2. The effect of varying the overall incidence in a vaccine trial population."), 
               plotlyOutput("plotOld3") %>% withSpinner(color="#0dc5c1"),
               p("Figure 3. The effect of varying the per-exposure vaccine efficacy (epsilon) in a vaccine trial population."), 
               class = "plotPanel"
             ),
             class = "mainInitialExampleContent"
           ),
           HTML("</div>"),
           titlePanel(htmlTemplate("template.html"))
           
  )
}

#------------------------------------------------------------------------------
# for creating Calibration tab content
#------------------------------------------------------------------------------
getCalibrationContent <- function() {
  tabPanel("Calibration",
           HTML("<div class='mainPanel main'>"),
           p("We use calibration to find model parameter settings that produce model outputs that are consistent with some target values."),
           p("We used an initial set of transmission parameters for sub-Saharan Africa borrowing from an SIR model from Alain Vandormael (2018): 
             'We used realistic parameter values for the SIR model, based on earlier HIV studies that have been undertaken in the sub-Saharan Africa context. 
             To this extent, we varied `c` within the range of 50 to 120 sexual acts per year based on data collected from serodiscordant couples across 
             eastern and southern African sites. Previous research has shown considerable heterogeneity in the probability of HIV transmission per sexual contact, 
             largely due to factors associated with the viral load level, genital ulcer disease, stage of HIV progression, condom use, circumcision and use of ART. 
             Following a systematic review of this topic by Boily et al., we selected values for `beta` within the range of 0.003–0.008. 
             Here, we chose values for `v` within the range of 0.15–0.35, which are slightly conservative, but supported by population-based estimates from the 
             sub-Saharan African context."),
           HTML(paste("<div class='code'>", 
                      "<div class='flex'><div class='definition'>c</div><div>varies from 50 to 120 per year</div></div>",
                      "<div class='flex'><div class='definition'>beta</div><div>varies from 0.003 to 0.008</div></div>",
                      "<div class='flex'><div class='definition'>prev</div><div>which here is population prevalence of unsuppressed VL, varies from 0.15 to 0.35</div></div>",
                      "<div class='flex'><div class='definition'>Sv</div><div>could be parameterized using the RV144 Thai Trial results: VE = 61% at 12 months, 31% at 42 months, but below we start with 30% and no waning efficacy. A vaccine duration parameter is not needed because we are only modeling a 3 year trial without boosters.</div></div>",
                      "</div>")),
           HTML("</div>"),
           titlePanel(htmlTemplate("template.html"))
           
  )
}

#------------------------------------------------------------------------------
# for creating Model Fitting tab content (Fitting the model to specific trial data)
#------------------------------------------------------------------------------

getModelFittingTab <- function() {
  tabPanel("Model fitting", 
           
           HTML("<div class='mainPanel'>"),
           mainPanel(
             p("The plots below allow you to ..."),
             class = "initialSampleTextHeader"
           ),
           mainPanel(
             sidebarPanel(  
               sliderInput('lambdaTest', 'lambda:', min=0.000005, max=0.0001,
                           value=0.000028, step=0.000001, round=FALSE),
               sliderInput('epsilonTest', 'epilson:', min=0.0, max=1.0,
                           value=0.40, step=0.05, round=FALSE),
               sliderInput('riskTest', 'risk:', min=0, max=30,
                           value=10.0, step=1, round=FALSE),
               sliderInput('numExecution', '# of execution:', min=50, max=200,
                           value=100, step=50, round=FALSE),
               class = "slider"
             ),
             
             mainPanel(
               p("What combinations of per-exposure VE and risk heterogeneity are consistent with specific clinical HIV trial VEs?."),
               plotOutput("plotTestLambdaRisk")  %>% withSpinner(color="#0dc5c1"),
               p("..."),
               plotOutput("plotTestEspilonRisk")  %>% withSpinner(color="#0dc5c1"),
               p("..."),
               plotOutput("plotTestEpsilonLambda")  %>% withSpinner(color="#0dc5c1"),
               class = "plotPanel"
               
             ),class = "mainInitialExampleContent"
           ),
           HTML("</div>"),
           titlePanel(htmlTemplate("template.html"))
           
  )
}



