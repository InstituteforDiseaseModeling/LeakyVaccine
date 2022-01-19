#------------------------------------------------------------------------------
# for creating the review Privacy & cookies  dialog
#------------------------------------------------------------------------------

library(shinyStore)

showGDPRDialog <- function(session, input) {
  
  #browser()
  if (is.null(input$store$GDPR)) {
    gdprDialog <- modalDialog(
      easyClose = FALSE,
      footer = NULL,
      size = "l",
      class="GDPR_dialog",
      tags$script(" $('#shiny-modal').first().offset({top: $(window).height() - 300});"),
      HTML(paste("<p class='GDPR_title'>PLEASE REVIEW OUR UPDATED PRIVACY & COOKIES NOTICE</p>","
           <p class='GDPR_body'>This site uses cookies and similar technologies to store information on your computer or device. By continuing to use this site, you agree to the placement of these cookies and similar technologies. Read our updated <a href='https://www.gatesfoundation.org/Privacy-and-Cookies-Notice'>Privacy & Cookies Notice</a> to learn more.</p>",
                 "<p class='' ><button id='ok' class='btn btn-default action-button shiny-bound-input'>I AGREE</button</p>"))
      
    )
    showModal(gdprDialog)
  }
  
}

initGDPR <- function(session, input) {
  
  observeEvent(input$ok, {
    updateStore(session,"GDPR", '123')
    removeModal()
  })
  
  observeEvent(input$onload, {
    print(input$store$GDPR);
    showGDPRDialog(session, input)}
  )
}