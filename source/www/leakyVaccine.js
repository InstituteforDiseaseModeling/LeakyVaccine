

$(document).on("shiny:connected", function(event) {
  Shiny.setInputValue("onload", 1);
})
