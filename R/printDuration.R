#' [+!] Evaluate how much time passed
#'
#' Evaluate and print difference between moment of time at which time
#' interval began (usually captured by function \code{\link[base]{Sys.time}} some time ago) and
#' the present (i.e., moment when function \code{printDuration} is called).
#'
#'
#' @param Start,start Moment of time which is treated as the beggining (object of class
#' \code{\link[=POSIXct-class]{POSIXct}}).
#'
#' @param End,end Moment of time which is treated as the end (object of class
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
#' ## [1] "Analysis completed in 2.4 mins"
#'
#' @family \pkg{spMisc} utilities
#' @author Vilmantas Gegzna
#'
printDuration <- function(Start,
                          Message = "Analysis completed in",
                          returnString = FALSE,
                          End = Sys.time()){
    Duration_of_analysis <- End - Start;
    AnDuration <- paste(Message,
                        round(Duration_of_analysis, 1),
                        attributes(Duration_of_analysis)$units
    )

    if (returnString == T) return(AnDuration) else  pander::pander(AnDuration)
}

#' @rdname printDuration
#' @export
#' @family \pkg{spMisc} utilities
#' @author Vilmantas Gegzna
time_elapsed <- function(start = stop("'start' is missing"), end = Sys.time()){
    DIFFERENCE <- end - start
    AnDuration <- paste(round(DIFFERENCE, 1),
                        attributes(DIFFERENCE)$units
    )

    return(AnDuration)
}
