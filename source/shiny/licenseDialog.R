#------------------------------------------------------------------------------
# for creating the license dialog
#------------------------------------------------------------------------------



createRows <- function() {

   csvdata <- read.csv('library.csv', header=FALSE)
   
   libraries <- data.frame(csvdata)
   
   result <- ''
   for (row in 1:nrow(libraries)) {
      row <- paste('<tr><td>', libraries[row,1], '</td><td>', libraries[row,2], '</td><td>', libraries[row,3], '</tr>') 
      result <- paste(result, row)
   }
   result
}


createLicenseDialog <- function() {
   
 libRow <- createRows()
   
 showModal(modalDialog(
   easyClose = TRUE,
   size = "l",
   div(
     tabsetPanel(
       tabPanel("Our License", 
                class='licensePanel',
                HTML("<div class='license'>
                LeakyVaccine is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit <a target='_blank' href='https://creativecommons.org/licenses/by-sa/4.0/legalcode'>https://creativecommons.org/licenses/by-sa/4.0/legalcode</a>
                </div>")),
       tabPanel("Library Licenses", HTML(paste("<div class='license'>",
         "<table class='licenseTable'>",
         "<tr><th>Library</th><th>Verson</th><th>License</th></tr>",
         libRow,
         "</table>",
         "</div>")))
     ),
     class = "licenseTabSet"
   )
 ))
  
}


  