library(DT)

showModelResultTable <- function (input, output) {

  hvtn705Data <- reactiveFileReader(10000, session = NULL, 
        filePath = "./data/sim.results.hvtn705.100k.threegroup.Rda", load, 
        envir = .GlobalEnv)
  # fitRejHvtn705Data <- reactiveFileReader(10000, session = NULL, 
  #                                   filePath = "./data/fit.rej.hvtn705.100k.threegroup.Rda", load, 
  #                                   envir = .GlobalEnv)

  #input$hvtn705column <- 1;
  
  output$table1 <- renderUI({

    hvtn705Data();
    data <- sim.results$sampled.modes

    div(
      tags$script(src = "hvtn705.js"),
      {
      tableHTML<- "<table class='hvtn705table'>";
      rowHTML <- "<td/>";
      for (col in 1:ncol(data)) {
        
        rowHTML <- paste(rowHTML, "<td class='cell'><button class='selectButton' data='" , col , "'>select</button></td>")      
      }
      tableHTML <- paste(tableHTML, "<tr>", rowHTML, "</tr")
      
      
      for (row in 1:nrow(data)) {
        
        rowHTML <- "";
        
        for (col in 1:ncol(data)) {
          val <- data[row,col]
          #browser()
          if (is.list(val))
          {
            name <- names(val)[1]
            
            if (col==1) 
              rowHTML <- paste(rowHTML, "<th class='cell headcol'>", name, "</th>")
            
            rowHTML <- paste(rowHTML, "<td class='cell' data='", col ,"'>", signif(get(name,val), digits=3) , "</td>")
          }
          else
            rowHTML <- paste(rowHTML, "<td>", val , "</td>")
        }
        tableHTML <- paste(tableHTML, "<tr>", rowHTML, "</tr")
      };
      tableHTML<- paste(tableHTML, "</table>");
      
      HTML(tableHTML);
    }, class="tableContainer")
  })
  
  
  output$hvtn705distance <- renderPlot( {
    reac <- c( "zoomFactor" = 10000 );

    input$hvtn705column;
    
    exploreSimResults_hvtn705(reac,input$hvtn705column); 
  })
  

}