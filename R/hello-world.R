#' @title hello-world
#' @description a simple function example.
#' 
hello_world <- function(myname){
  cli::cli_alert_success("Hello World! My name is {myname}")
}

#' @title function factory example.
#' @description function factory to create a function that tells you the day of the week
#' n days ago.
days_ago_generator <- function(days_ago=0){
  function(){
    dttm <- Sys.Date()-days_ago
    wkd <- weekdays(dttm)
    if (days_ago == 0){
      cli::cli_alert_info("The day today is {wkd}")
    } else {
      cli::cli_alert_info("{days_ago} days ago, the day was {wkd}")
    }
  }
}
