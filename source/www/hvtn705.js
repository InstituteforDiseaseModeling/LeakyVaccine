
  $(".hvtn705table td button").on("click", function (e) {
    
    let col = parseInt(e.currentTarget.getAttribute("data"))

    Shiny.setInputValue("hvtn705column", col);

  })