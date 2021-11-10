#------------------------------------------------------------------------------
# for creating the license dialog
#------------------------------------------------------------------------------

createLicenseDialog <- function() {
 showModal(modalDialog(
   #title = "Important message",
   easyClose = TRUE,
   size = "l",
   #footer = NULL, 
   div(
     tabsetPanel(
       tabPanel("Our License", 
                class='licensePanel',
                HTML("<div class='license'>
                LeakyVaccine is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit <a target='_blank' href='https://creativecommons.org/licenses/by-sa/4.0/legalcode'>https://creativecommons.org/licenses/by-sa/4.0/legalcode</a>
                </div>")),
       tabPanel("Library Licenses", HTML("<div class='license'>to be added...</div>"))
     ),
     class = "licenseTabSet"
   )
 ))
  
}
  