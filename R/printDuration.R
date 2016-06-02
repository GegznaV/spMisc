#' [+] Evaluate how much time passed
#'
#' Evaluate and print difference between moment of time at which time
#' interval began (usually captured by function \code{\link[base]{Sys.time}} some time ago) and
#' the present (i.e., moment when function \code{printDuration} is called).
#'
#'
#' @param Start Moment of time which is treated as a beggining (object of class
#' \code{\link[=POSIXct-class]{POSIXct}}).
#'
#' @param Message Message before time stamp that describes it. Default is
#'         \code{"Duration of analysis:"}
#' @param returnString If \code{TRUE}, returns result as a string.
#'  If \code{FALSE} (default), function \code{\link[pander]{pander}} prints the
#'  result.
#'
#' @return Text indicating how much time has passed (either printed in console or as a string).
#' @export
#' @seealso \code{\link[base]{difftime}}
#' @examples
#' Start <-  Sys.time()
#'
#' Start
#' ## [1] "2016-02-12 16:15:09 UTC"
#'
#' class(Start)
#' ## [1] "POSIXct" "POSIXt"
#'
#' printDuration(Start)
#' ## Duration of analysis: 23.3 secs
#'
#' printDuration(Start,"From start till now")
#' ## From start till now 39.2 secs
#'
#' my_duration <- printDuration(Start)
#' my_duration
#' ## NULL
#'
#' my_duration <- printDuration(Start, returnString = TRUE)
#' my_duration
#' ## Analysis completed in 2.4 mins
#'
#' @family \pkg{spHelper} utilities
#' @author Vilmantas Gegzna
#'
printDuration <- function(Start,
                          Message = "Analysis completed in",
                          returnString = FALSE){
    Duration_of_analysis <- Sys.time() - Start;
    AnDuration <- paste(Message,
                        round(Duration_of_analysis, 1),
                        attributes(Duration_of_analysis)$units
    )

    if (returnString == T) return(AnDuration) else  pander::pander(AnDuration)
}
